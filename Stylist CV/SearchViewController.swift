//
//  SearchViewController.swift
//  Hair Dew
//
//  Created by Ivan Khau on 4/1/16.
//  Copyright © 2016 Peer Goggles. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase
import Kingfisher

class SearchViewController: UIViewController, UIScrollViewDelegate {
    
    var canRefresh:Bool = true
    
    var avgArray = [Double]()
    var distanceArray = [String]()
    var countArray = [Int]()
    var timeOut:Int = 0
    var userDict = [NSMutableDictionary]()
    var userKey = [String]()
    
    var searchedDistance:Double = 0
    var searchedLat:Double = 0
    var searchedLon:Double = 0
    
    let pulseView = WAActivityIndicatorView(frame: CGRect(x: phonewidth/2 - 25, y: phoneheight/2 - 25 - 60, width: 50, height: 50),
                                            indicatorType: ActivityIndicatorType.ThreeDotsScale,
                                            tintColor: UIColor.blackColor(),
                                            indicatorSize: 50)

    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var hairDoFilter: UIBarButtonItem!
    
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var tableTopConstraint: NSLayoutConstraint!
    
    var refresher: UIRefreshControl!
    
    func refresh() {
        
        if canRefresh == true {
        
        print("can refresh and is refreshing")
            
        queryStylists()
        self.refresher.endRefreshing()
        } else {
            print("no refreshing scrub")
            
            self.view.userInteractionEnabled = false
            let triggerTime = (Int64(NSEC_PER_SEC) * 1)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
                self.refresher.endRefreshing()
                self.view.userInteractionEnabled = true
            })
            
        }
        
    }
    
    func resetRefresh() {
        
        canRefresh = true
        print("CAN REFRESH")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NSTimer.scheduledTimerWithTimeInterval(25.0, target: self, selector: #selector(SearchViewController.resetRefresh), userInfo: nil, repeats: true)
        
        // OEM REFRESHER
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(SearchViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
        self.searchTableView.addSubview(refresher)
        
        if SPLocationManager.sharedInstance.locationServicesEnabled() {
            startLocationServices()
            //mapView.showsUserLocation = true
        } else {
            //TODO: show screen which explains why need to turn on location services
            print("viewDidAppear checkLocationServicesEnabled = false, TODO: handle this in UI")
        }
        
        searchTableView.hidden = true
        
        let triggerTime = (Int64(NSEC_PER_SEC) * 6)
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
            
            self.pulseView.stopAnimating()
            self.pulseView.removeFromSuperview()
            self.searchTableView.hidden = false
            
        })

        hairDoFilter.enabled = false
        hairDoFilter.tintColor = UIColor.clearColor()

        database = FIRDatabase.database()
        auth = FIRAuth.auth()
        storage = FIRStorage.storage()
        formatTitle()
        registerNibs()
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: #selector(self.locationUpdated(_:)), name: "userLocationUpdate", object: nil)
        
        if stand.boolForKey("declinedLocationShowNotice") == true {
            stand.setBool(false, forKey: "declinedLocationShowNotice")
            
            SCLAlertView().showNotice("Notice", subTitle: "Search location has been defaulted to Mountain View, CA. You can change your search location by going to filters on the top left.")
            
        }
        
        //if Reachability.isConnectedToNetwork() == true {
        //    print("Connected to the World Wide Web!")
        
            checkUser()
            queryStylists()
            checkFollowed()
        
        //} else {
        //    SCLAlertView().showError("No Internet Connection", subTitle:"Try Again Later", closeButtonTitle:"OK")
        //}
        
        checkMessages()
        
    }
    
    @IBAction func filterButtonTapped(sender: AnyObject) {
        showFilterView()
    }
    
    func registerNibs() {
        // Setting up the table view and table cells
        let businessCellNib = UINib(nibName: "searchViewControllerCell", bundle: nil);
        searchTableView.registerNib(businessCellNib, forCellReuseIdentifier: "searchCell")
        searchTableView.estimatedRowHeight = 123
        searchTableView.rowHeight = UITableViewAutomaticDimension
        searchTableView.separatorStyle = .None
    }
    
    func formatTitle() {
        self.navigationItem.titleView = TitleViewStyle(text: "Search")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func startLocationServices() {
        SPLocationManager.sharedInstance.startUpdatingLocationWith(AuthorizationRequestType.AlwaysAuthorization)
        
        let nc = NSNotificationCenter.defaultCenter()
        // adding observers for messages sent from LocaitonManager's singleton
        nc.addObserver(self, selector: #selector(SearchViewController.locationUpdated(_:)), name: LocationNotification.kLocationUpdated, object: nil)
        nc.addObserver(self, selector: #selector(SearchViewController.locationAuthorizationStatusChanged(_:)), name: LocationNotification.kAuthorizationStatusChanged, object: nil)
        nc.addObserver(self, selector: #selector(SearchViewController.locationManagerDidFailWithError(_:)), name: LocationNotification.kLocationManagerDidFailWithError, object: nil)
    }
    
    // Invoked when location services enabled, authorization granted and location manager
    // sends update about device location
    func locationUpdated(notification: NSNotification) {
        //        print("MapViewController locationUpdated")
        
        /*if let userInfo = notification.userInfo, data = userInfo[LocationNotification.kNotificationDataKey] {
            let data = data as! LocationNotification
            //print("MapViewController locationUpdated, userInfo.longitude = \(data.longitude), userInfo.latitude = \(data.latitude)")
            
            //let center = CLLocationCoordinate2D(latitude: data.latitude, longitude: data.longitude)
            
            //print(center)
            //let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            //mapView.setRegion(region, animated: true)
        }*/
    }
    
    // Invoked when authorization status changes
    // sends update about device location
    func locationAuthorizationStatusChanged(notification: NSNotification) {
        if let userInfo = notification.userInfo, data = userInfo[LocationNotification.kNotificationDataKey] {
            let data = data as! LocationNotification
            
            print("MapViewController locationAuthorizationStatusChanged userInfo.status = \(data.status) \(data.statusMessage), locationServicesEnabled = \(SPLocationManager.sharedInstance.locationServicesEnabled())")
            
            if SPLocationManager.sharedInstance.locationServicesEnabled() {
                //TODO: handle a case for not granting authorization (user explicitly denied authorization in the iOS Settings)
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
    
    override func viewDidAppear(animated: Bool) {
        setPushID()
        selfViewFromSearch = false
        
        if NSUserDefaults.standardUserDefaults().boolForKey("customLocation") == true {
            let distance = NSUserDefaults.standardUserDefaults().doubleForKey("distanceSetting")
            let customlocation = NSUserDefaults.standardUserDefaults().stringForKey("customLocationString")
            settingsLabel.text = "Stylists within \(distance) mi of \(customlocation!)."
        } else {
            let distance = NSUserDefaults.standardUserDefaults().doubleForKey("distanceSetting")
            settingsLabel.text = "Stylists within \(distance) mi of your current location."
        }
        
        if stand.boolForKey("needRefresh") == true {
            stand.setBool(false, forKey: "needRefresh")
            queryStylists()
        }
        
                
        
    }
    
    func queryStylists() {
        
        view.addSubview(pulseView)
        pulseView.startAnimating()
        
        self.view.userInteractionEnabled = false
        
        //var counto:Int=0
        //counto = 0
        if hasLocation == true || stand.integerForKey("authorizationSet") == 0 || stand.boolForKey("customLocation") == true {
            
        searchedDistance = stand.doubleForKey("distanceSetting")

        if stand.boolForKey("customLocation") == false {
            searchedLat = currentUserLocation.coordinate.latitude
            searchedLon = currentUserLocation.coordinate.longitude
            
            } else {
            searchedLat = stand.doubleForKey("lat")
            searchedLon = stand.doubleForKey("lng")
        }
            
        var radInMiles = Double()
            
        if stand.doubleForKey("distanceSetting") == 10 {
                radInMiles = 16.0934
            } else if stand.doubleForKey("distanceSetting") == 25 {
                radInMiles = 40.2335
            } else if stand.doubleForKey("distanceSetting") == 50 {
                radInMiles = 80.467
            } else if stand.doubleForKey("distanceSetting") == 100 {
                radInMiles = 160.934
        }
        
        database = FIRDatabase.database()
        auth = FIRAuth.auth()
        storage = FIRStorage.storage()
        
        let geofireRef = FIRDatabase.database().reference().child("lo")
        let geoFire = GeoFire(firebaseRef: geofireRef)
        
        // QUERY IN A CIRCLE WITH A RADIUS
        let center = CLLocation(latitude: searchedLat, longitude: searchedLon)
        let circleQuery = geoFire.queryAtLocation(center, withRadius: radInMiles)
        
        // QUERY IN A SQUARE
        /*let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(center.coordinate, span)
        let regionQuery = geoFire.queryWithRegion(region)*/
            
        self.userDict.removeAll()
        self.userKey.removeAll()
        self.searchTableView.reloadData()
        
        circleQuery.observeEventType(.KeyEntered) { (snapshoto, locationo) in

            let queryRef = FIRDatabase.database().reference().child("st").child(snapshoto)
            
            queryRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in

                let convDict = snapshot.value as! NSMutableDictionary
                
                // CHANGE VALUE FOR MINIMUM SCORE NEEDED TO HAVE PF PUBLIC
                if convDict["sc"] as! Double > 3 {
                    
                    if self.userKey.contains(snapshot.key) {
                        
                    } else {
                        
                    self.userKey.append(snapshot.key)
                    
                    convDict.setValuesForKeysWithDictionary(["uid":snapshot.key])
                        self.userDict.append(convDict)
                        
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if self.userDict.count > 4 {
                    self.userDict.sortInPlace { ($0.0["sc"] as! Double) > ($0.1["sc"] as! Double) }
                    }
                    
                    circleQuery.removeAllObservers()

                    
                    self.canRefresh = false
                    
                    let triggerTime = (Int64(NSEC_PER_SEC) * 1/2)
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
                    self.searchTableView.reloadData()
                        
                        self.searchTableView.hidden = false
                        self.view.userInteractionEnabled = true

                        self.pulseView.stopAnimating()
                        self.pulseView.removeFromSuperview()

                    })
                })
            })
        }
            
        
        
        } else {
            
            let triggerTime = (Int64(NSEC_PER_SEC) * 1/2)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
                self.queryStylists()
            })
        }
    }
    
    func showMapView() {
        
        self.performSegueWithIdentifier("toMapSegue", sender: self)
    }

    func showFilterView(){
        
        self.performSegueWithIdentifier("toLocationSegue", sender: self)
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return userDict.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("searchCell", forIndexPath: indexPath) as! searchViewControllerCell
        
        if self.userDict[indexPath.row].objectForKey("iu") != nil {
            cell.stylistImage.kf_setImageWithURL(NSURL(string: self.userDict[indexPath.row].objectForKey("iu") as! String)!, placeholderImage: nil)
        } else {
            cell.stylistImage.image = UIImage(named: "women-hair.png")
        }
        
        
        cell.previewImageOne.image = UIImage(named: "nosideimage.png")

        if self.userDict[indexPath.row].objectForKey("iuo") != nil {
            cell.previewImageOne.kf_setImageWithURL(NSURL(string: self.userDict[indexPath.row].objectForKey("iuo") as! String)!, placeholderImage: nil)
        } else {
            cell.previewImageOne.image = UIImage(named: "nosideimage.png")

        }
        
        cell.previewImageTwo.image = UIImage(named: "nosideimage.png")

        if self.userDict[indexPath.row].objectForKey("iut") != nil {
            cell.previewImageTwo.kf_setImageWithURL(NSURL(string: self.userDict[indexPath.row].objectForKey("iut") as! String)!, placeholderImage: nil)
        } else {
            cell.previewImageTwo.image = UIImage(named: "nosideimage.png")
        }

        if self.userDict[indexPath.row].objectForKey("fn") != nil && self.userDict[indexPath.row].objectForKey("ln") != nil {
            
            let fName = self.userDict[indexPath.row].objectForKey("fn") as! String
            let lName = self.userDict[indexPath.row].objectForKey("ln") as! String
            cell.stylistNameLabel.text = "\(fName) \(lName)"
            
        } else {
            cell.stylistNameLabel.text = ""
        }
        
        if let ratingCounto = self.userDict[indexPath.row].objectForKey("rc") {
            
            if ratingCounto as! Float != 0 {
                
                let avgo = (self.userDict[indexPath.row].objectForKey("rs") as! Float)/(ratingCounto as! Float)
                
                cell.ratingView.rating = avgo
                
                cell.reviewCountLabel.text = "\(ratingCounto) Reviews"

            } else {
                
                cell.reviewCountLabel.text = "0 Reviews"
                cell.ratingView.rating = 0
                            }
            
        } else {
            cell.reviewCountLabel.text = "0 Reviews"
            cell.ratingView.rating = 0
        }
        
        if let addressoLinoDos = self.userDict[indexPath.row].objectForKey("at") {
            
            let linoUno = self.userDict[indexPath.row].objectForKey("ao") as! String
            let linoDos = addressoLinoDos as! String
            
            let workNameo = self.userDict[indexPath.row].objectForKey("wn") as! String
            
            cell.addressLabel.text = "\(workNameo)\r\(linoUno)\r\(linoDos)"
            
            
            
        } else {
            
            if let addressoLinoUno = self.userDict[indexPath.row].objectForKey("ao") {
                
                let linoUno = addressoLinoUno as! String
                cell.addressLabel.text = "\(linoUno)"
                
            } else {
                
                 cell.addressLabel.text = ""
                
            }
            
        }
        
        /*if let abouto = self.userDict[indexPath.row].objectForKey("ab") {
            cell.aboutLabel.text = (abouto as! String)
        } else {
            cell.aboutLabel.text = "I just joined Stylist CV"
        }*/
        
        if let portCounto = self.userDict[indexPath.row].objectForKey("po") {
            cell.portfolioCount.text = "\(portCounto)"
        } else {
            cell.portfolioCount.text = "0"
        }
        
        if hasLocation != false {
            
            if self.userDict[indexPath.row].objectForKey("lo") != nil && self.userDict[indexPath.row].objectForKey("la") != nil {
            let latitudeo = self.userDict[indexPath.row].objectForKey("la") as! Double
            let longitudeo = self.userDict[indexPath.row].objectForKey("lo") as! Double

            
            let currDistance = DistanceCount.count.distance(currentUserLocation.coordinate.latitude, lon1: currentUserLocation.coordinate.longitude, lat2: latitudeo, lon2: longitudeo, units: "M")
                
                let roundo = round(10.0*currDistance)/10.0
                
                cell.distanceLabel.text = "\(roundo) mi"
            
            } else {
                
                cell.distanceLabel.text = ""
                
            }

        } else {
            
            cell.distanceLabel.text = ""
            
        }
        
        let rowNum = indexPath.row + 1
        cell.numberLabel.text = "\(rowNum)"
        
        if let pricy = userDict[indexPath.row].objectForKey("pr") {
            cell.priceLabel.text = (pricy as! String)
        } else {
            cell.priceLabel.text = ""
        }
        

        
        return cell
    }
    
    var backoDict = NSMutableDictionary()
    var backoKey = String()
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        backoDict = userDict[indexPath.row]
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        self.performSegueWithIdentifier("seeStylistSegue", sender: self)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if scrollView == searchTableView {
            
            if (scrollView.contentOffset.y <= 0) {
                tableTopConstraint.constant = 34
                UIView.animateWithDuration(0.25) {
                    self.view.layoutIfNeeded()
                }
            } else {
                
                tableTopConstraint.constant = 0
                UIView.animateWithDuration(0.25) {
                    self.view.layoutIfNeeded()
                }
                    
            }
            
        }
    
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "seeStylistSegue"){
            let detailScene = segue.destinationViewController as! stylistProfileViewController
            //detailScene.selectedKey = backoKey
            detailScene.selectedDict = backoDict
            
        }
        
    }
    
    func checkMessages() {
        if FIRAuth.auth()?.currentUser != nil {
            let chMessRef = queryRef.child("ch").child("re").child((FIRAuth.auth()?.currentUser!.uid)!)
            /*chMessRef.observeEventType(.ChildAdded, withBlock: { (snapo) -> Void in
            
                var readArray = [String]()
                readArray.append("\(snapo.value!.valueForKey("re")!)")
                
                if readArray.contains("0") {
                
                    chMessRef.removeAllObservers()
                    self.tabBarController?.tabBar.items?[2].badgeValue = "!"
                
                }
            
        })*/
            chMessRef.observeEventType(.ChildAdded, withBlock: { (snapo) in
                var readArray = [String]()
                readArray.append("\(snapo.value!.valueForKey("re")!)")
                
                if readArray.contains("0") {
                    
                    //chMessRef.removeAllObservers()
                    self.tabBarController?.tabBar.items?[2].badgeValue = "!"
                    
                }
            })
        }
        
    }


}


