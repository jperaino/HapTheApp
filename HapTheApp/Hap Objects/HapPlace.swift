//
//  HapPlace.swift
//  HapTheApp
//
//  Created by Jim Peraino on 2/16/18.
//  Copyright © 2018 James Peraino. All rights reserved.
//

import Foundation
import Firebase
import CoreLocation
import GooglePlaces

class HapPlace: NSObject {
    // Firebase Variables
    var placeID = ""
    // Google Places Variables
    var name = ""
    var coordinates: CLLocationCoordinate2D?
    var address = ""
    var city = ""
    // Calculated Variables
    var dateDownloaded: Date!
    var blurbs: [HapBlurb]!
    
    
    // MARK: Initialize from a PlaceID
    init(gPID: GMSPlace) {
        let timestamp = NSDate() as! Date
    
        // Complete Init
        self.placeID = gPID.placeID
        self.name = gPID.name
        self.coordinates = gPID.coordinate
        self.address = gPID.formattedAddress!
        self.city = "todo"
        self.dateDownloaded = timestamp
        self.blurbs = []
    }
    

}
