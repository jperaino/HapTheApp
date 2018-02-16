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
        
        guard let value = snapshot.value as? [String: String] else { return }
        
        self.placeID = value[Constants.blurbFields.PID]!
        self.comment = value[Constants.blurbFields.comment]!
        self.postDate = NSDate() as Date! // MARK: TODO - Add post date
        self.userID = value[Constants.blurbFields.UID]!
        self.sentiment = value[Constants.blurbFields.sentiment]!
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
