//
//  mapMaker.swift
//  HapTheApp
//
//  Created by Jim Peraino on 2/11/18.
//  Copyright © 2018 James Peraino. All rights reserved.
//

import Foundation
import GoogleMaps
import GooglePlaces
import Firebase

extension gMapsViewController {
    
    func addTempMarker(place: GMSPlace) {
        
        // Remove existing marker if there's one
        if let currentMarker = newPlaceMarker {
            currentMarker.map = nil
        }
        
        // Create a new marker
        let position = place.coordinate
        newPlaceMarker = GMSMarker(position: position)
        newPlaceMarker!.title = place.name
        newPlaceMarker!.icon = #imageLiteral(resourceName: "pin-mark-blank")
        newPlaceMarker!.map = mapView
        print(mapView)
        
        mapView.animate(toLocation: position)
    }
    
    
    func addSavedMarkers() {
        print("adding saved markers...")
        print(mainVC.places.count)
        
        for item in mainVC.places {
            addMarker(snapshot: item)
        }
    }
    
    func addMarker(snapshot: DataSnapshot) {
        
        print("beginning to add marker...")
        
        let place = snapshot.value as! [String:String]
        
        
        // Retrieve date from firebase
        let placeLat = place[Constants.PlaceFields.placeLat]
        let placeLong = place[Constants.PlaceFields.placeLong]
        let placeName = place[Constants.PlaceFields.placeName]
        
        print("adding marker for: \(placeName!)")
        
        // Calculate values
        let placeCoordinates = CLLocationCoordinate2D(latitude: Double(placeLat!)!, longitude: Double(placeLong!)!)
    
        // Create a new marker
        let nPlaceMarker = GMSMarker()
        nPlaceMarker.position = placeCoordinates
        nPlaceMarker.title = placeName!
        nPlaceMarker.icon = #imageLiteral(resourceName: "pin-mark-flag")
        nPlaceMarker.map = mapView
        print(mapView)
        
    }
    
    
    
    
    
    
    // Populate map with saved places.
    
    
    
    //        for item in mainVC.places {
    //            populateMap(snapshot: item)
    //        }
    
    //
    //        func populateMapItem(snapshot: DataSnapshot) {
    //            //        mapView.remove(mapView.annotations as! MKOverlay)
    //            print("map items count: " + String(mainVC.places.count))
    //
    //            let place = snapshot.value as! [String:String]
    //
    //            let placeLat = place[Constants.PlaceFields.placeLat]
    //            let placeLong = place[Constants.PlaceFields.placeLong]
    //            let placeCoordinates = CLLocation(latitude: Double(placeLat!)!, longitude: Double(placeLong!)!)
    //
    //            let annotation = MKPointAnnotation()
    //
    //
    //            annotation.coordinate = placeCoordinates.coordinate
    //            annotation.title = place[Constants.PlaceFields.placeName]
    //
    //            //        if place[Constants.PlaceFields.UID] == UID! {
    //            //
    //            //            annotation.pointTintColor = UIColor.green
    //            //
    //            //
    //            //        }
    //
    //
    //
    //            mapView.addAnnotation(annotation)
    //            print("point was added" + String(mapView.annotations.count))
    //
    //
    //        }
    //
    //    }
    
    
    
    
}
