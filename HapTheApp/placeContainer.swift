//
//  placeContainer.swift
//  HapTheApp
//
//  Created by Jim Peraino on 2/7/18.
//  Copyright © 2018 James Peraino. All rights reserved.
//

import Foundation
import Firebase


class placeContainer: NSObject {
    
    // MARK: - Properties
    
    var dataSnapshot: DataSnapshot
    var distance: Double?
    
    // MARK: - Initialization
    
    init?(dataSnapshot: DataSnapshot, distance: Double?) {
        
        // Initialize stored properties.
        self.dataSnapshot = dataSnapshot
        self.distance = distance
    }
        
}

