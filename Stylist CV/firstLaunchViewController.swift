//
//  firstLaunchViewController.swift
//  Hair CV
//
//  Created by Ivan Khau on 4/18/16.
//  Copyright © 2016 Peer Goggles. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class firstLaunchViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var acceptButton: UIButton!
    
    @IBOutlet weak var mid: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mid.layer.cornerRadius = mid.frame.size.height / 2
        mid.layer.masksToBounds = true
        mid.layer.borderColor = UIColor(red: 182 / 255.0, green: 197 / 255.0, blue: 217 / 255.0, alpha: 1.0).CGColor
        mid.layer.borderWidth = 2

        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .Restricted, .Denied:
                print("No access")
                
                self.performSegueWithIdentifier("toTabSegue", sender: self)
                
            case .AuthorizedAlways, .AuthorizedWhenInUse:
                print("Access")
                
                self.performSegueWithIdentifier("toTabSegue", sender: self)
                
                
            case .NotDetermined:
                
                print("not determined")
                
                
            }
            
            //self.performSegueWithIdentifier("toTabSegue", sender: self)
            
        } else {
            print("Location services are not enabled")
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }

    @IBAction func buttonTap(sender: AnyObject) {
        print(currentUserLocation)
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: #selector(self.locationUpdated(_:)), name: "userLocationUpdate", object: nil)
        
        if SPLocationManager.sharedInstance.locationServicesEnabled() {
            
            startLocationServices()
            
        } else {

        }
    }
    
    func startLocationServices() {
        SPLocationManager.sharedInstance.startUpdatingLocationWith(AuthorizationRequestType.WhenInUseAuthorization)
        
        let nc = NSNotificationCenter.defaultCenter()
        // adding observers for messages sent from LocaitonManager's singleton
        nc.addObserver(self, selector: #selector(SearchViewController.locationUpdated(_:)), name: LocationNotification.kLocationUpdated, object: nil)
        nc.addObserver(self, selector: #selector(SearchViewController.locationAuthorizationStatusChanged(_:)), name: LocationNotification.kAuthorizationStatusChanged, object: nil)
        nc.addObserver(self, selector: #selector(SearchViewController.locationManagerDidFailWithError(_:)), name: LocationNotification.kLocationManagerDidFailWithError, object: nil)
        
    }
    
    func locationUpdated(notification: NSNotification) {
        /*
        if locationStarted == false {
            locationStarted = true
        self.performSegueWithIdentifier("toTabSegue", sender: self)
            
        }*/
    }
    
    func locationAuthorizationStatusChanged(notification: NSNotification) {
        if let userInfo = notification.userInfo, data = userInfo[LocationNotification.kNotificationDataKey] {
            let data = data as! LocationNotification
            
            print("MapViewController locationAuthorizationStatusChanged userInfo.status = \(data.status) \(data.statusMessage), locationServicesEnabled = \(SPLocationManager.sharedInstance.locationServicesEnabled())")
            
            if SPLocationManager.sharedInstance.locationServicesEnabled() {
                //TODO: handle a case for not granting authorization (user explicitly denied authorization in the iOS Settings)
                
                if isGranted == true {
                    
                    stand.setBool(false, forKey: "uploadPushID")
                    stand.setBool(false, forKey: "needRefresh")
                    stand.setBool(true, forKey: "launchedBefore")
                    // 0=no 1=yes
                    stand.setInteger(1, forKey: "authorizationSet")
                    stand.setBool(false, forKey: "customLocation")
                    stand.setDouble(25, forKey: "distanceSetting")
                    stand.setBool(false, forKey: "declinedLocationShowNotice")
                    stand.setDouble(37.3861, forKey: "lat")
                    stand.setDouble(-122.0839, forKey: "lng")
                    stand.setValue("Mountain View, CA", forKey: "customLocationString")
                    
                    self.performSegueWithIdentifier("toTabSegue", sender: self)
                    
                    
                } else if isGranted == false {
                    
                    stand.setBool(false, forKey: "uploadPushID")
                    stand.setBool(false, forKey: "needRefresh")
                    stand.setBool(true, forKey: "launchedBefore")
                    // 0=no 1=yes
                    stand.setInteger(0, forKey: "authorizationSet")
                    stand.setBool(true, forKey: "customLocation")
                    stand.setDouble(25, forKey: "distanceSetting")
                    stand.setDouble(37.3861, forKey: "lat")
                    stand.setDouble(-122.0839, forKey: "lng")
                    stand.setValue("Mountain View, CA", forKey: "customLocationString")
                    
                    stand.setBool(true, forKey: "declinedLocationShowNotice")


                    self.performSegueWithIdentifier("toTabSegue", sender: self)
                    
                }

            } else {
                
                //TODO: handle a case for location services turned OFF (user explicitly set in the iOS Settings)
                
            }

        }

    }
    
    func locationManagerDidFailWithError(notification: NSNotification) {
        if let data = notification.userInfo![LocationNotification.kNotificationDataKey] {
            let data = data as! LocationNotification
            if let error = data.error {
                print("MapViewController locationManagerDidFailWithError userInfo.error.description = \(error.description)")

            }
        }
 
    }
    
}
