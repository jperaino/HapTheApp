//
//  backMenuItem.swift
//  HapTheApp
//
//  Created by Jim Peraino on 2/9/18.
//  Copyright © 2018 James Peraino. All rights reserved.
//

import Foundation


class backMenuItem: NSObject {
    
    var title: String
    var action: String?
    
    init(title: String, action: String?) {
        self.title = title
        self.action = action
    }

}

