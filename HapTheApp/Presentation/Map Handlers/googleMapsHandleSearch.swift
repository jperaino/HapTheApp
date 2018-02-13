//
//  googleMapsHandleSearch.swift
//  HapTheApp
//
//  Created by Jim Peraino on 2/11/18.
//  Copyright © 2018 James Peraino. All rights reserved.
//

import Foundation
import GoogleMaps
import GooglePlaces

extension gMapsViewController {
    
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
    
    
    
    func showInfoWindow(place: GMSPlace) {
        print("showing info window")
        
        iNameLabel.text = ""
        iAddressLabel.text = ""
        iTextField.text = ""
        
        infoView.isHidden = false
        iNameLabel.text = place.name
        iAddressLabel.text = place.formattedAddress
        iTextField.becomeFirstResponder()
        
    }
}
