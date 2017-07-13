//
//  normalUserReviewViewController.swift
//  Barber CV
//
//  Created by Ivan Khau on 7/25/16.
//  Copyright © 2016 Peer Goggles. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class normalUserReviewViewController: UIViewController {
    
    
    @IBOutlet weak var trashButton: UIBarButtonItem!
    var revDict = [NSMutableDictionary]()
    //var loadingLabel = UILabel(frame: CGRectMake(phonewidth/2 - 50, phoneheight/2 - 85, 100, 45))
    
    
    var seeingOwnReviews:Bool = false
    

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatTitle()
        //formatLoadingLabel()
        queryReviews()
        
        if seeingOwnReviews != true {
            trashButton.enabled = false
            trashButton.tintColor = UIColor.clearColor()
        }
        
    }
    
    func queryReviews() {
        if seeingOwnReviews == true {
            
            self.revDict.removeAll()
            
            let queryRef = FIRDatabase.database().reference().child("ur").child((FIRAuth.auth()?.currentUser!.uid)!)
            queryRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in
                
                var tempRevArray = [NSMutableDictionary]()
                for item in snapshot.children {
                    
                    let revObject = NSMutableDictionary()
                    
                    if let dateo = item.value!["da"] {
                        revObject.setValuesForKeysWithDictionary(["da":dateo])
                        } else {
                        revObject.setValuesForKeysWithDictionary(["da":""])
                    }
                    if let nameo = item.value!["fn"] {
                        revObject.setValuesForKeysWithDictionary(["fn":nameo])
                    } else {
                        revObject.setValuesForKeysWithDictionary(["fn":""])
                    }
                    if let ido = item.value!["id"] {
                        revObject.setValuesForKeysWithDictionary(["id":ido])
                    } else {
                        revObject.setValuesForKeysWithDictionary(["id":""])
                    }
                    if let nao = item.value!["na"] {
                        revObject.setValuesForKeysWithDictionary(["na":nao])
                    } else {
                        revObject.setValuesForKeysWithDictionary(["na":""])
                    }
                    if let nameLarge = item.value!["nl"] {
                        revObject.setValuesForKeysWithDictionary(["nl":nameLarge])
                    } else {
                        revObject.setValuesForKeysWithDictionary(["nl":""])
                    }
                    if let nameSmall = item.value!["ns"] {
                        revObject.setValuesForKeysWithDictionary(["ns":nameSmall])
                    } else {
                        revObject.setValuesForKeysWithDictionary(["ns":""])
                    }
                    if let ratingo = item.value!["ra"] {
                        revObject.setValuesForKeysWithDictionary(["ra":ratingo])
                    } else {
                        revObject.setValuesForKeysWithDictionary(["ra":""])
                    }
                    if let referenceo = item.value!["rf"] {
                        revObject.setValuesForKeysWithDictionary(["rf":referenceo])
                    } else {
                        revObject.setValuesForKeysWithDictionary(["rf":""])
                    }
                    if let texto = item.value!["te"] {
                        revObject.setValuesForKeysWithDictionary(["te":texto])
                    } else {
                        revObject.setValuesForKeysWithDictionary(["te":""])
                    }
                    if let urlsmall = item.value!["us"] {
                        revObject.setValuesForKeysWithDictionary(["us":urlsmall])
                    } else {
                        revObject.setValuesForKeysWithDictionary(["us":""])
                    }

                    if let urllarge = item.value!["ul"] {
                        revObject.setValuesForKeysWithDictionary(["ul":urllarge])
                    } else {
                        revObject.setValuesForKeysWithDictionary(["ul":""])
                    }
                    
                    tempRevArray.append(revObject)

                }
                
                self.revDict = tempRevArray
                
                self.tableView.reloadData()
            
            })
        } else {
            self.tableView.reloadData()
        }
        
        
    }
    
    func formatTitle() {
        let titleLabel = UILabel()
        titleLabel.frame.size.height = 40
        titleLabel.frame.size.width = 120
        titleLabel.font = UIFont(name: "Georgia-Italic", size: 22)
        titleLabel.textColor = UIColor.darkTextColor()
        titleLabel.textAlignment = .Center
        if seeingOwnReviews == true {
        titleLabel.text = "My Reviews"
        } else {
            titleLabel.text = "Reviews"
        }
        self.navigationItem.titleView = titleLabel
    }
    
    /*func formatLoadingLabel() {
        loadingLabel.textAlignment = NSTextAlignment.Center
        loadingLabel.text = ""
        loadingLabel.layer.backgroundColor = UIColor.blackColor().CGColor
        loadingLabel.textColor = UIColor.whiteColor()
        loadingLabel.alpha = 0.8
    }*/


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return revDict.count
        
    }

    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ownUserReviewCell", forIndexPath: indexPath) as! normalUserReviewTableViewCell
        
        if trashToggled == false {
            cell.deleteCircle.hidden = true
            cell.layer.backgroundColor = UIColor.whiteColor().CGColor
        } else {
            cell.deleteCircle.hidden = false
            
            cell.layer.backgroundColor = UIColor(red: 255/255, green: 0, blue: 0, alpha: 0.1).CGColor
            
        }
        
        
        if let imgo = revDict[indexPath.row]["us"] {
            cell.picture.kf_setImageWithURL(NSURL(string: imgo as! String)!, placeholderImage: nil)        }
        
        if let nameo = revDict[indexPath.row]["fn"] {
            cell.name.text = nameo as! String
        }
        
        
        if let capto = revDict[indexPath.row]["te"] {
            cell.caption.text = capto as! String
        }
        
        
        if let numero = revDict[indexPath.row]["ra"] {
            
            cell.rating.rating = numero as! Float
            
        }
        

        return cell
        
    }
    
    var trashToggled:Bool = false
    
    @IBAction func toggleTrash(sender: AnyObject) {
        
        if trashToggled == false {
            trashToggled = true
        } else {
            trashToggled = false
        }
        
        self.tableView.reloadData()
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        
        if trashToggled == false {
            print("show image")
            
            //loadingLabel.text = "0%"
            //self.view.addSubview(loadingLabel)
            //self.view.bringSubviewToFront(loadingLabel)
            
            //self.view.userInteractionEnabled = false
            
            actionShowLoader()
            
            selectedImg = revDict[indexPath.row]
            
            let imageo = UIImageView()
            imageo.kf_setImageWithURL(NSURL(string: selectedImg["ul"] as! String)!,
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
                                            self.presentViewController(imageViewer, animated: true, completion: nil)
                                            
                                        } else {
                                            SwiftLoader.hide()
                                            SCLAlertView().showError("No Internet Connection", subTitle:"Try again later.", closeButtonTitle:"OK")
                                            
                                        }
                }
            )

            
        } else {
            print("delete alert")
            
            let alert = SCLAlertView()
            alert.addButton("Yes, Delete This Review") {
                
                queryRef.child("ur").child((FIRAuth.auth()?.currentUser!.uid)!).child(self.revDict[indexPath.row]["na"] as! String).removeValue()
                
                queryRef.child("re").child(self.revDict[indexPath.row]["na"] as! String).child((FIRAuth.auth()?.currentUser!.uid)!).removeValue()
                
                queryRef.child("ra").child(self.revDict[indexPath.row]["rf"] as! String).removeValue()
                
                self.trashToggled = false
                self.revDict.removeAtIndex(indexPath.row)
                self.tableView.reloadData()
                
            }
            
            let icon = UIImage(named:"exclamation.png")
            
            alert.showCustom("Delete?", subTitle: "Are you sure you want to delete this review?", color: UIColor(red: 128 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 1.0), icon: (icon)!)
            
            
        }
        

    }

}
