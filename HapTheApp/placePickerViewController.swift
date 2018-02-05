//
//  placePickerViewController.swift
//  HapTheApp
//
//  Created by Jim Peraino on 2/5/18.
//  Copyright © 2018 James Peraino. All rights reserved.
//

import UIKit
import MapKit

// MARK: Protocols

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}


class placePickerViewController: UIViewController {
    
    // MARK: Properties
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    
    var resultSearchController:UISearchController? = nil
    
    var selectedPin: MKPlacemark? = nil
    
    
    
    
    // MARK: Methods
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

    @objc func getDirections() {
        if let selectedPin = selectedPin {
            let mapItem = MKMapItem(placemark: selectedPin)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMaps(launchOptions: launchOptions)
        }
    }
    
   

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
        button.addTarget(self, action: #selector(placePickerViewController.getDirections), for: .touchUpInside) // TODO: SAVE TO FIREBASE WHEN BUTTON IS TAPPED
        button.isEnabled = false // Disable Button until user enters description
        markerView?.leftCalloutAccessoryView = button
        
        return markerView
    }
}

