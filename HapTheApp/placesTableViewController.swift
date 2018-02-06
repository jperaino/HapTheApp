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

class placesTableViewController: UITableViewController, UINavigationControllerDelegate {
    
    // MARK - Properties
    
    var ref: DatabaseReference!
    var places: [DataSnapshot]! = []
    

    override func viewDidLoad() {
        super.viewDidLoad()

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

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "placeCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PlaceTableViewCell else {
            fatalError("The dequeued cell is not an instance of PlacesTableViewCell.")
        }
        
//        let placeSnapsot: DataSnapshot! = places[indexPath.row]
//        let place = placeSnapsot.value as! [String:String]
        let nameText = "Hi"
        let addressText = "Hi"
        let blurbText = "Hi"
        let distanceText = "1.0 km"
 
        cell.placeNameLabel.text = nameText
        cell.placeAddressLabel.text = addressText
        cell.placeBlurbLabel.text = blurbText
        cell.placeDistanceLabel.text = distanceText
        
        return cell
        
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




