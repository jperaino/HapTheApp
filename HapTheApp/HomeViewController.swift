//
//  HomeViewController.swift
//  HapTheApp
//
//  Created by Jim Peraino on 2/3/18.
//  Copyright © 2018 James Peraino. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseGoogleAuthUI
import FirebaseFacebookAuthUI

class HomeViewController: UIViewController, UINavigationControllerDelegate {
    
    // MARK: Properties
    
    var ref: DatabaseReference!
    var savedPlaces: [DataSnapshot]! = []
    var storageRef: StorageReference!
    var keyboardOnScreen = false
    fileprivate var _refHandle: DatabaseHandle!
    fileprivate var _authHandle: AuthStateDidChangeListenerHandle!
    var user: User?
    var displayName = "Anon"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
