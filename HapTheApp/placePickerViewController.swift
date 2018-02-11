////
////  placePickerViewController.swift
////  HapTheApp
////
////  Created by Jim Peraino on 2/5/18.
////  Copyright © 2018 James Peraino. All rights reserved.
////
//
//import UIKit
//import MapKit
//import Firebase
//import FirebaseAuthUI
//import CoreLocation
//
//// MARK: Protocols
//
//protocol HandleMapSearch {
//    func dropPinZoomIn(placemark:MKPlacemark)
//}
//
//class placePickerViewController: UIViewController, UINavigationControllerDelegate {
//
//
//
//    // MARK: Properties
//    let locationManager = CLLocationManager()
//
//    @IBOutlet weak var mapView: MKMapView!
//
//    var resultSearchController:UISearchController? = nil
//    var selectedPin: MKPlacemark? = nil
//
//    var storageRef: StorageReference!
//    var keyboardOnScreen = false
//    static var displayName = "Anonymous"
//    static var userEmail = "todo@todo.com"
//    var UID: String?
//
//    var blurbTextField: UITextField?
//
//    static var currentLocation = CLLocation(latitude: 0.0, longitude: 0.0)
//
//    @IBOutlet weak var openButton: UIBarButtonItem!
//    // MARK: Lifecycle
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//
//
////        self.sortArrayByDistance(array: mainVC.places, currentLocation: placePickerViewController.currentLocation)
//
////        for item in mainVC.places {
////            populateMap(snapshot: item)
////        }
//
////        self.populateMap(snapshot: snapshot)
//
//
//    }
//
//
//
//    // MARK: Methods
//
//
//    static func sortArrayByDistance(array: [DataSnapshot], currentLocation: CLLocation) {
//
//        mainVC.places.sort(by: { helpers.calculateDistance(dataSnapshot: $0) < helpers.calculateDistance(dataSnapshot: $1) })
//        print("Places snapshot array was sorted")
//
//    }
//
//
//    @objc func getDirections() {
//        if let selectedPin = selectedPin {
//            let mapItem = MKMapItem(placemark: selectedPin)
//            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
//            mapItem.openInMaps(launchOptions: launchOptions)
//        }
//    }
//
//    @objc func didSendPlace() {
//        textFieldShouldReturn()
//        blurbTextField?.text = ""
//
//        let selectedAnnotation = mapView.selectedAnnotations[0]
//
//        mapView.removeAnnotation(selectedAnnotation)
////        mapView.deselectAnnotation(selectedAnnotation, animated: true)
//
//    }
//
//    func textFieldShouldReturn() -> Bool {
//        if !blurbTextField!.text!.isEmpty {
//            let data = [Constants.PlaceFields.blurb: blurbTextField!.text! as String]
//            sendPlace(data: data)
//            blurbTextField?.resignFirstResponder()
//        }
//        return true
//    }
//
//    func sendPlace(data: [String:String]) {
//        var mdata = data
//        let date = Date()
//
//        let selectedAnnotation = mapView.selectedAnnotations[0]
//
//        // TODO : Can this be saved with a single unique identifier?
//
//        let placeName = selectedAnnotation.title
//        let placeLat = String(selectedAnnotation.coordinate.latitude)
//        let placeLong = String(selectedAnnotation.coordinate.longitude)
//        let placeAddress = selectedAnnotation.subtitle
//
//
//        mdata[Constants.PlaceFields.timestamp] = date.toString(dateFormat: "yyyy/MMM/dd HH:mm:ss") // TODO MAKE THIS UNIFORM TIME ZONE?
//        mdata[Constants.PlaceFields.UID] = Auth.auth().currentUser?.uid
//        mdata[Constants.PlaceFields.placeName] = placeName!
//        mdata[Constants.PlaceFields.placeLat] = placeLat
//        mdata[Constants.PlaceFields.placeLong] = placeLong
//        mdata[Constants.PlaceFields.placeAddress] = placeAddress!
//
//        mainVC.ref.child("places").childByAutoId().setValue(mdata)
//    }
//
////    func populateMap(snapshot: DataSnapshot) {
//////        mapView.remove(mapView.annotations as! MKOverlay)
////        print("map items count: " + String(mainVC.places.count))
////
////            let place = snapshot.value as! [String:String]
////
////            let placeLat = place[Constants.PlaceFields.placeLat]
////            let placeLong = place[Constants.PlaceFields.placeLong]
////            let placeCoordinates = CLLocation(latitude: Double(placeLat!)!, longitude: Double(placeLong!)!)
////
////            let annotation = MKPointAnnotation()
////
////
////            annotation.coordinate = placeCoordinates.coordinate
////            annotation.title = place[Constants.PlaceFields.placeName]
////
//////        if place[Constants.PlaceFields.UID] == UID! {
//////
//////            annotation.pointTintColor = UIColor.green
//////
//////
//////        }
////
////
////
////            mapView.addAnnotation(annotation)
////            print("point was added" + String(mapView.annotations.count))
////
////
////    }
////
////}
//
//
//// MARK: Extensions
//
//extension placePickerViewController : CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if status == .authorizedWhenInUse {
//            locationManager.requestLocation()
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print("updating locations")
//        if let location = locations.first {
//            let span = MKCoordinateSpanMake(0.05, 0.05)
//            let region = MKCoordinateRegion(center: location.coordinate, span: span)
//            mapView.setRegion(region, animated: true)
//            placePickerViewController.currentLocation = location
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print ("error:: (error)")
//    }
//
//}
//
////extension placePickerViewController: HandleMapSearch {
////    func dropPinZoomIn(placemark:MKPlacemark){
////        // cache the pin
////        selectedPin = placemark
////        // clear existing pins
////        mapView.removeAnnotations(mapView.annotations)
////        let annotation = MKPointAnnotation()
////        annotation.coordinate = placemark.coordinate
////        annotation.title = placemark.name
////        if let city = placemark.locality,
////            let state = placemark.administrativeArea {
////            annotation.subtitle = city + ", " + state
////        }
////        mapView.addAnnotation(annotation)
////        mapView.selectAnnotation(annotation, animated: true)
////
////        let span = MKCoordinateSpanMake(0.05, 0.05)
////        let region = MKCoordinateRegionMake(placemark.coordinate, span)
////        mapView.setRegion(region, animated: true)
////    }
////}
//
//
//
//extension placePickerViewController: MKMapViewDelegate {
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        if annotation is MKUserLocation {
//            //return nil so map view draws "blue dot" for standard user location
//            return nil
//        }
//
//        let reuseId = "marker"
//        var markerView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKMarkerAnnotationView
//        markerView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
//        markerView?.canShowCallout = true
//
////        var friendMarkerView = mapView.dequeueReusableAnnotationView(withIdentifier: "friendMarker") as? MKMarkerAnnotationView
////        friendMarkerView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "friendMarker")
////        markerView?.canShowCallout = false
////        markerView?.markerTintColor = UIColor.green
//
//
//
//        // Add Button
//        let button = UIButton(type: .contactAdd)
//        button.addTarget(self, action: #selector(placePickerViewController.didSendPlace), for: .touchUpInside) // TODO: SAVE TO FIREBASE WHEN BUTTON IS TAPPED
//
//        button.isEnabled = true
//        markerView?.leftCalloutAccessoryView = button
//
//        blurbTextField = UITextField()
//        blurbTextField!.placeholder = "Enter Description"
//        blurbTextField!.textColor = UIColor.magenta
//        markerView?.detailCalloutAccessoryView = blurbTextField!
//
//
//
//
//        return markerView
//    }
//}
//
//
//
