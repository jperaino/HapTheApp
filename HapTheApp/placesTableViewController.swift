//
//  placesTableViewController.swift
//  HapTheApp
//
//  Created by Jim Peraino on 2/5/18.
//  Copyright © 2018 James Peraino. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseGoogleAuthUI
import CoreLocation

class placesTableViewController: UITableViewController, UINavigationControllerDelegate {
    
    // MARK - Properties
    
    @IBOutlet weak var filterControl: UISegmentedControl!
    @IBOutlet var placesTableView: UITableView!
    
    
    
    
    var distanceText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("placesTableViewController did load")
        
//        placePickerViewController.sortArrayByDistance(array: mainVC.places, currentLocation: placePickerViewController.location)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("number of places in places: \(mainVC.places.count)")
        
        switch  filterControl.selectedSegmentIndex {
        case 0:
            return mainVC.places.count
        default:
            return mainVC.privatePlaces.count
        }
        
        
        
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("loading cells")
        
        let cellIdentifier = "placeCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PlaceTableViewCell else {
            fatalError("The dequeued cell is not an instance of PlacesTableViewCell.")
        }
        
        var placeSnapshot: DataSnapshot!
        
        switch filterControl.selectedSegmentIndex {
            
        case 0:
            placeSnapshot = mainVC.places[indexPath.row]
        default:
            placeSnapshot = mainVC.privatePlaces[indexPath.row]
        }
        
        let place = placeSnapshot.value as! [String:String]
        
        // Calculate distance from current location:
//        let distanceinMiles = helpers.calculateDistance(dataSnapshot: placeSnapsot)
        let distanceinMiles = 0.25
        let nameText = place[Constants.PlaceFields.placeName]
        let cityText = "placeholder"
        let addressText = place[Constants.PlaceFields.placeAddress]
        let blurbText = "+ " + place[Constants.PlaceFields.blurb]!
        
        
        // Switch milage display based on distance
        
        if distanceinMiles < 0.1 {
            let distanceInFeet = round(distanceinMiles/5280)
            distanceText = String(format:"%d ft", distanceInFeet)
        } else if distanceinMiles < 25.0 {
            distanceText = String(format:"%.1f mi", distanceinMiles)
        } else {
            distanceText = "Far"  // TODO: HANDLE UNWRAPPING SAFELY
        }
        
 
        cell.placeNameLabel.text = nameText
        cell.placeAddressLabel.text = addressText
        cell.placeBlurbLabel.text = blurbText
        cell.placeDistanceLabel.text = distanceText
        
        let visitedColor = UIColor.gray
        let wantedColor = UIColor.blue
        let visitedGoodColor = UIColor.green
        let visitedBadColor = UIColor.magenta
        
        
        // Change colors
        if place[Constants.PlaceFields.status] == "visited" {
            
            if place[Constants.PlaceFields.UID] == mainVC.userID {
            
            cell.placeNameLabel.textColor = visitedColor
            cell.placeAddressLabel.textColor = visitedColor
            cell.placeDistanceLabel.textColor = visitedColor
            }
            
            
            cell.placeBlurbLabel.textColor = visitedGoodColor
            
        } else {
            
            cell.placeBlurbLabel.textColor = wantedColor
            
        }
        

        
        print("done loading cell")
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
            let placeSnapsot: DataSnapshot! = mainVC.places[indexPath.row]
            let key = placeSnapsot.key
            
            mainVC.places.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            mainVC.ref.child("places").child(key).removeValue()
            
        }
        
        let share = UITableViewRowAction(style: .default, title: "Share") { (action, indexPath) in
            // TODO: share item at indexPath
            print("I want to share: \(mainVC.places[indexPath.row])")
        }
        
        
        let visit = UITableViewRowAction(style: .default, title: "Visit") { (action, indexPath) in
            // TODO: mark as saved
            print("I want to have visited: \(mainVC.places[indexPath.row])")
            
            let visitAlert = UIAlertController(title: "How was it?", message: nil, preferredStyle: .alert)
            
            visitAlert.addTextField(configurationHandler: { (textField) in
                textField.placeholder = "e.g Get the veggie tacos!"
            })
            
            visitAlert.addAction(UIAlertAction(title: "😄", style: .default, handler: { _ in
                print("it was good")
            }))
            visitAlert.addAction(UIAlertAction(title: "☹️", style: .default, handler: { _ in
                print("it was bad")
            }))
            visitAlert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { _ in
                print("nevermind")
            }))
            
            self.present(visitAlert, animated: true, completion: nil)
            
        }
        
        share.backgroundColor = UIColor.lightGray
        visit.backgroundColor = UIColor.blue
     
        
        return [delete, share, visit]
        
    }

    
    // MARK: ACTIONS
    
    @IBAction func segmentedControlActionChanged(_ sender: Any) {
        print("filtering list")
        placesTableView.reloadData()
        
    }
    
    
    

}

// MARK - Extensions

//extension placesTableViewController {
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return places.count
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
//        let selectedItem = places[indexPath.row].placemark
//        cell.textLabel?.text = selectedItem.name
////        cell.detailTextLabel?.text = parseAddress(selectedItem: selectedItem)
//        return cell
//    }
//}
//
//extension placesTableViewController {
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedItem = places[indexPath.row].placemark
//        handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
//        dismiss(animated: true, completion: nil)
//    }
//}




