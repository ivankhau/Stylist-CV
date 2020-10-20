//
//   SPLocationManager.swift
//
//
//   Created by Sergej Pershaj on 06/04/16.
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import CoreLocation

/**
 Constants within this enum determines which type of authorization to location services
 the app needs to request correct authorization level.
 - parameter WhenInUseAuthorization This app is authorized to start most location services while running in the foreground. This authorization does not allow you to use APIs that could launch your app in response to an event, such as region monitoring and the significant location change services.
 - parameter AlwaysAuthorization This app is authorized to start location services at any time. This authorization allows you to use all location services, including those for monitoring regions and significant location changes.
 */
public enum AuthorizationRequestType {
    case WhenInUseAuthorization
    case AlwaysAuthorization
}

/// Used to send message and payload to the app whenever a location changes, an error occurred or
/// authorization status is changed.
public class LocationNotification: NSObject {
    // Constants for notifications sent from LocationManager to outside
    public static let kLocationUpdated = "locationUpdated"
    public static let kAuthorizationStatusChanged = "authorizationStatusChanged"
    public static let kLocationManagerDidFailWithError = "locationManagerDidFailWithError"
    public static let kNotificationDataKey = "data"
    
    let name: String //name of the notification, used to correctly add observer in the app classes
    let status: Int //represents rawValue of CLAuthorizationStatus for notifying external classes about exact status
    let statusMessage: String //represents status description in human-friendly readable format, see statusMessageDictionary
    let latitude: Double //latitude of the device location, sent when the authorization granted and location is updated
    let longitude: Double //longitude of the device location, sent when the authorization granted and location is updated
    let error: NSError? //in case LocationManager fails with error, this property contains such error
    
    init(name: String, status: Int, statusMessage: String, latitude: Double = 0.0, longitude: Double = 0.0, error: NSError? = nil) {
        self.name = name
        self.status = status
        self.statusMessage = statusMessage
        self.latitude = latitude
        self.longitude = longitude
        self.error = error
    }
}

// Marked as final to avoid singleton subclassing
public final class SPLocationManager: NSObject {
    
    //MARK: Internal section
    public static let sharedInstance = SPLocationManager()

    // Determines whether LocationManager is already started/running or not
    public var isRunning = false
    public var debug = true
    
    //MARK: Private section
    private let locationManager: CLLocationManager = CLLocationManager()
    // Contains human-friendly statuses of authorization level to location services granted to the app
    private let statusMessageDictionary = [
        CLAuthorizationStatus.NotDetermined:"The user has not yet made a choice regarding whether this app can use location services.",
        CLAuthorizationStatus.Restricted:"This app is not authorized to use location services. The user cannot change this app’s status, possibly due to active restrictions such as parental controls being in place.",
        CLAuthorizationStatus.Denied:"The user explicitly denied the use of location services for this app or location services are currently disabled in Settings.",
        CLAuthorizationStatus.AuthorizedAlways:"This app is authorized to start location services at any time. This authorization allows you to use all location services, including those for monitoring regions and significant location changes.",
        CLAuthorizationStatus.AuthorizedWhenInUse:"This app is authorized to start most location services while running in the foreground. This authorization does not allow you to use APIs that could launch your app in response to an event, such as region monitoring and the significant location change services."
    ]
    
    // Marking init() as private to avoid instantiation from outside of the singleton itself
    private override init(){
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func sendNotification(notification: LocationNotification) {
        if debug {
            print(notification)
        }
        
        var userInfo = [String:AnyObject]()
        userInfo[LocationNotification.kNotificationDataKey] = notification
        
        let nc = NSNotificationCenter.defaultCenter()
        nc.postNotificationName(notification.name, object: self, userInfo: userInfo)
    }
    
    public func startUpdatingLocationWith(type: AuthorizationRequestType) {
        let status = authorizationStatus()
        
        if debug {
            print("startLocatingWith locationServicesEnabled: \(locationServicesEnabled()), type: \(type), status: \(status.rawValue)")
        }
        
        if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
            if !isRunning {
                locationManager.startUpdatingLocation()
                isRunning = true
            }
        } else {
            switch type {
            case .WhenInUseAuthorization:
                locationManager.requestWhenInUseAuthorization()
                
                
                
                
            case .AlwaysAuthorization:
                locationManager.requestAlwaysAuthorization()
                if CLLocationManager.significantLocationChangeMonitoringAvailable() {
                    locationManager.startMonitoringSignificantLocationChanges()
                }
            }
        }
    }
    
    public func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
        isRunning = false
    }
    
    public func authorizationStatus() -> CLAuthorizationStatus {
        // check current authorization status
        return CLLocationManager.authorizationStatus()
    }
    
    public func locationServicesEnabled() -> Bool {
        // check current authorization status
        return CLLocationManager.locationServicesEnabled()
    }
}

extension SPLocationManager: CLLocationManagerDelegate {
    
    public func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        if debug {
            print("locationManager: didFailWithError, locationServicesEnabled = \(CLLocationManager.locationServicesEnabled()), error = \(error)")
        }
        
        stopUpdatingLocation()
        
        let status = authorizationStatus()
        let notification = LocationNotification(name: LocationNotification.kLocationManagerDidFailWithError, status: Int(status.rawValue), statusMessage: statusMessageDictionary[status]!, latitude: 0.0, longitude: 0.0, error: error)
        sendNotification(notification)
    }
    
    
    
    public func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let arrayOfLocation = locations as NSArray
        let location = arrayOfLocation.lastObject as! CLLocation
        //let coordLatLon = location.coordinate

        //let status = authorizationStatus()
        //let notification = LocationNotification(name: LocationNotification.kLocationUpdated, status: Int(status.rawValue), statusMessage: statusMessageDictionary[status]!, latitude: coordLatLon.latitude, longitude: coordLatLon.longitude)
        //sendNotification(notification)
        
        
        currentUserLocation = location
        hasLocation = true
        //print(location)
        
    }
    
    public func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus){
        /*if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
            isRunning = true
        } else {
            
            
            
            stopUpdatingLocation()
            
        }*/
        
        if (status == CLAuthorizationStatus.Denied) {
            // The user denied authorization
            stopUpdatingLocation()
            
            isGranted = false
            
            let notification = LocationNotification(name: LocationNotification.kAuthorizationStatusChanged, status: Int(status.rawValue), statusMessage: statusMessageDictionary[status]!)
            sendNotification(notification)
            
            
        } else if (status == CLAuthorizationStatus.AuthorizedAlways) {
            // The user accepted authorization
            
            locationManager.startUpdatingLocation()
            
            
            isGranted = true
            
            let notification = LocationNotification(name: LocationNotification.kAuthorizationStatusChanged, status: Int(status.rawValue), statusMessage: statusMessageDictionary[status]!)
            sendNotification(notification)
            
            
            
        } else if (status == CLAuthorizationStatus.AuthorizedWhenInUse) {
            locationManager.startUpdatingLocation()
            
            
            isGranted = true
            
            let notification = LocationNotification(name: LocationNotification.kAuthorizationStatusChanged, status: Int(status.rawValue), statusMessage: statusMessageDictionary[status]!)
            sendNotification(notification)

        }
        
        
    }
    
    
    
}