//
//  gMapsViewController.swift
//  HapTheApp
//
//  Created by Jim Peraino on 2/11/18.
//  Copyright © 2018 James Peraino. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class gMapsViewController: UIViewController {

    var locationManager = CLLocationManager()
    
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    var newPlace: GMSPlace?
    var newPlaceMarker: GMSMarker?
    
    
    // Info Window Outlets
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var iNameLabel: UILabel!
    @IBOutlet weak var iAddressLabel: UILabel!
    @IBOutlet weak var iTextField: UITextField!
    
    @IBOutlet weak var openButton: UIBarButtonItem!

    
    // The currently selected place
    var selectedPlace: GMSPlace?
    
    // A default location to use when location permission is not granted.
    let defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)
    
    // Update the map once the user has made their selection.
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createGoogleMap()
        
        infoView.isHidden = true
        
        // Enable side button
        openButton.target = self.revealViewController()
        openButton.action = Selector("revealToggle:")
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        
        // Populate map with saved places.
        
        
        
//        for item in mainVC.places {
//            populateMap(snapshot: item)
//        }
        
        //
//        func populateMapItem(snapshot: DataSnapshot) {
//            //        mapView.remove(mapView.annotations as! MKOverlay)
//            print("map items count: " + String(mainVC.places.count))
//
//            let place = snapshot.value as! [String:String]
//
//            let placeLat = place[Constants.PlaceFields.placeLat]
//            let placeLong = place[Constants.PlaceFields.placeLong]
//            let placeCoordinates = CLLocation(latitude: Double(placeLat!)!, longitude: Double(placeLong!)!)
//
//            let annotation = MKPointAnnotation()
//
//
//            annotation.coordinate = placeCoordinates.coordinate
//            annotation.title = place[Constants.PlaceFields.placeName]
//
//            //        if place[Constants.PlaceFields.UID] == UID! {
//            //
//            //            annotation.pointTintColor = UIColor.green
//            //
//            //
//            //        }
//
//
//
//            mapView.addAnnotation(annotation)
//            print("point was added" + String(mapView.annotations.count))
//
//
//        }
//
//    }
        
        
        
        
        
    }
    

    // MARK: Actions
    
    @IBAction func addPlaceBySearch(_ sender: Any) {
        print("adding a place by search")
        
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func addVisitedPlace(_ sender: Any) {
        print("I've visited \(iNameLabel)")
        hideInfoView()
        newPlaceMarker!.icon = #imageLiteral(resourceName: "pin-mark-flag")
    }
    
    @IBAction func addPlaceToVisit(_ sender: Any) {
        print("I want to visit \(iNameLabel)")
        hideInfoView()
        newPlaceMarker!.icon = #imageLiteral(resourceName: "pin-mark-flag")
    }
    
    

    
    func hideInfoView() {
        
        iTextField.resignFirstResponder()
        infoView.isHidden = true
        
    }
    
}




// Handle GMSAutocompleteViewControllerDelegate
extension gMapsViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
        dismiss(animated: true, completion: nil)
        
        newPlace = place

        addMarker(place: place)
        
        showInfoWindow(place: place)
        
    }
    
    func addMarker(place: GMSPlace) {
        
        // Remove existing marker if there's one
        if let currentMarker = newPlaceMarker {
            currentMarker.map = nil
        }
        
        // Create a new marker
        let position = place.coordinate
        newPlaceMarker = GMSMarker(position: position)
        newPlaceMarker!.title = place.name
        newPlaceMarker!.icon = #imageLiteral(resourceName: "pin-mark-blank")
        newPlaceMarker!.map = mapView
        
        mapView.animate(toLocation: position)
        
    }
    
    func showInfoWindow(place: GMSPlace) {
        
        iNameLabel.text = ""
        iAddressLabel.text = ""
        iTextField.text = ""
        
        infoView.isHidden = false
        iNameLabel.text = place.name
        iAddressLabel.text = place.formattedAddress
        iTextField.becomeFirstResponder()
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    
}

//extension gMapsViewController: UIGestureRecognizerDelegate {
//
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
//                           shouldReceive touch: UITouch) -> Bool {
//        return (touch.view === self.view)
//    }
//}








