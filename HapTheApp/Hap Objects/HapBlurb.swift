//
//  HapBlurb.swift
//  HapTheApp
//
//  Created by Jim Peraino on 2/16/18.
//  Copyright © 2018 James Peraino. All rights reserved.
//

import Foundation
import Firebase

class HapBlurb: NSObject {
    var blurbID = ""
    var placeID = ""
    var comment = ""
    var postDate: Date!
    var userID = ""
    var sentiment = ""
    
    
    // Initialize from Firebase Snapshot
    init(snapshot: DataSnapshot) {
        self.blurbID = snapshot.key
        
        print(snapshot.value)
        
        guard let value = snapshot.value as? [String: Any] else { return }
        
        self.placeID = value[Constants.blurbFields.PID] as! String
        self.comment = value[Constants.blurbFields.comment] as! String
        self.postDate = NSDate() as Date! // MARK: TODO - Add post date
        self.userID = value[Constants.blurbFields.UID] as! String
        self.sentiment = value[Constants.blurbFields.sentiment] as! String
    }
    
    // Initialize from User Action
    init(blurbID: String, placeID: String, comment: String, sentiment: String) {
        self.blurbID = blurbID
        self.placeID = placeID
        self.comment = comment
        self.postDate = NSDate() as Date! // MARK: TODO - Add post date
        self.userID = (Auth.auth().currentUser?.uid)!
        self.sentiment = sentiment
    }
    
    
}
