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
import Firebase
import FirebaseAuth

class gMapsViewController: UIViewController, UITableViewDelegate {

    var locationManager = CLLocationManager()
    
    static var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    var newPlace: GMSPlace?
    var newPlaceMarker: GMSMarker?
    
    
    var embeddedVC: placesTableViewController?
    
    
    // Info Window Outlets
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var iNameLabel: UILabel!
    @IBOutlet weak var iAddressLabel: UILabel!
    @IBOutlet weak var iTextField: UITextField!
    
    @IBOutlet weak var filterControl: UISegmentedControl!
    
    @IBOutlet weak var openButton: UIBarButtonItem!

    @IBOutlet weak var showSavedPinsButton: UIButton!
    
 
    
    // The currently selected place
    var selectedPlace: GMSPlace?
    
    // A default location to use when location permission is not granted.
    let defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createGoogleMap()
        
        infoView.isHidden = true
        
        // Enable side button
        openButton.target = self.revealViewController()
        openButton.action = Selector("revealToggle:")
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.reloadTable2()
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "embeddedPlacesTable") {
            
            let detailScene = segue.destination as! placesTableViewController
            
            self.embeddedVC = detailScene
            
            
        }
        
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
        sendPlace(status: "visited")
    }
    
    @IBAction func addPlaceToVisit(_ sender: Any) {
        print("I want to visit \(iNameLabel)")
        hideInfoView()
        newPlaceMarker!.icon = #imageLiteral(resourceName: "pin-mark-flag")
        sendPlace(status: "wanted")
    }
    
    
    @IBAction func showSavedPins(_ sender: Any) {
        
        addSavedMarkers()
        showSavedPinsButton.isHidden = true
        
    }
    
    @IBAction func reloadTable(_ sender: Any) {
        
        self.embeddedVC?.tableView.reloadData()
        
    }
    
    func reloadTable2() {
        
        self.embeddedVC?.tableView.reloadData()
    }
    
    
    func hideInfoView() {
        print("hiding info window")
        
        iTextField.resignFirstResponder()
        infoView.isHidden = true
        
    }
    
    
    func sendPlace(status: String) {
        let nPlace = newPlace
        var blurb = "Placeholder"
        
        // Collect data
        let placeID = nPlace?.placeID
        let UID = Auth.auth().currentUser?.uid
        let timestamp = Date().toString(dateFormat: "yyyy/MMM/dd HH:mm:ss") // TODO MAKE THIS UNIFORM TIME ZONE?
        let privacy = "global"
        if let blurbText = iTextField.text {
            blurb = blurbText
        }
    
        let status = status
        
        let placeName = nPlace?.name
        let formattedAddress = nPlace?.formattedAddress
        let placeLat = nPlace?.coordinate.latitude
        let placeLong = nPlace?.coordinate.longitude
        
        // Package data
        var mdata = [Constants.PlaceFields.PID: placeID! as String]
        
//        mdata[Constants.PlaceFields.PID] = placeID
        mdata[Constants.PlaceFields.UID] = UID
        mdata[Constants.PlaceFields.timestamp] = timestamp
        mdata[Constants.PlaceFields.blurb] = blurb
        mdata[Constants.PlaceFields.placeName] = placeName
        mdata[Constants.PlaceFields.placeLat] = String(placeLat!) 
        mdata[Constants.PlaceFields.placeLong] = String(placeLong!)
        mdata[Constants.PlaceFields.placeAddress] = formattedAddress
        mdata[Constants.PlaceFields.privacy] = privacy
        mdata[Constants.PlaceFields.status] = status
        
        mainVC.ref.child("places").childByAutoId().setValue(mdata)
    
    }
    
    
    
}










