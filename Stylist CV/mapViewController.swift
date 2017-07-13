//
//  mapViewController.swift
//  Hair CV
//
//  Created by Ivan Khau on 4/17/16.
//  Copyright © 2016 Peer Goggles. All rights reserved.
//

import UIKit
import MapKit

class mapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    /*
    override func viewWillDisappear(animated: Bool) {
        stylistInSearch.removeAll(keepCapacity: false)
    }*/

    override func viewDidLoad() {
        super.viewDidLoad()
        
        distanceLabel.layer.cornerRadius = 7
        distanceLabel.layer.masksToBounds = true
        
        let titleLabel = UILabel()
        titleLabel.frame.size.height = 40
        titleLabel.frame.size.width = 120
        titleLabel.font = UIFont(name: "AvenirNext", size: 22)
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = .Center
        titleLabel.text = "Map"
        self.navigationItem.titleView = titleLabel

        
        self.createPinsToMap()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: MapViewDelegate
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil{
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            if #available(iOS 9.0, *) {
                pinView!.pinTintColor = UIColor.redColor()
            } else {
                // Fallback on earlier versions
            }
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl){
        if control == view.rightCalloutAccessoryView{
            let app = UIApplication.sharedApplication()
            if let followLink = view.annotation?.subtitle! {
                app.openURL(NSURL(string: followLink)!)
            }
        }
    }
    
    // MARK: Add pins to the map
    func createPinsToMap(){
        /*for stylist in stylistInSearch{
            let pinPoint = MKPointAnnotation()
            let location = CLLocationCoordinate2D(latitude: stylist["location"].latitude, longitude: stylist["location"].longitude)
            pinPoint.coordinate = location
            //pinPoint.title = "\(dictionary.fullName)"
            
            pinPoint.title = "\(stylist["name"])"
            
            //pinPoint.subtitle = dictionary.mediaURL
            mapView.addAnnotation(pinPoint)
            
            
            
            
            
            let span = MKCoordinateSpanMake(1.20, 1.20)
            //let testy = stylist["location"][0] as! CLLocation
            let region = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: true)
            
            
        }*/
        
        //let span = MKCoordinateSpanMake(0.05, 0.05)
        //let region = MKCoordinateRegion(center: location.first.coordinate, span: span)
        //mapView.setRegion(region, animated: true)
        
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
