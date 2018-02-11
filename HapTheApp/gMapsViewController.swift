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
    
    // An array tot hold the list of likely places.
    var likelyPlaces: [GMSPlace] = []
    
    // The currently selected
    var selectedPlace: GMSPlace?
    
    // A default location to use when location permission is not granted.
    let defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)
    
    // Update the map once the user has made their selection.
    
    
    
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {
        // Clear the map.
        mapView.clear()
        
        // Add a marker to the map.
        if selectedPlace != nil {
            let marker = GMSMarker(position: (self.selectedPlace?.coordinate)!)
            marker.title = selectedPlace?.name
            marker.snippet = selectedPlace?.formattedAddress
            marker.map = mapView
            marker.icon = #imageLiteral(resourceName: "pin-mark-blank")
        }
        
        listLikelyPlaces()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.hideKeyboardWhenTappedAround()
        
        
        // Initialize the location manager.
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        placesClient = GMSPlacesClient.shared()
        
        // Create a map.
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude, longitude: defaultLocation.coordinate.longitude, zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        
        // Add the map to the view, hide it until we have a location update.
//        view.addSubview(mapView)
        view.insertSubview(mapView, at: 0)
        mapView.isHidden = true
        
        infoView.isHidden = true
        
        listLikelyPlaces()
        
        // Enable side button
        openButton.target = self.revealViewController()
        openButton.action = Selector("revealToggle:")
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
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
    
    
    
    // Populate the array with the list of likely places.
    func listLikelyPlaces() {
        // Clean up from previous sessions.
        likelyPlaces.removeAll()
        
        placesClient.currentPlace(callback: { (placeLikelihoods, error) -> Void in
            if let error = error {
                // TODO: Handle the error.
                print("Current Place error: \(error.localizedDescription)")
                return
            }
            
            // Get likely places and add to the list.
            if let likelihoodList = placeLikelihoods {
                for likelyhood in likelihoodList.likelihoods {
                    let place = likelyhood.place
                    self.likelyPlaces.append(place)
                }
            }
        })
    }
    
    func hideInfoView() {
        
        iTextField.resignFirstResponder()
        infoView.isHidden = true
        
    }
    
    // Prepare the seque.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToSelect" {
            if let nextViewController = segue.destination as? PlacesViewController {
                nextViewController.likelyPlaces = likelyPlaces
            }
        }
    }
}

// Delegates to handle events for the location manager.
extension gMapsViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: zoomLevel)
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
    
        listLikelyPlaces()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted")
        case .denied:
            print("User denied access to location")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle Location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
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








