//
//  combinedActivityViewController.swift
//  Hair CV
//
//  Created by Ivan Khau on 5/12/16.
//  Copyright © 2016 Peer Goggles. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class combinedActivityViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var activityBottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var genderSegment: UISegmentedControl!
    
    @IBAction func segmentTapped(sender: AnyObject) {
        
        self.activityCollectionView.reloadData()
        
    }
    
    var allDict = [NSMutableDictionary]()
    var womenDict = [NSMutableDictionary]()
    var menDict = [NSMutableDictionary]()
    
    let pulseView = WAActivityIndicatorView(frame: CGRect(x: phonewidth/2 - 25, y: phoneheight/2 - 25 - 60, width: 50, height: 50),
                                            indicatorType: ActivityIndicatorType.ThreeDotsScale,
                                            tintColor: UIColor.blackColor(),
                                            indicatorSize: 50)

    //var loadingLabel = UILabel(frame: CGRectMake(phonewidth/2 - 50, phoneheight/2 - 100, 100, 45))
    
    
    @IBOutlet weak var activityCollectionView: UICollectionView!
    
    
    
    
    
    var canRefresh:Bool = true
    
    var refresher: UIRefreshControl!
    
    func refresh() {
        
        
        if self.canRefresh == true {
            
            print("can refresh and is refreshing")
            
            queryActivity()
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
    
    func resetRefresho() {
        
        self.canRefresh = true
        print("CAN REFRESH")
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSTimer.scheduledTimerWithTimeInterval(25.0, target: self, selector: #selector(combinedActivityViewController.resetRefresho), userInfo: nil, repeats: true)
        
        // OEM REFRESHER
        self.refresher = UIRefreshControl()
        self.refresher.addTarget(self, action: #selector(combinedActivityViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
        self.activityCollectionView.addSubview(self.refresher)
        
        //self.activityCollectionView.hidden = true
        
        let triggerTime = (Int64(NSEC_PER_SEC) * 6)
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
            self.view.userInteractionEnabled = true
            self.pulseView.stopAnimating()
            self.pulseView.removeFromSuperview()
            self.activityCollectionView.hidden = false
            
        })

        //formatLoadingLabel()
        
        queryActivity()
        
    }
    
    override func viewDidAppear(animated: Bool) {

        setPushID()
        
    }
    
    /*func formatLoadingLabel() {
        loadingLabel.textAlignment = NSTextAlignment.Center
        loadingLabel.text = ""
        loadingLabel.layer.backgroundColor = UIColor.blackColor().CGColor
        loadingLabel.textColor = UIColor.whiteColor()
        loadingLabel.alpha = 0.8
    }*/
    
    func queryActivity() {
        
        view.addSubview(pulseView)
        self.view.userInteractionEnabled = false
        pulseView.startAnimating()
    
        allDict.removeAll()
        womenDict.removeAll()
        menDict.removeAll()
        self.activityCollectionView.reloadData()

        let actRef = database.reference().child("ac").queryLimitedToLast(200)
        actRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in

            var newItems = [NSMutableDictionary]()
            var newItemsFemale = [NSMutableDictionary]()
            var newItemsMale = [NSMutableDictionary]()
            
            for item in snapshot.children {
                let actDict = NSMutableDictionary()
                if let urlSmall = item.value!["us"] {
                    actDict.setValuesForKeysWithDictionary(["us":urlSmall])
                } else {
                    actDict.setValuesForKeysWithDictionary(["us":""])
                }
                
                if let urlLarge = item.value!["ul"] {
                    actDict.setValuesForKeysWithDictionary(["ul":urlLarge])
                } else {
                    actDict.setValuesForKeysWithDictionary(["ul":""])
                }
                
                if let gender = item.value!["ge"] {
                    actDict.setValuesForKeysWithDictionary(["ge":gender])
                } else {
                    actDict.setValuesForKeysWithDictionary(["ge":""])
                }
                
                if let texto = item.value!["te"] {
                    actDict.setValuesForKeysWithDictionary(["te":texto])
                } else {
                    actDict.setValuesForKeysWithDictionary(["te":""])
                }
                if let dateo = item.value!["da"] {
                    actDict.setValuesForKeysWithDictionary(["da":dateo])
                } else {
                    actDict.setValuesForKeysWithDictionary(["da":""])
                }
                
                if let nameo = item.value!["fn"] {
                    actDict.setValuesForKeysWithDictionary(["fn":nameo])
                } else {
                    actDict.setValuesForKeysWithDictionary(["fn":""])
                }
                
                if let ideo = item.value!["na"] {
                    actDict.setValuesForKeysWithDictionary(["na":ideo])

                } else {
                    actDict.setValuesForKeysWithDictionary(["na":""])

                }
                

                newItems.append(actDict)
                
                if actDict["ge"] as! String == "f" {
                    newItemsFemale.append(actDict)
                } else if actDict["ge"] as! String == "m" {
                    newItemsMale.append(actDict)
                }
            }
            
            self.allDict = newItems.reverse()
            self.womenDict = newItemsFemale.reverse()
            self.menDict = newItemsMale.reverse()
            
            
            self.activityCollectionView.reloadData()
            self.pulseView.stopAnimating()
            self.pulseView.removeFromSuperview()
            self.view.userInteractionEnabled = true
            self.activityCollectionView.hidden = false
            
        })
        
    }
    
    func formatTitle() {
        let titleLabel = UILabel()
        titleLabel.frame.size.height = 40
        titleLabel.frame.size.width = 120
        titleLabel.font = UIFont(name: "Georgia-Italic", size: 20)
        titleLabel.textColor = UIColor.darkTextColor()
        titleLabel.textAlignment = .Center
        titleLabel.text = "Activity"
        self.navigationItem.titleView = titleLabel

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if genderSegment.selectedSegmentIndex == 0 {
            
            return self.allDict.count
            
        } else if genderSegment.selectedSegmentIndex == 1 {

            return self.womenDict.count
        } else {
            return self.menDict.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
            
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("activityCell", forIndexPath: indexPath) as! activityCollectionViewCell
        
        //cell.activityImage = nil
        
        var tempString = ""
        if genderSegment.selectedSegmentIndex == 0 {
            //tempString = self.allDict[indexPath.row]["us"] as! String
            tempString = self.allDict[indexPath.row].valueForKey("us") as! String

            
        } else if genderSegment.selectedSegmentIndex == 1 {
            tempString = self.womenDict[indexPath.row]["us"] as! String
        } else if genderSegment.selectedSegmentIndex == 2 {
            tempString = self.menDict[indexPath.row]["us"] as! String
        }
        
        cell.activityImage.kf_setImageWithURL(NSURL(string: tempString)!, placeholderImage: nil)

        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let collectionViewSize = activityCollectionView.frame.size.width/3 - 1
            
        return CGSize(width: collectionViewSize, height: collectionViewSize)
        
    }
    
    var loadee = UILabel()

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
            
            //loadingLabel.text = "0%"
            //self.view.addSubview(loadingLabel)
            //self.view.bringSubviewToFront(loadingLabel)
            
            //self.view.userInteractionEnabled = false
        
        actionShowLoader()
        
        if genderSegment.selectedSegmentIndex == 0 {
            
            selectedImg = allDict[indexPath.row]
            
        } else if genderSegment.selectedSegmentIndex == 1 {
            
            selectedImg = womenDict[indexPath.row]
            
        } else if genderSegment.selectedSegmentIndex == 2 {
            
            selectedImg = menDict[indexPath.row]
            
        }
        
            let imageo = UIImageView()
            imageo.kf_setImageWithURL(NSURL(string: selectedImg["ul"] as! String)!,
                                         placeholderImage: nil,
                                         optionsInfo: nil,
                                         progressBlock: { (receivedSize, totalSize) -> () in
                                            print("Download Progress: \(receivedSize)/\(totalSize)")
                                            
                                            //let receivedub = Double(receivedSize)
                                            //let totaldub = Double(totalSize)
                                            //let divide = (receivedub/totaldub) * 100
                                            //let rounded = round(divide)
                                            
                                            //self.loadingLabel.text = "\(rounded)%"
                                            
                },
                                         completionHandler: { (image, error, cacheType, imageURL) -> () in
                                            print("Downloaded and set!")
                                            //self.loadingLabel.removeFromSuperview()
                                            //self.view.userInteractionEnabled = true

                                            if error == nil {
                                                
                                            let imageInfo   = GSImageInfo(image: imageo.image!, imageMode: .AspectFit)
                                            let imageViewer = GSImageViewerController(imageInfo: imageInfo)
                                            imageViewer.hidesBottomBarWhenPushed = true
                                                                                            
                                            SwiftLoader.hide()
                                                
                                            self.showViewController(imageViewer, sender: self)
                                            //self.presentViewController(imageViewer, animated: true, completion: nil)
                                            
                                            } else {
                                                
                                                SwiftLoader.hide()
                                                
                                                SCLAlertView().showError("Unable to Load", subTitle:"Either photo has been deleted or no internet connection.", closeButtonTitle:"OK")
                                                
                                            }
                }
            )

    }
    
    
    @IBAction func gotoLiked(sender: AnyObject) {
        
        let ref = NSUserDefaults.standardUserDefaults().objectForKey("likedImages")
        if ref == nil {
            SCLAlertView().showNotice("Hold On...", subTitle: "You need to like a photo first")
        } else {
            self.performSegueWithIdentifier("activityToLiked", sender: self)
        }
        
        
    }

}
