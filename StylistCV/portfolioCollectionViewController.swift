//
//  portfolioCollectionViewController.swift
//  Hair CV
//
//  Created by Ivan Khau on 4/9/16.
//  Copyright © 2016 Peer Goggles. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class portfolioCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var segmentedControll: UISegmentedControl!
    var fromOwnProfile:Bool = false
    
    @IBAction func segmentedTapped(sender: AnyObject) {
        self.collectionView.reloadData()
    }
    @IBOutlet weak var trash: UIBarButtonItem!
    @IBOutlet weak var closeOutlet: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func closeAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) {
        }
    }
    
    var portDict = [NSMutableDictionary]()
    //var loadingLabel = UILabel(frame: CGRectMake(phonewidth/2 - 50, phoneheight/2 - 90, 100, 45))
    
    var womenArray = [NSMutableDictionary]()
    var menArray = [NSMutableDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if fromOwnProfile == false {
            trash.enabled = false
            trash.tintColor = UIColor.clearColor()
            
            for obj in portDict {
                if obj["ge"] as! String == "f" {
                    self.womenArray.append(obj)
                } else {
                    self.menArray.append(obj)
                }
            }


        } else {

            //formatTitle()
            self.segmentedControll.hidden = true
            self.segmentedControll.enabled = false
            
            
            

        }
        
        //formatLoadingLabel()
        self.collectionView.reloadData()
        
    }
    
    func formatTitle() {
        let titleLabel = UILabel()
        titleLabel.frame.size.height = 40
        titleLabel.frame.size.width = 120
        titleLabel.font = UIFont(name: "Georgia-Italic", size: 22)
        titleLabel.textColor = UIColor.darkTextColor()
        titleLabel.textAlignment = .Center
        titleLabel.text = "Portfolio"
        self.navigationItem.titleView = titleLabel
        
    }

    
    /*func formatLoadingLabel() {
        loadingLabel.textAlignment = NSTextAlignment.Center
        loadingLabel.text = ""
        loadingLabel.layer.backgroundColor = UIColor.blackColor().CGColor
        loadingLabel.textColor = UIColor.whiteColor()
        loadingLabel.alpha = 0.8
    }*/

    
    override func viewDidAppear(animated: Bool) {
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if segmentedControll.selectedSegmentIndex == 0 {
        return portDict.count
        } else if segmentedControll.selectedSegmentIndex == 1 {
           return womenArray.count
        } else {
            return menArray.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("portfolioCollectionCell", forIndexPath: indexPath) as! portfolioCollectionViewCell
        
        
        if trashToggled == false {
            cell.delete.hidden = true
            
            cell.layer.borderColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.1).CGColor
            cell.layer.borderWidth = 0
            
        } else {
            cell.delete.hidden = false
            cell.layer.borderColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.1).CGColor
            cell.layer.borderWidth = 300
        }
        
        if segmentedControll.selectedSegmentIndex == 0 {
        
        cell.cellImage.kf_setImageWithURL(NSURL(string: portDict[indexPath.row]["us"] as! String)!, placeholderImage: nil)
        } else if segmentedControll.selectedSegmentIndex == 1 {
            cell.cellImage.kf_setImageWithURL(NSURL(string: womenArray[indexPath.row]["us"] as! String)!, placeholderImage: nil)
        } else {
            cell.cellImage.kf_setImageWithURL(NSURL(string: menArray[indexPath.row]["us"] as! String)!, placeholderImage: nil)
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if trashToggled == false {
        //loadingLabel.text = "0%"
        //self.view.addSubview(loadingLabel)
        //self.view.bringSubviewToFront(loadingLabel)
            
        actionShowLoader()
        self.view.userInteractionEnabled = false
        let imageo = UIImageView()
            
            var imgo = String()
            if segmentedControll.selectedSegmentIndex == 0 {
                
                imgo = portDict[indexPath.row]["ul"] as! String
                selectedImg = portDict[indexPath.row]

            } else if segmentedControll.selectedSegmentIndex == 1 {
                imgo = womenArray[indexPath.row]["ul"] as! String
                selectedImg = womenArray[indexPath.row]


            } else {
                imgo = menArray[indexPath.row]["ul"] as! String
                selectedImg = menArray[indexPath.row]


            }
            
            
        imageo.kf_setImageWithURL(NSURL(string: imgo)!,
                                  placeholderImage: nil,
                                  optionsInfo: nil,
                                  progressBlock: { (receivedSize, totalSize) -> () in
                                    print("Download Progress: \(receivedSize)/\(totalSize)")
                                    
                                    /*let receivedub = Double(receivedSize)
                                    let totaldub = Double(totalSize)
                                    let divide = (receivedub/totaldub) * 100
                                    let rounded = round(divide)*/
                                    
                                    //self.loadingLabel.text = "\(rounded)%"
                                    
            },
                                  completionHandler: { (image, error, cacheType, imageURL) -> () in
                                    print("Downloaded and set!")
                                    //self.loadingLabel.removeFromSuperview()
                                    self.view.userInteractionEnabled = true
                                    
                                    if error == nil {
                                        
                                        let imageInfo   = GSImageInfo(image: imageo.image!, imageMode: .AspectFit)
                                        let imageViewer = GSImageViewerController(imageInfo: imageInfo)
                                        imageViewer.hidesBottomBarWhenPushed = true
                                        SwiftLoader.hide()
                                        
                                        
                                        self.showViewController(imageViewer, sender: self)
                                    } else {
                                        SwiftLoader.hide()
                                        SCLAlertView().showError("No Internet Connection", subTitle:"Try again later.", closeButtonTitle:"OK")
                                        
                                    }
            })
        } else {
            print("delete alert")
            
            let alert = SCLAlertView()
            alert.addButton("Yes, Delete This Photo") {
                
                let ref = NSUserDefaults.standardUserDefaults()
                var arrayo = [NSString]()
                if ref.objectForKey("likedImages") != nil {
                    arrayo = ref.objectForKey("likedImages") as! [NSString]
                    if arrayo.contains(self.portDict[indexPath.row]["ul"] as! NSString) {
                        arrayo = arrayo.filter{$0 != (self.portDict[indexPath.row]["ul"] as! NSString)}
                        ref.setObject(arrayo, forKey: "likedImages")
                    } else {
                        arrayo.append(self.portDict[indexPath.row]["ul"] as! NSString)
                        ref.setObject(arrayo, forKey: "likedImages")
                    }
                } else {
                    arrayo.append(self.portDict[indexPath.row]["ul"] as! NSString)
                    ref.setObject(arrayo, forKey: "likedImages")
                }

                
                queryRef.child("po").child((FIRAuth.auth()?.currentUser?.uid)!).child(self.portDict[indexPath.row]["ns"] as! String).removeValue()
                
                queryRef.child("ac").child(self.portDict[indexPath.row]["ar"] as! String).removeValue()
                
                storage.reference().child("pp").child(self.portDict[indexPath.row]["nl"] as! String).deleteWithCompletion({ (error) in
                    
                })
                
                let smallName = "\(self.portDict[indexPath.row]["ns"] as! String).jpeg"
                
                storage.reference().child("pp").child(smallName).deleteWithCompletion({ (error) in
                    
                })

                self.portDict.removeAtIndex(indexPath.row)
                self.trashToggled = false
                self.collectionView.reloadData()
                
                
                
                addedToPortfolio = true
                
            }
            
            let icon = UIImage(named:"exclamation.png")
            
            alert.showCustom("Delete?", subTitle: "Are you sure you want to delete this photo?", color: UIColor(red: 128 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 1.0), icon: (icon)!)
        }

    
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        
            let collectionViewSize = collectionView.frame.size.width/2 - 3
            
            
            return CGSize(width: collectionViewSize, height: collectionViewSize)
        
        
    }
    
    var trashToggled:Bool = false
    
    @IBAction func trashToggled(sender: AnyObject) {
        
        if trashToggled == false {
            self.trashToggled = true
        } else {
            self.trashToggled = false
        }
        
        self.collectionView.reloadData()
        
    }
    
    

    
}
