//
//  blurbHandlers.swift
//  HapTheApp
//
//  Created by Jim Peraino on 2/17/18.
//  Copyright © 2018 James Peraino. All rights reserved.
//

import Foundation
import GooglePlaces

extension mainVC {
    
    // TODO - BUG: Need to handle this asynchronously because blurbs come in from firebase faster than they can enter the array, so dupicates happen.
    func handleIncomingBlurb(blurb: HapBlurb) {
        
        
        // Check to see if blurb's place exists
        for index in mainVC.hapPlacesArray.indices {
            print("Checking if blurb's place exists")
            
            // If blurb's place does already exist...
            if mainVC.hapPlacesArray[index].placeID == blurb.placeID {
                print("Place already exists")
                
                // Check if blurb already exists...
                for cIndex in mainVC.hapPlacesArray[index].blurbs.indices {
                    print("Checking blurbs")
                    
                    // If blurb's ID already exists...
                    if mainVC.hapPlacesArray[index].blurbs[cIndex].blurbID == blurb.blurbID {
                        print("Blurb already exists")
                        
                        // Update the blurb.
                        mainVC.hapPlacesArray[index].blurbs[cIndex] = blurb
                        print("Updated blurb for \(mainVC.hapPlacesArray[index].name)")
                        return
                    }
                }
                
                // If place exists but blurb doesn't...
                mainVC.hapPlacesArray[index].blurbs.append(blurb)
                print("Added new blurb for \(mainVC.hapPlacesArray[index].name)")
                print(mainVC.hapPlacesArray[index].blurbs.count)
                return
            }
        }
        
        // Create new place if blurb place doesn't exist....
        print("Place for blurb doesn't yet exist. Creating a new place...")
        handleNewPlace(blurb: blurb)
    }
    
    func handleNewPlace(blurb: HapBlurb) {
        
        let placeID = blurb.placeID
        print("Creating new place for: \(placeID)")
        
        // Look up GMSPlace from PlaceID String
        self.placesClient.lookUpPlaceID(placeID, callback: { (place, error) in
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            guard let place = place else {
                print("No place details for \(placeID)")
                return
            }
            
            // Initialize HapPlace with new GMSPlace and Blurb
            var newPlace = self.initializeHapPlace(place: place)
            newPlace.blurbs.append(blurb)
            
            print("Adding \(newPlace.name) to array with blurb")
            mainVC.hapPlacesArray.append(newPlace)
        })
    }
    
    func initializeHapPlace(place: GMSPlace) -> HapPlace {
        
        let happyPlace = HapPlace(gPID: place)
        
        print("Created new HapPlace.........")
        print(happyPlace.name)
        print(happyPlace.placeID)
        print(happyPlace.address)
        print(happyPlace.city)
        print(happyPlace.blurbs)
        print(happyPlace.coordinates)
        print(happyPlace.dateDownloaded)
        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        
        return happyPlace
        
    }
    
    
    
    
}
