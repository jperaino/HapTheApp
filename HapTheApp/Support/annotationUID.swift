//
//  annotationUID.swift
//  HapTheApp
//
//  Created by Jim Peraino on 2/9/18.
//  Copyright © 2018 James Peraino. All rights reserved.
//

import Foundation
import MapKit

class annotationUID: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var UID: String?
    var title: String?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
    
    
}
