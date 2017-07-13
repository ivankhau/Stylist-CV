//
//  addressSelectViewController.swift
//  Hair CV
//
//  Created by Ivan Khau on 5/18/16.
//  Copyright © 2016 Peer Goggles. All rights reserved.
//

import UIKit
import MapKit

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class addressSelectViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    var selectedPin:MKPlacemark? = nil
    var resultSearchController:UISearchController? = nil
    
    
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    //@IBOutlet weak var navBar: UINavigationBar!

    //@IBOutlet weak var navItem: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated:true)
        configureLocationSearchBar()
        customizeObjects()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configureLocationSearchBar() {
        let locationSearchTable = self.storyboard!.instantiateViewControllerWithIdentifier("LocationSearchTable") as! LocationSearchTable
        self.resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        self.resultSearchController?.searchResultsUpdater = locationSearchTable
        let searchBar = self.resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Work Address"
        
        searchBar.layer.borderColor = UIColor.darkGrayColor().CGColor
        searchBar.layer.borderWidth = 3
        
        self.navigationItem.titleView = self.resultSearchController?.searchBar
        self.resultSearchController?.hidesNavigationBarDuringPresentation = false
        self.resultSearchController?.dimsBackgroundDuringPresentation = true
        
        self.definesPresentationContext = true
        locationSearchTable.mapView = self.mapView
        locationSearchTable.handleMapSearchDelegate = self
        
        searchBar.becomeFirstResponder()
    }
    
    func customizeObjects() {
        instructionLabel.layer.cornerRadius = instructionLabel.frame.size.height/2
        instructionLabel.layer.masksToBounds = true

    }
    
    
    @IBAction func dismissVC(sender: AnyObject) {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    
    
}

extension addressSelectViewController : CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            if #available(iOS 9.0, *) {
                locationManager.requestLocation()
            } else {
                
                // Fallback on earlier versions
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error:: \(error)")
    }
}

extension addressSelectViewController: HandleMapSearch {
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
            annotation.subtitle = "\(city) \(state)"
            print(placemark.addressDictionary)
            
        }
        
        
        if placemark.addressDictionary!["City"] != nil && placemark.addressDictionary!["State"] != nil && placemark.addressDictionary!["Street"] != nil {
            
            mapView.addAnnotation(annotation)
            let span = MKCoordinateSpanMake(0.005, 0.005)
            let region = MKCoordinateRegionMake(placemark.coordinate, span)
            mapView.setRegion(region, animated: true)
            let yourAnnotationAtIndex = 0
            mapView.selectAnnotation(mapView.annotations[yourAnnotationAtIndex], animated: true)
            
            locationSave = placemark.coordinate
            addressSave = placemark.addressDictionary!
            selectedLocation = 1
            self.resultSearchController!.searchBar.text = ""

        } else {
            self.resultSearchController!.searchBar.text = ""

            SCLAlertView().showError("Hold On...", subTitle:"You entered a invalid address. Please try again. A valid address includes street number and street name.", closeButtonTitle:"OK")
            
        }
        
        print(locationSave)

        
        
    }
}

extension addressSelectViewController : MKMapViewDelegate {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        if #available(iOS 9.0, *) {
            pinView?.pinTintColor = UIColor.orangeColor()
        } else {
            // Fallback on earlier versions
        }
        
        pinView?.canShowCallout = true
        //let smallSquare = CGSize(width: 30, height: 30)
        //let button = UIButton(frame: CGRect(origin: CGPointZero, size: smallSquare))
        //button.setBackgroundImage(UIImage(named: "car"), forState: .Normal)
        //button.addTarget(self, action: "getDirections", forControlEvents: .TouchUpInside)
        //pinView?.leftCalloutAccessoryView = button
        return pinView
    }
    
}