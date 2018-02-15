//
//  sortPlaces.swift
//  HapTheApp
//
//  Created by Jim Peraino on 2/15/18.
//  Copyright © 2018 James Peraino. All rights reserved.
//

import Foundation


extension gMapsViewController {
    

    
    func sortArraysByDistance() {
        
        print("sorting arrays...." )
        mainVC.places.sort(by: { helpers.calculateDistance(dataSnapshot: $0) < helpers.calculateDistance(dataSnapshot: $1) })
        mainVC.privatePlaces.sort(by: { helpers.calculateDistance(dataSnapshot: $0) < helpers.calculateDistance(dataSnapshot: $1) })
        
        
    }
    
    
    
    
    
    
    
}


