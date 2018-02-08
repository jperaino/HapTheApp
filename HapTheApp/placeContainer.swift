//
//  placeContainer.swift
//  HapTheApp
//
//  Created by Jim Peraino on 2/7/18.
//  Copyright © 2018 James Peraino. All rights reserved.
//

import Foundation
import Firebase
import CoreLocation


class placeContainer: NSObject {
    
    // MARK: - Properties
    
    var dataSnapshot: DataSnapshot
    var distance: Double?
    var UID: String
    
    // MARK: - Initialization
    
    init?(dataSnapshot: DataSnapshot) {
        
        self.dataSnapshot = dataSnapshot
        let distanceInMiles = helpers.calculateDistance(dataSnapshot: dataSnapshot)
        
        // Initialize stored properties.
        self.dataSnapshot = dataSnapshot
        self.distance = distanceInMiles
        self.UID = dataSnapshot.key
    }
    
    // MARK: - Functions
    
    
    
    
    
}

