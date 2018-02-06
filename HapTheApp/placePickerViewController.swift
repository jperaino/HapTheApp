//
//  placePickerViewController.swift
//  HapTheApp
//
//  Created by Jim Peraino on 2/5/18.
//  Copyright © 2018 James Peraino. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import FirebaseAuthUI

// MARK: Protocols

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class placePickerViewController: UIViewController, UINavigationControllerDelegate {
    
    // MARK: Properties
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    
    var resultSearchController:UISearchController? = nil
    var selectedPin: MKPlacemark? = nil
    
    var ref: DatabaseReference!
    var places: [DataSnapshot]! = []
    var storageRef: StorageReference!
    var keyboardOnScreen = false
    fileprivate var _refHandle: DatabaseHandle!
    fileprivate var _authHandle: AuthStateDidChangeListenerHandle!
    
    var user: User?
    var displayName = "Anonymous"
    var UID: String?

    var blurbTextField: UITextField?
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAuth()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        // Setup search results table
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        // Setup search bar
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        
        // Configure UISearchController appearance
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
    
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        mapView.mapType = .mutedStandard
    }

    // MARK: Config
    
    func configureAuth() {
        // listen for changes in the authorization state
        _authHandle = Auth.auth().addStateDidChangeListener({ (auth: Auth, user: User?) in
            //refresh data
            self.places.removeAll(keepingCapacity: false)
            // TODO : Reload data
            
            // Check if there is a current user
            if let activeUser = user {
                if self.user != activeUser {
                    self.user = activeUser
                    self.signedInStatus(isSignedIn: true)
//                    let name = user!.email!.components(separatedBy: "@")[0]
                    
                    let name = user!.displayName!
                    let UID = user!.uid

                    self.displayName = name
                    self.UID = UID
                }
            } else {
                // user must sign in
                self.signedInStatus(isSignedIn: false)
                self.loginSession()
            }
        })
    }
    
    func loginSession() {
        let authViewController = FUIAuth.defaultAuthUI()!.authViewController()
        present(authViewController, animated: true, completion: nil)
    }
    
    // MARK: Sign In and Out
    
    func signedInStatus(isSignedIn: Bool) {
        
        mapView.isHidden = !isSignedIn
        if (isSignedIn) {
            // TODO: remove background blur
            configureDatabase()
        }
    }
    
    func configureDatabase() {
        ref = Database.database().reference()
        _refHandle = ref.child("places").observe(.childAdded) {(snapshot: DataSnapshot) in
//            self.messages.append(snapshot)
//            self.messagesTable.insertRows(at: [IndexPath(row: self.messages.count - 1, section: 0)], with: .automatic)
//            self.scrollToBottomMessage()
        }
    }
    
    // MARK: Methods
    
//    @objc func getDirections() {
//        if let selectedPin = selectedPin {
//            let mapItem = MKMapItem(placemark: selectedPin)
//            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
//            mapItem.openInMaps(launchOptions: launchOptions)
//        }
//    }
    
    @objc func didSendPlace() {
        textFieldShouldReturn()
        blurbTextField?.text = ""
        
        let selectedAnnotation = mapView.selectedAnnotations[0]
        
        mapView.removeAnnotation(selectedAnnotation)
//        mapView.deselectAnnotation(selectedAnnotation, animated: true)
        
    }
    
    func textFieldShouldReturn() -> Bool {
        if !blurbTextField!.text!.isEmpty {
            let data = [Constants.PlaceFields.blurb: blurbTextField!.text! as String]
            sendPlace(data: data)
            blurbTextField?.resignFirstResponder()
        }
        return true
    }
    
    func sendPlace(data: [String:String]) {
        var mdata = data
        let date = Date()
        
        let selectedAnnotation = mapView.selectedAnnotations[0]
        
        // TODO : Can this be saved with a single unique identifier?
        
        let placeName = selectedAnnotation.title
        let placeLat = String(selectedAnnotation.coordinate.latitude)
        let placeLong = String(selectedAnnotation.coordinate.longitude)
        let placeAddress = selectedAnnotation.subtitle
        
    
        mdata[Constants.PlaceFields.timestamp] = date.toString(dateFormat: "yyyy/MMM/dd HH:mm:ss") // TODO MAKE THIS UNIFORM TIME ZONE?
        mdata[Constants.PlaceFields.UID] = UID!
        mdata[Constants.PlaceFields.placeName] = placeName!
        mdata[Constants.PlaceFields.placeLat] = placeLat
        mdata[Constants.PlaceFields.placeLong] = placeLong
        mdata[Constants.PlaceFields.placeAddress] = placeAddress!
        
        ref.child("places").childByAutoId().setValue(mdata)
    }
    
    
    
    
    
//    @objc func sendMessage() {
//        print("here")
//
//        var mdata = data
//        print(mdata)
//        print(ref)
//        mdata[Constants.PlaceFields.UID] = displayName
//        ref.child("messages").childByAutoId().setValue(mdata)
//    }
//
//
//    @objc func didSendPlace() {
//        print("willSendPlace")
//        let _ = textFieldShouldReturn(blurbTextField!)
//        blurbTextField!.text = ""
//        print("didSendPlace")
//    }
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        print("textFieldShouldReturn")
//        if !textField.text!.isEmpty {
//            let data = [Constants.PlaceFields.comment: textField.text! as String]
//            sendMessage(data: data)
//            textField.resignFirstResponder()
//        }
//        return true
//    }


}


// MARK: Extensions

extension placePickerViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print ("error:: (error)")
    }
    
}

extension placePickerViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = city + ", " + state
        }
        mapView.addAnnotation(annotation)
        mapView.selectAnnotation(annotation, animated: true)
        
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
}

extension placePickerViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        let reuseId = "marker"
        var markerView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKMarkerAnnotationView
        markerView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        markerView?.canShowCallout = true
    
        // Add Button
        let button = UIButton(type: .contactAdd)
        button.addTarget(self, action: #selector(placePickerViewController.didSendPlace), for: .touchUpInside) // TODO: SAVE TO FIREBASE WHEN BUTTON IS TAPPED

        button.isEnabled = true
        markerView?.leftCalloutAccessoryView = button
        
        blurbTextField = UITextField()
        blurbTextField!.placeholder = "Enter Description"
        blurbTextField!.textColor = UIColor.magenta
        markerView?.detailCalloutAccessoryView = blurbTextField!
        
        return markerView
    }
}

