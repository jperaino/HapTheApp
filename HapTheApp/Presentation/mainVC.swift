//
//  mainViewController.swift
//  HapTheApp
//
//  Created by Jim Peraino on 2/10/18.
//  Copyright © 2018 James Peraino. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseAuthUI
import GooglePlaces

class mainVC: UIViewController {

    fileprivate var _refHandle: DatabaseHandle!
    fileprivate var _authHandle: AuthStateDidChangeListenerHandle!
    
    var window: UIWindow?
    var user: User?
    
    static var userID: String?
    
    static var ref: DatabaseReference!
    static var refUser: DatabaseReference!
    
    static var places: [DataSnapshot]! = []
    static var privatePlaces: [DataSnapshot]! = []
    
    static var hapPlaces = [String: HapPlace]()
//    static var hapBlurbs = [String: HapBlurb]()
    static var hapPlacesArray = [HapPlace]()
    
    var placesClient: GMSPlacesClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MainVC Did load...\(mainVC.places.count)")
        configureAuth()
        
      
    }


    
    // MARK: Config
    
    func configureAuth() {
        print("Configuring Auth...")
        
        // listen for changes in the authorization state
        _authHandle = Auth.auth().addStateDidChangeListener({ (auth: Auth, user: User?) in
            
            // Clear local data
//            self.clearLocalData()
            
            // TODO: Do we need to reload data?
            
            // Check if there is a current user
            if let activeUser = user {
                if self.user != activeUser {
                    self.user = activeUser
                    self.signedInStatus(isSignedIn: true)
                    print(activeUser)
                    
                    mainVC.userID = self.user?.uid
                    
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "firstVC") as! SWRevealViewController
                    self.present(newViewController, animated: true, completion: nil)
                    
                
                
                }
            } else {
                // user must sign in
                print("No one is signed in. Presenting login session.")
                self.signedInStatus(isSignedIn: false)
                self.clearLocalData()
                self.loginSession()
            }
        })
    }
    
    
    

    // MARK - Methods
    
    
    func loginSession() {
        // Present the Firebase Authentication UI.
        
        let authViewController = FUIAuth.defaultAuthUI()!.authViewController()
        authViewController.navigationItem.leftBarButtonItem = nil
        
        present(authViewController, animated: true, completion: nil)
    }
    
    
    func signedInStatus(isSignedIn: Bool) {
        // Configure the database if the user is signed in.
        
        if (isSignedIn) {
            configureDatabase()
        }
    }
    
    func configureDatabase() {
        // Configure the database.
        
        mainVC.ref = Database.database().reference()
        mainVC.refUser = mainVC.ref.child("users").child((user?.uid)!)
        placesClient = GMSPlacesClient.shared()
        
        _refHandle = mainVC.refUser.child("blurbs").observe(.childAdded) {(snapshot: DataSnapshot) in
            let newBlurb = HapBlurb(snapshot: snapshot)
            print("received a new blurb: \(newBlurb.blurbID)")
            
            self.handleIncomingBlurb(blurb: newBlurb)
        }
    }
    
    
    func clearLocalData() {
        // Remove any data that should be gone if no user is logged in.
        print("Clearing local data")
        mainVC.places.removeAll(keepingCapacity: false)
        mainVC.privatePlaces.removeAll(keepingCapacity: false)
        
        
    }

}
