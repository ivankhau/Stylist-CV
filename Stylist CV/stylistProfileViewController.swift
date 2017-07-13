//
//  stylistProfileViewController.swift
//  Hair Dew
//
//  Created by Ivan Khau on 4/4/16.
//  Copyright © 2016 Peer Goggles. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class stylistProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    @IBOutlet weak var grayMessage: UIImageView!
    @IBOutlet weak var grayCall: UIImageView!
    @IBOutlet weak var grayEmail: UIImageView!
    @IBOutlet weak var grayServices: UIImageView!
    @IBOutlet weak var likeStar: UIButton!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var portfolioCountLabel: UILabel!
    @IBOutlet weak var getDirectionsLabel: UILabel!
    @IBOutlet weak var workName: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var reviewCollectionView: UICollectionView!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var stylistView: UIView!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var stylistImage: UIImageView!
    @IBOutlet weak var stylistAddress: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stylistAbout: UILabel!
    @IBOutlet weak var reviewCount: UILabel!
    @IBOutlet weak var stylistVerified: UILabel!
    @IBOutlet weak var callOutlet: UIButton!
    @IBOutlet weak var emailOutlet: UIButton!
    @IBOutlet weak var servicesOutlet: UIButton!
    @IBOutlet weak var reviewButtonOutlet: UIButton!
    @IBOutlet weak var portfolioText: UILabel!
    @IBOutlet weak var loadingPortfolioLabel: UIImageView!
    @IBOutlet weak var loadingReviewLabel: UIImageView!
    @IBOutlet weak var viewAllPortfolio: UIButton!
    @IBOutlet weak var viewAllReview: UIButton!
    @IBAction func viewAllAction(sender: AnyObject) {
        self.performSegueWithIdentifier("portfolioCollectionSegueFromSearch", sender: self)
    }
    @IBAction func closeProfile(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) {
        }
    }
    
    var noPortfolioLabel = UILabel()
    var noPortfolioView = UIView()
    var noReviewLabel = UILabel()
    var noReviewView = UIView()
    var portDict = [NSMutableDictionary]()
    var revDict = [NSMutableDictionary]()
    var selectedDict = NSMutableDictionary()

    
    func dropPinZoomIn(/*placemark:MKPlacemark*/){
        
        // cache the pin
        //selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        //let convertLocation = selectedObject!["location"] as! PFGeoPoint
        let lat = selectedDict["la"] as! Double
        let lon = selectedDict["lo"] as! Double
        let formalizeCoordinate = CLLocation(latitude: lat, longitude: lon)
        
        annotation.coordinate = formalizeCoordinate.coordinate
        /*annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
            print(placemark.addressDictionary)
        }*/
        //self.addressSave = placemark.addressDictionary!
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegionMake(formalizeCoordinate.coordinate, span)
        mapView.setRegion(region, animated: true)
        let yourAnnotationAtIndex = 0
        mapView.selectAnnotation(mapView.annotations[yourAnnotationAtIndex], animated: true)
        //locationSave = placemark.coordinate
        //print(locationSave)

    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    var followArray = [String]()
    
    var cameFromGSViewer:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)

        
        
        if imageViewerDict != nil {
            selectedDict = imageViewerDict!
            imageViewerDict = nil
            cameFromGSViewer = true
        }
        
        
        print(selectedDict)
        
        for obj in myFollowing {
            
            followArray.append(obj["uid"] as! String)
            
            if followArray.contains(selectedDict["uid"] as! String) {
                
                self.isLiked = true
                self.likeStar.setImage(UIImage(named: "staryellow.png"), forState: UIControlState.Normal)
                
            }
        }
        
        stylizeOutlets()
        populateView()
        self.formatTitle()
        
        if selfViewFromSearch == true {
            reviewButtonOutlet.enabled = false
            reviewButtonOutlet.alpha = 0.2
        }
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if userDefaults.stringForKey("userType") == "Stylist" {
            self.reviewButtonOutlet.enabled = false
            self.reviewButtonOutlet.alpha = 0.3
        }
        
        dropPinZoomIn()
        loadPortfolioData()
        
        let mapTapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(stylistProfileViewController.mapTapped(_:))); mapView.userInteractionEnabled = true; mapView.addGestureRecognizer(mapTapGestureRecognizer)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        if self.cameFromGSViewer == true {
            self.navigationController?.setNavigationBarHidden(true, animated: true)

        }
    }
    
    func formatTitle() {
        let fno = selectedDict["fn"] as! String
        let lno = selectedDict["ln"] as! String

        let titleLabel = UILabel(); titleLabel.frame.size.height = 40; titleLabel.frame.size.width = 120; titleLabel.font = UIFont(name: "Georgia-Italic", size: 20); titleLabel.textColor = UIColor.darkTextColor(); titleLabel.textAlignment = .Center; titleLabel.text = "\(fno) \(lno)"
        self.navigationItem.titleView = titleLabel
    }
    
    func mapTapped(sender: AnyObject) {
        print("MAPTAPPED!!!!!!!")
        let workNameo = selectedDict["wn"]
        let fno = selectedDict["fn"]
        let lno = selectedDict["ln"]
        let lat = self.selectedDict["la"] as! Double
        let lon = self.selectedDict["lo"] as! Double
        let coordo = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let yourPlaceMark = MKPlacemark(coordinate: coordo, addressDictionary: ["":""])
        let mapItem = MKMapItem(placemark: yourPlaceMark)
        mapItem.name = "\(fno as! String) \(lno as! String) at \(workNameo as! String)"
        //You could also choose: MKLaunchOptionsDirectionsModeWalking
        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMapsWithLaunchOptions(launchOptions)
        
    }
    
    @IBAction func emailTapped(sender: AnyObject) {
        
        print("emailTapped")
        let email = self.selectedDict["em"] as! String
        let url = NSURL(string: "mailto:\(email)")
        UIApplication.sharedApplication().openURL(url!)
        
    }
    
    @IBAction func messageTapped(sender: AnyObject) {
        
        if FIRAuth.auth()?.currentUser != nil {
            if (selectedDict["uid"] as! String) != FIRAuth.auth()?.currentUser?.uid {

            dictforchat = self.selectedDict
            self.tabBarController?.selectedIndex = 2

                
            } else {
                let appearance = SCLAlertView.SCLAppearance(
                    showCloseButton: false,
                    kTitleTop: 30
                )
                let alert = SCLAlertView(appearance: appearance)
                alert.showCustom("Hold On...", subTitle: "You can't message yourself.", color: UIColor(red: 128/255, green: 0/255, blue: 0/255, alpha: 1.0), icon: UIImage(named: "exclamation.png")!, duration: 1.5, animationStyle: SCLAnimationStyle.NoAnimation)
            }
            
        } else {
            
            let alert = SCLAlertView()
            alert.addButton("Sign In Now") {
                
                self.tabBarController?.selectedIndex = 3
            }
            
            let icon = UIImage(named:"exclamation.png")
            
            alert.showCustom("Hold On...", subTitle: "To message, you need to sign up or log in first.", color: UIColor(red: 128 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 1.0), icon: (icon)!)
        }
        
        
        
    }

    @IBAction func callTapped(sender: AnyObject) {
        
        print("call tapped")

        let phono = self.selectedDict["pn"] as! String
        
        let stringArray = phono.componentsSeparatedByCharactersInSet(
            NSCharacterSet.decimalDigitCharacterSet().invertedSet)
        let newString = stringArray.joinWithSeparator("")
        if let url = NSURL(string: "tel://\(newString)") {
            UIApplication.sharedApplication().openURL(url)
        }
        
    }
    
    
    
    func populateView() {
        
        ratingView.rating = Float(backupReviewAVG)
        reviewCount.text = "\(backupReviewCount) Reviews"
        reviewCountLabel.text = "\(backupReviewCount)"
        
        if let imagee = selectedDict.objectForKey("iu") {
            self.stylistImage.kf_setImageWithURL(NSURL(string: imagee as! String)!, placeholderImage: nil)
        } else {
        }
        
        if let addressDictionary = selectedDict.objectForKey("ao") {
            if let addressDictionaryTwo = selectedDict.objectForKey("at") {
                stylistAddress.text = "\(addressDictionary)\r\(addressDictionaryTwo)"
            } else {
                stylistAddress.text = "\(addressDictionary)"
            }
        }
        
        
        if let aboutlet = selectedDict["ab"] {
            stylistAbout.text = "\"\(aboutlet)\""
        } else {
            
        }
        
        
        if selectedDict["ve"] != nil {
            stylistVerified.text = "Verified"
        } else {
            stylistVerified.text = "Unverified"
        }
        
        if let reviewSum = selectedDict["rs"] as? Double {
            let reviewCount = selectedDict["rc"] as! Double
            
            if reviewCount != 0 {
                
                let avg = Double(reviewSum)/Double(reviewCount)
                ratingView.rating = Float(avg)
                
            } else {
                ratingView.rating = 0
            }
        }
        
        if let workNameo = selectedDict["wn"] {
            self.workName.text = workNameo as? String
        } else {
            self.workName.text = ""
        }
        
        if selectedDict["pn"] != nil {
            
            self.callOutlet.setTitle("Call", forState: .Normal)
            
        } else {
            
            self.callOutlet.setTitle("Call", forState: .Normal)
            self.callOutlet.alpha = 0.7
            self.callOutlet.enabled = false
            
            self.grayCall.alpha = 0.7
            
        }
        
        if let priceo = selectedDict["pr"] {
            self.priceLabel.text = (priceo as! String)
        } else {
            self.priceLabel.text = ""
            self.servicesOutlet.alpha = 0.7
            self.servicesOutlet.enabled = false
            self.grayServices.alpha = 0.7
        }
        
        if selectedDict["em"] as! String != "" {
            
        } else {
            
            emailOutlet.enabled = false
            emailOutlet.alpha = 0.7
            self.grayEmail.alpha = 0.7
        
        }
        
        
        if hasLocation != false {
            
            if self.selectedDict.objectForKey("lo") != nil && self.selectedDict.objectForKey("la") != nil {
                let latitudeo = self.selectedDict.objectForKey("la") as! Double
                let longitudeo = self.selectedDict.objectForKey("lo") as! Double
                
                
                let currDistance = DistanceCount.count.distance(currentUserLocation.coordinate.latitude, lon1: currentUserLocation.coordinate.longitude, lat2: latitudeo, lon2: longitudeo, units: "M")
                
                let roundo = round(10.0*currDistance)/10.0
                
                distanceLabel.text = "\(roundo) mi"
                
            } else {
                distanceLabel.text = ""
            }
            
        } else {
            distanceLabel.text = ""
        }
    }
    
    func stylizeOutlets() {
        collectionView.layer.borderWidth = 1;collectionView.layer.borderColor = UIColor(red: 217/255, green: 217/255, blue: 219/255, alpha: 1.0).CGColor; getDirectionsLabel.layer.borderWidth = 1
        getDirectionsLabel.layer.borderColor = UIColor(red: 217/255, green: 217/255, blue: 219/255, alpha: 1.0).CGColor; reviewCollectionView.layer.borderWidth = 1
        reviewCollectionView.layer.borderColor = UIColor(red: 217/255, green: 217/255, blue: 219/255, alpha: 1.0).CGColor; mapView.layer.borderWidth = 1; mapView.layer.borderColor = UIColor(red: 217/255, green: 217/255, blue: 219/255, alpha: 1.0).CGColor; self.viewAllPortfolio.enabled = false; self.viewAllPortfolio.alpha = 0.3; self.viewAllReview.enabled = false; self.viewAllReview.alpha = 0.3; reviewButtonOutlet.layer.borderWidth = 1;reviewButtonOutlet.layer.borderColor = UIColor(red: 217/255, green: 217/255, blue: 219/255, alpha: 1.0).CGColor
    }
    
    func loadPortfolioData() {

        self.portfolioCountLabel.text = "0 Photos"
        self.portfolioCountLabel.text = "0"
        
        let keyConv = selectedDict["uid"] as! String
        
        let portRef = FIRDatabase.database().reference().child("po").child(keyConv).queryOrderedByChild("da")
        portRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in
            
            var portArray = [NSMutableDictionary]()
            
            for item in snapshot.children {
                
                var portItem = NSMutableDictionary()
                
                if let gendo = item.value["ge"] {
                    portItem.setValuesForKeysWithDictionary(["ge":gendo])
                } else {
                    portItem.setValuesForKeysWithDictionary(["ge":""])
                }
                if let captiono = item.value["te"] {
                    portItem.setValuesForKeysWithDictionary(["te":captiono])
                } else {
                    portItem.setValuesForKeysWithDictionary(["te":""])
                }
                if let urlLargo = item.value["ul"] {
                    portItem.setValuesForKeysWithDictionary(["ul":urlLargo])
                } else {
                    portItem.setValuesForKeysWithDictionary(["ul":""])
                }
                if let urlpetite = item.value["us"] {
                    portItem.setValuesForKeysWithDictionary(["us":urlpetite])
                } else {
                    portItem.setValuesForKeysWithDictionary(["us":""])
                }
                
                if let dateo = item.value["da"] {
                    portItem.setValuesForKeysWithDictionary(["da":dateo])
                } else {
                    portItem.setValuesForKeysWithDictionary(["da":""])
                }
                
                let fno = self.selectedDict["fn"] as! String
                let lno = self.selectedDict["ln"] as! String
                portItem.setValuesForKeysWithDictionary(["fn":"\(fno) \(lno)"])

                
                portArray.append(portItem)
            }
            self.portDict = portArray
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                if self.portDict.count == 0 {
                    
                } else {
                    self.collectionView.reloadData()
                    self.loadingPortfolioLabel.hidden = true
                    self.viewAllPortfolio.enabled = true
                    self.viewAllPortfolio.alpha = 1.0
                    self.portfolioCountLabel.text = "\(self.portDict.count)"
                    UIView.animateWithDuration(0.25) {
                        self.view.layoutIfNeeded()
                    }
                }
                
                portRef.removeAllObservers()
                
            })

            
        })
        
        let revRef = FIRDatabase.database().reference().child("re").child(keyConv).queryOrderedByChild("da")
        revRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in
            
            var revArray = [NSMutableDictionary]()
            
            for item in snapshot.children {
                
                var revItem = NSMutableDictionary()
                
                if let captiono = item.value["te"] {
                    revItem.setValuesForKeysWithDictionary(["te":captiono])
                } else {
                    revItem.setValuesForKeysWithDictionary(["te":""])
                }
                
                if let urlLargo = item.value["ul"] {
                    revItem.setValuesForKeysWithDictionary(["ul":urlLargo])
                } else {
                    revItem.setValuesForKeysWithDictionary(["ul":""])
                }
                if let urlpetite = item.value["us"] {
                    revItem.setValuesForKeysWithDictionary(["us":urlpetite])
                } else {
                    revItem.setValuesForKeysWithDictionary(["us":""])
                }
                
                if let nameo = item.value["fn"] {
                    revItem.setValuesForKeysWithDictionary(["fn":nameo])
                } else {
                    revItem.setValuesForKeysWithDictionary(["fn":""])
                }
                if let dateo = item.value["da"] {
                    revItem.setValuesForKeysWithDictionary(["da":dateo])
                } else {
                    revItem.setValuesForKeysWithDictionary(["da":""])
                }
                if let ratingo = item.value["ra"] {
                    revItem.setValuesForKeysWithDictionary(["ra":ratingo])
                } else {
                    revItem.setValuesForKeysWithDictionary(["ra":""])
                }
                
                let fno = self.selectedDict["fn"] as! String
                let lno = self.selectedDict["ln"] as! String
                revItem.setValuesForKeysWithDictionary(["fn":"\(fno) \(lno)"])
                
                revArray.append(revItem)
            }
            self.revDict = revArray
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                if self.revDict.count == 0 {
                    
                } else {
                    self.reviewCollectionView.reloadData()
                    self.loadingReviewLabel.hidden = true
                    
                    self.viewAllReview.enabled = true
                    self.viewAllReview.alpha = 1.0
                    
                    self.reviewCountLabel.text = "\(self.revDict.count)"
                    
                    UIView.animateWithDuration(0.25) {
                        self.view.layoutIfNeeded()
                    }

                }
                
                revRef.removeAllObservers()
                
            })
        })

    }
    
    override func viewDidAppear(animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == reviewCollectionView {
            return revDict.count
        } else {
        return portDict.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if collectionView == reviewCollectionView {
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("stylistReviewCollectionCell", forIndexPath: indexPath) as! stylistReviewCollectionViewCell
            
            if let imagee = self.revDict[indexPath.row].objectForKey("us") {
                cell.cellImage.kf_setImageWithURL(NSURL(string: imagee as! String)!, placeholderImage: nil)
            } else {
            }
            
            if let num = revDict[indexPath.row].objectForKey("ra") {
                cell.ratingView.rating = Float(num as! NSNumber)
            } else {
                
            }
            
            return cell
            
        } else {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("stylistProfileCollectionCell", forIndexPath: indexPath) as! stylistProfileCollectionViewCell
            
            if let imagee = self.portDict[indexPath.row].objectForKey("us") {
                cell.cellImage.kf_setImageWithURL(NSURL(string: imagee as! String)!, placeholderImage: nil)
            } else {
            }
            
        return cell
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("reviewStylistCell", forIndexPath: indexPath) as! reviewStylistTableViewCell
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        actionShowLoader()
        
        if collectionView == reviewCollectionView {
            
            let imageo = UIImageView()
            
            selectedImg = revDict[indexPath.row]
            
            let lgImg = self.revDict[indexPath.row].objectForKey("ul") as! String
            
            imageo.kf_setImageWithURL(NSURL(string: lgImg)!,
                                      placeholderImage: nil,
                                      optionsInfo: nil,
                                      progressBlock: { (receivedSize, totalSize) -> () in
                                        print("Download Progress: \(receivedSize)/\(totalSize)")
                                        
                },
                                      completionHandler: { (image, error, cacheType, imageURL) -> () in
                                        print("Downloaded and set!")
                                        
                                        if error == nil {
                                        
                                        let imageInfo   = GSImageInfo(image: imageo.image!, imageMode: .AspectFit)
                                        let imageViewer = GSImageViewerController(imageInfo: imageInfo)
                                        imageViewer.hidesBottomBarWhenPushed = true
                                        SwiftLoader.hide()
                                        //self.presentViewController(imageViewer, animated: true, completion: nil)
                                        self.showViewController(imageViewer, sender: self)
                                            
                                        } else {
                                            SwiftLoader.hide()
                                            
                                            SCLAlertView().showError("Unable to Load", subTitle:"Either photo has been deleted or no internet connection.", closeButtonTitle:"OK")
                                        }
                }
            )

        } else {
            
            let imageo = UIImageView()
            
            selectedImg = portDict[indexPath.row]
            
            let lgImg = self.portDict[indexPath.row].objectForKey("ul") as! String
            
            imageo.kf_setImageWithURL(NSURL(string: lgImg)!,
                                      placeholderImage: nil,
                                      optionsInfo: nil,
                                      progressBlock: { (receivedSize, totalSize) -> () in
                                        print("Download Progress: \(receivedSize)/\(totalSize)")
                                        
                },
                                      completionHandler: { (image, error, cacheType, imageURL) -> () in
                                        print("Downloaded and set!")
                                        
                                        if error == nil {
                                        
                                        let imageInfo   = GSImageInfo(image: imageo.image!, imageMode: .AspectFit)
                                        let imageViewer = GSImageViewerController(imageInfo: imageInfo)
                                        imageViewer.hidesBottomBarWhenPushed = true
                                        SwiftLoader.hide()
                                        self.showViewController(imageViewer, sender: self)
                                            
                                        } else {
                                            SwiftLoader.hide()
                                            
                                            SCLAlertView().showError("Unable to Load", subTitle:"Either photo has been deleted or no internet connection.", closeButtonTitle:"OK")
                                        }
                }
            )

        
            }
        
    }
    

    @IBAction func seeReviewsAction(sender: AnyObject) {
        
        self.performSegueWithIdentifier("profileToReviewsSegue", sender: self)
        
    }
    
    @IBAction func servicesTapped(sender: AnyObject) {
        
        self.performSegueWithIdentifier("profileToServices", sender: self)
        
    }
    
    @IBAction func writeReviewTapped(sender: AnyObject) {
 
 
        if FIRAuth.auth()?.currentUser != nil {
            
            if (selectedDict["uid"] as! String) != FIRAuth.auth()?.currentUser?.uid {
            
        self.performSegueWithIdentifier("profileToWriteReview", sender: self)
                
            } else {
                let appearance = SCLAlertView.SCLAppearance(
                    showCloseButton: false,
                    kTitleTop: 30
                )

                
                let alert = SCLAlertView(appearance: appearance)
                alert.showCustom("Hold On...", subTitle: "You can't review yourself!", color: UIColor(red: 128/255, green: 0/255, blue: 0/255, alpha: 1.0), icon: UIImage(named: "exclamation.png")!, duration: 2.5, animationStyle: SCLAnimationStyle.NoAnimation)
                
            }
        
        } else {
            let alert = SCLAlertView()
            alert.addButton("Sign In Now") {
                
                self.tabBarController?.selectedIndex = 3
                
                
            }
            
            let icon = UIImage(named:"exclamation.png")
            
            alert.showCustom("Hold On...", subTitle: "To review, you need to sign up or log in first.", color: UIColor(red: 128 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 1.0), icon: (icon)!)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if(segue.identifier == "portfolioCollectionSegueFromSearch"){
            let detailScene = segue.destinationViewController as! portfolioCollectionViewController
            detailScene.portDict = (portDict)

        }
        
        if(segue.identifier == "profileToReviewsSegue"){
            let detailScene = segue.destinationViewController as! normalUserReviewViewController
            
            detailScene.revDict = self.revDict
            
        }
        
        if(segue.identifier == "profileToServices"){
            let detailScene = segue.destinationViewController as! servicePriceViewController
            detailScene.selectedKey = self.selectedDict["uid"] as! String
            
        }
        if(segue.identifier == "profileToWriteReview"){
            let detailScene = segue.destinationViewController as! reviewStylistViewController
            //detailScene.selectedKey = (self.selectedKey)
            detailScene.selectedDict = (self.selectedDict)
            
        }


    }
    
    var isLiked:Bool = false
    
    @IBAction func likeStarTapped(sender: AnyObject) {
        
        if FIRAuth.auth()?.currentUser != nil {
            
            if selectedDict["uid"] as! String != myDict["uid"] as! String {
            
            if isLiked == false {
                isLiked = true
                self.likeStar.setImage(UIImage(named: "staryellow.png"), forState: UIControlState.Normal)
            
                let appearance = SCLAlertView.SCLAppearance(
                    showCloseButton: false,
                    kTitleTop: 40
                )
            
                let alert = SCLAlertView(appearance: appearance)
            
                alert.showCustom("Followed", subTitle: "", color: UIColor(red: 150/255, green: 150/255, blue: 0/255, alpha: 1.0), icon: UIImage(named: "star.png")!, duration: 0.85, animationStyle: SCLAnimationStyle.NoAnimation)
            
                queryRef.child("fd").child(self.selectedDict["uid"] as! String).child((FIRAuth.auth()?.currentUser?.uid)!).setValue(myDict)
            
                queryRef.child("fg").child((FIRAuth.auth()?.currentUser?.uid)!).child(self.selectedDict["uid"] as! String).setValue(selectedDict)
                
                //
                
                if followArray.contains(self.selectedDict["uid"] as! String) {
                    
                } else {
                    
                    myFollowing.append(selectedDict)
                    followArray.append(self.selectedDict["uid"] as! String)
                    
                }

                print(myFollowing)
                print(followArray)
                
                
            } else {
            
                isLiked = false
            
                self.likeStar.setImage(UIImage(named: "star.png"), forState: UIControlState.Normal)
            
                let appearance = SCLAlertView.SCLAppearance(
                    showCloseButton: false,
                    kTitleTop: 40
                )
            
                let alert = SCLAlertView(appearance: appearance)
                alert.showCustom("Unfollowed", subTitle: "", color: UIColor.lightGrayColor(), icon: UIImage(named: "star.png")!, duration: 0.85, animationStyle: SCLAnimationStyle.NoAnimation)
            
                queryRef.child("fd").child(self.selectedDict["uid"] as! String).child((FIRAuth.auth()?.currentUser?.uid)!).removeValue()
                queryRef.child("fg").child((FIRAuth.auth()?.currentUser?.uid)!).child(self.selectedDict["uid"] as! String).removeValue()
                
                
                //
                
                
                if followArray.contains(self.selectedDict["uid"] as! String) {
                    let numero = followArray.indexOf(self.selectedDict["uid"] as! String)
                    followArray.removeAtIndex(numero!)
                    myFollowing.removeAtIndex(numero!)
                    
                } else {
                    
                }
                
                print(myFollowing)
                print(followArray)

            
            }
            } else {
                
                let appearance = SCLAlertView.SCLAppearance(
                    showCloseButton: false,
                    kTitleTop: 30
                )
                let alert = SCLAlertView(appearance: appearance)
                alert.showCustom("Hold On...", subTitle: "You can't follow yourself.", color: UIColor(red: 128/255, green: 0/255, blue: 0/255, alpha: 1.0), icon: UIImage(named: "exclamation.png")!, duration: 1.5, animationStyle: SCLAnimationStyle.NoAnimation)

            }
        } else {
            let alert = SCLAlertView()
            alert.addButton("Sign In Now") {
                self.tabBarController?.selectedIndex = 3
            }
            
            let icon = UIImage(named:"exclamation.png")
            
            alert.showCustom("Hold On...", subTitle: "You need to sign up or log in first.", color: UIColor(red: 128 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 1.0), icon: (icon)!)
        }
        
    }
    
    
    

}
