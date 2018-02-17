//
//  Helpers.swift
//  HapTheApp
//
//  Created by Jim Peraino on 2/5/18.
//  Copyright © 2018 James Peraino. All rights reserved.
//

import Foundation
import CoreLocation
import Firebase
import FirebaseAuthUI


class helpers {
    
    // MARK: - Functions
    
    static func calculateDistance(dataSnapshot: DataSnapshot) -> Double {

        let place = dataSnapshot.value as! [String:String]

        // Calculate distance from current location:
        let placeLat = place[Constants.PlaceFields.placeLat]
        let placeLong = place[Constants.PlaceFields.placeLong]
        let placeCoordinates = CLLocation(latitude: Double(placeLat!)!, longitude: Double(placeLong!)!)
        
        let distanceInMeters = gMapsViewController.currentLocation!.distance(from: placeCoordinates)
        let distanceInMiles = distanceInMeters*0.000621371

        return distanceInMiles
    }
    
    static func calculateDistance(coordinate: CLLocationCoordinate2D) -> Double {
        
        let placeLat = coordinate.latitude
        let placeLong = coordinate.longitude
        let placeCoordinates = CLLocation(latitude: Double(placeLat), longitude: Double(placeLong))
        
        
        let distanceInMeters = gMapsViewController.currentLocation!.distance(from: placeCoordinates as CLLocation)
        let distanceInMiles = distanceInMeters*0.000621371
        
        return distanceInMiles
    }
    
    
    
    
}



public extension Date {
    func toString( dateFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}








