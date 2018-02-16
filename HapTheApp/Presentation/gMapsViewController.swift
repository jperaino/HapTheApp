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
    
    @IBOutlet weak var sliderToggleButton: UIButton!
    var sliderState = 0
    
    
    @IBOutlet weak var placesTableHeightConstraint: NSLayoutConstraint!
    
    var embeddedVC: placesTableViewController?
    
    @IBOutlet var totalView: UIView!
//    @IBAction func slideTableUp(_ sender: Any) {
//        print("height of the table is: \(placesTableHeightConstraint.constant)")
//        
//        
//        
//        
//        
//    }
    
    
    func slideTableView() {
        
        switch sliderState {
        case 0:
            placesTableHeightConstraint.constant = 400 // TODO: MAKE THIS NUMBER PARAMETRIC FOR DIFFERENT DEVICES
            sliderState = 1
            sliderToggleButton.setImage(#imageLiteral(resourceName: "ic_map"), for: .normal)
        default:
            placesTableHeightConstraint.constant = 146
            sliderState = 0
            sliderToggleButton.setImage(#imageLiteral(resourceName: "ic_list"), for: .normal)
        }
        
        UIView.animate(withDuration: 0.5) {
            self.totalView.layoutIfNeeded()
        }

    }
    
    
    @IBAction func toggleSlide(_ sender: Any) {
        
        slideTableView()
        
    }
    
    // Info Window Outlets
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var iNameLabel: UILabel!
    @IBOutlet weak var iAddressLabel: UILabel!
    @IBOutlet weak var iTextField: UITextField!
    
    @IBOutlet weak var filterControl: UISegmentedControl!
    
    @IBOutlet weak var openButton: UIBarButtonItem!

    @IBOutlet weak var showSavedPinsButton: UIButton!
    
    @IBOutlet weak var mapHolder: UIView!
    
    
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
    
    func reloadTable2() {
        self.embeddedVC?.tableView.reloadData()
    }
    
    
    func hideInfoView() {
        print("hiding info window")
        
        iTextField.resignFirstResponder()
        infoView.isHidden = true
    }
    
    
    func sendPlace(status: String) {
        
        // Collect data
        let placeID = newPlace?.placeID
        var comment: String!

        if let commentText = iTextField.text {
            comment = commentText
        } else {
            comment = ""
        }
        
        // Package and upload PID to Firebase
        let mdata = [Constants.PlaceFields.PID: placeID! as String]
        mainVC.ref.child("placeIDs").child(placeID! as String).setValue(mdata)
        
        // Package and upload Blurb to Firebase
        var bdata = [Constants.blurbFields.timestamp: Firebase.ServerValue.timestamp()] as [String : Any]
        bdata[Constants.blurbFields.PID] = placeID! as String
        bdata[Constants.blurbFields.UID] = Auth.auth().currentUser?.uid
        bdata[Constants.blurbFields.privacy] = "private"
        bdata[Constants.blurbFields.comment] = comment
        bdata[Constants.blurbFields.sentiment] = status
        
        mainVC.refUser.child("blurbs").childByAutoId().setValue(bdata)
    }
    
}










