//
//  messagesViewController.swift
//  Hair CV
//
//  Created by Ivan Khau on 7/18/16.
//  Copyright © 2016 Peer Goggles. All rights reserved.
//

import UIKit
import Firebase


class messagesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toggleTrash: UIBarButtonItem!
    
    @IBAction func trashTapped(sender: AnyObject) {
        if trashToggled == false {
            trashToggled = true
            self.tableView.reloadData()
        } else {
            trashToggled = false
            self.tableView.reloadData()
        }
    }
    
    let pulseView = WAActivityIndicatorView(frame: CGRect(x: phonewidth/2 - 25, y: phoneheight/2 - 25 - 60, width: 50, height: 50), indicatorType: ActivityIndicatorType.ThreeDotsScale, tintColor: UIColor.blackColor(), indicatorSize: 50)

    var convDict = [NSMutableDictionary]()
    var chatConnected:Bool = false
    var trashToggled:Bool = false
    var snapArray = [FIRDataSnapshot]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatTitle()

    }
    
    
    
    func getChatList() {
        
        if FIRAuth.auth()?.currentUser != nil {
            
            
            /*queryRef.child("ch").child("re").child((FIRAuth.auth()?.currentUser!.uid)!).observeSingleEventOfType(.Value, withBlock: { (isSnapo) in
                
                if isSnapo.
                
                }, withCancelBlock: { (error) in
                    
            })*/
            
            actionShowLoader()
            
            
            let mesRef = queryRef.child("ch").child("re").child((FIRAuth.auth()?.currentUser!.uid)!).queryOrderedByChild("ts")
            
            mesRef.observeEventType(.Value, withBlock: { (snapo) -> Void in

                self.chatConnected = true
                
                var newItems = [FIRDataSnapshot]()
                
                for item in snapo.children {
                    
                    newItems.append(item as! FIRDataSnapshot)
                    
                }
                
                print(self.snapArray)
                self.snapArray = newItems.reverse()
                
                self.tableView.reloadData()
                SwiftLoader.hide()
                
            })
        }
    }
    
    var viewDidAppearAlready:Bool = false
    
    override func viewDidAppear(animated: Bool) {
        
        tabBarController?.tabBar.items?[2].badgeValue = nil
        
        setPushID()
        
        if chatConnected == false {
            getChatList()
        }
        
        newChatAction()
        
    }
    
    func newChatAction() {
        
        if FIRAuth.auth()!.currentUser != nil {
            if chatConnected == true {
                if viewDidAppearAlready == false {
                    viewDidAppearAlready = true
                } else {
                    self.tableView.reloadData()
                }
                
                if dictforchat != nil {
                    
                    actionShowLoader()
                    
                    self.view.addSubview(self.pulseView)
                    //self.pulseView.startAnimating()
                    //self.view.userInteractionEnabled = false
                    
                    let tempDict = dictforchat
                    dictforchat = nil
                    
                    let tempString = tempDict!["uid"] as! String
                    
                    
                    var uidArray = [String]()
                    for obj in snapArray {
                        uidArray.append("\(obj.value!["id"])")
                    }
                    
                    
                    
                    if uidArray.contains(tempString) {
                        //CHAT ALREADY EXISTS!!!!!!
                        for obj in snapArray {
                            
                            let snapToString = "\(obj.value!["id"])"
                            
                            if snapToString == tempString {
                                
                                var pushID = String()
                                if obj.value!["pu"] != nil {
                                    pushID = "\(obj.value!["pu"])"
                                } else {
                                    pushID = ""
                                }
                                
                                selectedUserDict = ["id":"\(obj.value!["id"])","na":"\(obj.value!["na"])","la":"\(obj.value!["la"])","uid":"\(obj.key)","ts":"\(obj.value!["ts"])", "pu":pushID]
                                
                                //self.pulseView.stopAnimating()
                                //self.pulseView.removeFromSuperview()
                                //self.view.userInteractionEnabled = true
                                
                                self.performSegueWithIdentifier("goToMessage", sender: self)
                            }
                        }
                    } else {
                        //CHAT DOES NOT EXIST, CREATE THEN PERFORM SEGUE!!!!!!!
                        
                        //actionShowLoader()
                        //actionShowLoader()
                        
                        let fn = myDict["fn"] as! String
                        let ln = myDict["ln"] as! String
                        //let lnf = ln.characters.first!
                        let fulln = "\(fn) \(ln)"
                        
                        let chRef = queryRef.child("ch")
                        chRef.child("ro").childByAutoId().childByAutoId().setValue(["id":"Stylist CV","me":"\(fulln) started a conversation."]) { (error, createrefo) in
                            
                            // Chat started, need to add chat reference to both users
                            let poopy = createrefo.parent?.key
                            
                            let otherFN = tempDict!["fn"] as! String
                            let otherLN = tempDict!["ln"] as! String
                            let otherFULLN = "\(otherFN) \(otherLN)"
                            
                            let date = NSDate()
                            // : "May 10, 2016, 8:55 PM" - Local Date Time
                            var formatter = NSDateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
                            let defaultTimeZoneStr = formatter.stringFromDate(date)
                            // : "2016-05-10 20:55:06 +0300" - Local (GMT +3)
                            //formatter.timeZone = NSTimeZone(abbreviation: "UTC")
                            //let utcTimeZoneStr = formatter.stringFromDate(date)
                            // : "2016-05-10 17:55:06 +0000" - UTC Time
                            
                            var pushID = String()
                            if tempDict!["pu"] != nil {
                                pushID = "\(tempDict!["pu"]!)"
                            } else {
                                pushID = ""
                            }
                            
                            var usImg = String()
                            if tempDict!["iu"] != nil {
                                usImg = "\(tempDict!["iu"]!)"
                            } else {
                                usImg = ""
                            }
                            
                            chRef.child("re").child((myDict["uid"] as! String)).child(poopy!).setValue(["id":"\(tempString)", "na":"\(otherFULLN)", "la":"", "ts":defaultTimeZoneStr,"pu":pushID, "iu":usImg, "re":1], withCompletionBlock: { (error, newchatrefo) in
                                //self.selectedUserDict = newchatrefo. as FIRDataSnapshot
                                
                                self.selectedUserDict = ["id":"\(tempString)", "na":"\(otherFULLN)", "la":"", "uid":poopy!, "ts":defaultTimeZoneStr, "pu":pushID, "iu":usImg]
                                
                                //self.pulseView.stopAnimating()
                                //self.pulseView.removeFromSuperview()
                                //self.view.userInteractionEnabled = true
                                
                                SwiftLoader.hide()
                                
                                self.performSegueWithIdentifier("goToMessage", sender: self)
                                
                            })
                        }
                    }
                }
                
            } else {
                let triggerTime = (Int64(NSEC_PER_SEC) * 1)
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
                    self.newChatAction()
                })
            }
        
        }
    }
    
    func formatTitle() {
        let titleLabel = UILabel()
        titleLabel.frame.size.height = 40
        titleLabel.frame.size.width = 120
        titleLabel.font = UIFont.init(name: "Georgia-Italic", size: 20)
        titleLabel.textColor = UIColor.darkTextColor()
        titleLabel.textAlignment = .Center
        titleLabel.text = "Messages"
        self.navigationItem.titleView = titleLabel
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return snapArray.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("messagelistcell", forIndexPath: indexPath) as! conversationListTableViewCell
        
        let nameo = snapArray[indexPath.row].value!["na"]
        cell.name.text = "\(nameo)"
        let lmo = snapArray[indexPath.row].value!["la"]
        cell.lastMessage.text = "\(lmo)"
        
        
        if let imgo = snapArray[indexPath.row].value!["iu"] {
            
            if "\(imgo)" != "" {
            cell.userImage.kf_setImageWithURL(NSURL(string: "\(imgo)"), placeholderImage: nil)
            } else {
                cell.userImage.image = UIImage(named: "women-hair.png")

            }
        } else {
            cell.userImage.image = UIImage(named: "women-hair.png")
        }

        
        
        let messTS = "\(snapArray[indexPath.row].value!["ts"])"
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        let reformattedDate = dateFormatter.dateFromString(messTS)

        let now: NSDate! = NSDate()
        let dayDiff = betweenDates(reformattedDate!, endDate: now)
        
        print(dayDiff)
        
        if dayDiff[0] < 1 {
            
            if dayDiff[1] == 0 {
                cell.timeStamp.text = "\(dayDiff[2]) min ago"
            } else {
                cell.timeStamp.text = "\(dayDiff[1]) hours ago"
            }

        } else if dayDiff[0] == 1 {
            cell.timeStamp.text = "Yesterday"
        } else if dayDiff[0] >= 2 {
            cell.timeStamp.text = "\(dayDiff[0]) days ago"
        }
        
        cell.deleteImage.image = nil
        if self.trashToggled == false {
            cell.deleteImage.image = UIImage(named: "chatlistarrow.png")
            cell.layer.borderColor = UIColor(red: 217/255, green: 217/255, blue: 219/255, alpha: 1.0).CGColor
            cell.layer.borderWidth = 0.5
            self.tableView.separatorStyle = .None
        } else {
            cell.deleteImage.image = UIImage(named: "rounded-remove-button.png")
            cell.layer.borderColor = UIColor(red: 255/255, green: 0, blue: 0, alpha: 0.1).CGColor
            cell.layer.borderWidth = 100
            self.tableView.separatorStyle = .SingleLine
        }
        if "\(snapArray[indexPath.row].value!["re"])" == "0" {
            cell.deleteImage.image = UIImage(named: "newmessage.png")
            tabBarController?.tabBar.items?[2].badgeValue = "!"

        }
        
        return cell
    }
    
    var selectedUserDict = NSMutableDictionary()

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if trashToggled == false {
            
            let snapo = snapArray[indexPath.row]
            
            selectedUserDict = ["id":"\(snapo.value!["id"])","na":"\(snapo.value!["na"])","uid":"\(snapo.key)","pu":"\(snapo.value!["pu"])","ts":"\(snapo.value!["ts"])","iu": "\(snapo.value!["iu"])"]
            
            //print("\(snapo.value!["id"])")
            //print("\(snapo.value!["id"])")
            //print("\(snapo.value!["id"])")
            //print("\(snapo.value!["id"])")
            
            
            //print("before print selectedUserDict")
            //print(selectedUserDict)
            
            queryRef.child("ch").child("re").child((FIRAuth.auth()?.currentUser!.uid)!).child(snapo.key).child("re").setValue(1)
            
        self.performSegueWithIdentifier("goToMessage", sender: self)
        } else {
            
            
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
            let alert = SCLAlertView(appearance: appearance)
            
            alert.addButton("Yes, Remove This Chat", action: {
                
                self.view.addSubview(self.pulseView)
                self.pulseView.startAnimating()
                self.view.userInteractionEnabled = false
                

                let delRef = queryRef.child("ch")
                let roomID = self.convDict[indexPath.row]["uid"] as! String
                
                
                delRef.child("ro").child(roomID).removeValueWithCompletionBlock({ (error, FIRDatabaseReference) in
                    
                    delRef.child("re").child((FIRAuth.auth()?.currentUser!.uid)!).child(roomID).removeValueWithCompletionBlock({ (error, FIRDatabaseReference) in
                        
                        delRef.child("re").child(self.convDict[indexPath.row]["id"] as! String).child(roomID).removeValueWithCompletionBlock({ (error, FIRDatabaseReference) in
                            
                            self.convDict.removeAtIndex(indexPath.row)
                            self.trashToggled = false
                            self.tableView.reloadData()
                            
                            self.pulseView.stopAnimating()
                            self.pulseView.removeFromSuperview()
                            self.view.userInteractionEnabled = true

                        })
                    })
                })
            })
            
            
            alert.showCustom("Delete?", subTitle: "Are you sure you want to delete this chat?", color: UIColor(red: 128 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 1.0), icon: UIImage(named: "alertedit.png")!)

        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToMessage" {
            
            let detailScene = segue.destinationViewController as! conversationViewController
            detailScene.msgDict = selectedUserDict
            
            //let testo:NSMutableDictionary = selectedUserDict
            
        }
        
        if segue.identifier == "newChatCreatedSegue" {
            
            //let detailScene = segue.destinationViewController as! conversationViewController
            //detailScene.justCreatedChat = true
            
        }
        
    }
}
