//
//  customLocationViewController.swift
//  Hair CV
//
//  Created by Ivan Khau on 4/20/16.
//  Copyright © 2016 Peer Goggles. All rights reserved.
//

import UIKit
import MapKit

class customLocationViewController: UIViewController,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate,UISearchBarDelegate, UITextFieldDelegate, UIActionSheetDelegate {

    @IBOutlet weak var selectedLocationLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func closeAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) {
        }
    }
    @IBAction func selectedSegment(sender: AnyObject) {
    }
    @IBOutlet weak var distanceSegmentedOutlet: UISegmentedControl!
    @IBOutlet weak var locationSegmentedOutlet: UISegmentedControl!
    var locationSave = CLLocationCoordinate2D()
    var addressSave = NSDictionary()
    var resultSearchController:UISearchController? = nil
    var selectedPin:MKPlacemark? = nil
    let locationManager = CLLocationManager()
    var alertError:NSString!
    var picker:UIImagePickerController?=UIImagePickerController()
    var popover:UIPopoverController?=nil
    var selectedDistanceSetting = Double()
    var selectedLocationString = String()
    var lat = Double()
    var lng = Double()
    
    
    
    var locationSelected = false
    
    
    func showAlertWith(error: String) {
        let alertController = UIAlertController(title: "Alert", message: error, preferredStyle:.Alert)
        let alertActionOK = UIAlertAction(title: "OK", style: .Cancel) { action -> Void in
            
        }
        alertController.addAction(alertActionOK)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func getDirections(){
        if let selectedPin = selectedPin {
            let mapItem = MKMapItem(placemark: selectedPin)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMapsWithLaunchOptions(launchOptions)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if NSUserDefaults.standardUserDefaults().doubleForKey("distanceSetting") == 10 {
            distanceSegmentedOutlet.selectedSegmentIndex = 0
        } else if NSUserDefaults.standardUserDefaults().doubleForKey("distanceSetting") == 25 {
            distanceSegmentedOutlet.selectedSegmentIndex = 1
        } else if NSUserDefaults.standardUserDefaults().doubleForKey("distanceSetting") == 50 {
            distanceSegmentedOutlet.selectedSegmentIndex = 2
        }
        else if NSUserDefaults.standardUserDefaults().doubleForKey("distanceSetting") == 100 {
            distanceSegmentedOutlet.selectedSegmentIndex = 3
        }
        
        if stand.integerForKey("authorizationSet") == 1 {
            if NSUserDefaults.standardUserDefaults().boolForKey("customLocation") == false {
                selectedLocationLabel.text = "Current"
                locationSegmentedOutlet.selectedSegmentIndex = 0
            } else {
                setCustomLocation()
            }
            
        } else {
            setCustomLocation()
            
            locationSegmentedOutlet.userInteractionEnabled = false
            locationSegmentedOutlet.alpha = 0.25
        }
        
        
        
        
        
        picker!.delegate=self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        if #available(iOS 9.0, *) {
            locationManager.requestLocation()
        } else {
            // Fallback on earlier versions
            
            
        }
        
    }
    
    func setCustomLocation() {
        
        selectedLocationLabel.text = (stand.valueForKey("customLocationString") as! String)
        
        locationSegmentedOutlet.selectedSegmentIndex = 1
        let locationSearchTable = self.storyboard!.instantiateViewControllerWithIdentifier("LocationSearchTable") as! LocationSearchTable
        self.resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        self.resultSearchController?.searchResultsUpdater = locationSearchTable
        let searchBar = self.resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search Address"
        
        searchBar.layer.borderColor = UIColor.darkGrayColor().CGColor
        searchBar.layer.borderWidth = 3
        self.navigationItem.titleView = self.resultSearchController?.searchBar
        self.resultSearchController?.hidesNavigationBarDuringPresentation = false
        self.resultSearchController?.dimsBackgroundDuringPresentation = true
        self.definesPresentationContext = true
        locationSearchTable.mapView = self.mapView
        locationSearchTable.handleMapSearchDelegate = self
    }
    
    @IBAction func locationSegmentedAction(sender: AnyObject) {
        
        if locationSegmentedOutlet.selectedSegmentIndex == 1 {
            
            let locationSearchTable = self.storyboard!.instantiateViewControllerWithIdentifier("LocationSearchTable") as! LocationSearchTable
            self.resultSearchController = UISearchController(searchResultsController: locationSearchTable)
            self.resultSearchController?.searchResultsUpdater = locationSearchTable
            let searchBar = self.resultSearchController!.searchBar
            searchBar.sizeToFit()
            searchBar.placeholder = "Search Address"
            
            searchBar.layer.borderColor = UIColor.darkGrayColor().CGColor
            searchBar.layer.borderWidth = 3
            
            self.navigationItem.titleView = self.resultSearchController?.searchBar
            self.resultSearchController?.hidesNavigationBarDuringPresentation = false
            self.resultSearchController?.dimsBackgroundDuringPresentation = true
            self.definesPresentationContext = true
            locationSearchTable.mapView = self.mapView
            locationSearchTable.handleMapSearchDelegate = self
        } else {
            let diff = UILabel()
            //diff.text = "Edit Search Filter"
            //diff.textColor = UIColor.whiteColor()
            self.navigationItem.titleView = diff
            selectedLocationLabel.text = "Current"
        }
    }

    @IBAction func saveAction(sender: AnyObject) {
        
        stand.setBool(true, forKey: "needRefresh")
        
        if distanceSegmentedOutlet.selectedSegmentIndex == 0 {
            NSUserDefaults.standardUserDefaults().setDouble(10, forKey: "distanceSetting")
        } else if distanceSegmentedOutlet.selectedSegmentIndex == 1 {
            NSUserDefaults.standardUserDefaults().setDouble(25, forKey: "distanceSetting")
        } else if distanceSegmentedOutlet.selectedSegmentIndex == 2 {
            NSUserDefaults.standardUserDefaults().setDouble(50, forKey: "distanceSetting")
        } else if distanceSegmentedOutlet.selectedSegmentIndex == 3{
            NSUserDefaults.standardUserDefaults().setDouble(100, forKey: "distanceSetting")
        }
        
        if locationSegmentedOutlet.selectedSegmentIndex == 1 && locationSelected == true {
            
            NSUserDefaults.standardUserDefaults().setDouble(lat, forKey: "lat")
            NSUserDefaults.standardUserDefaults().setDouble(lng, forKey: "lng")
            
            NSUserDefaults.standardUserDefaults().setValue(selectedLocationString, forKey: "customLocationString")
            
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "customLocation")
        }
        
        
        if self.locationSegmentedOutlet.selectedSegmentIndex == 0 {
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "customLocation")
        }
        
        self.dismissViewControllerAnimated(true) {
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension customLocationViewController : CLLocationManagerDelegate {
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

extension customLocationViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        //mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        
        if placemark.country != nil {
            annotation.subtitle = placemark.country!
            selectedLocationLabel.text = placemark.country!
            selectedLocationString = placemark.country!
        }
        if placemark.administrativeArea  != nil {
            annotation.subtitle = placemark.administrativeArea!
            selectedLocationLabel.text = placemark.administrativeArea!
            selectedLocationString = placemark.administrativeArea!
        }
        if placemark.locality != nil {
            annotation.subtitle = placemark.locality!
            selectedLocationLabel.text = placemark.locality!
            selectedLocationString = placemark.locality!
        }
        
        self.addressSave = placemark.addressDictionary!
        
        
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
        let yourAnnotationAtIndex = 0
        mapView.selectAnnotation(mapView.annotations[yourAnnotationAtIndex], animated: true)
        locationSave = placemark.coordinate
        
        self.resultSearchController!.searchBar.text = ""
        
        lat = placemark.coordinate.latitude
        lng = placemark.coordinate.longitude
        locationSelected = true
        
    }
}

extension customLocationViewController : MKMapViewDelegate {
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
