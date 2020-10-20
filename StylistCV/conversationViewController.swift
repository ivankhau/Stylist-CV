//
//  conversationViewController.swift
//  Hair CV
//
//  Created by Ivan Khau on 7/20/16.
//  Copyright © 2016 Peer Goggles. All rights reserved.
//


import Photos
import UIKit
import Firebase

@objc(conversationViewController)

class conversationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,
UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var titleButton: UIButton!
    
    var msgDict = NSMutableDictionary()
    
    @IBOutlet weak var textFieldBottom: NSLayoutConstraint!
    @IBOutlet weak var bottomView: UIView!
    // Instance variables
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    var ref: FIRDatabaseReference!
    var messages: [FIRDataSnapshot]! = []
    var msglength: NSNumber = 1000
    private var _refHandle: FIRDatabaseHandle!
    
    var storageRef: FIRStorageReference!
    var remoteConfig: FIRRemoteConfig!
    
    var userName = String()
    
    @IBOutlet weak var clientTable: UITableView!
    
    
    var myPush = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if myDict["pu"] != nil {
            myPush = myDict["pu"] as! String
        } else {
            myPush = ""
        }
        
        
        
        print(msgDict)
        
        
        let toName = msgDict["na"] as! String
        self.titleButton.setTitle(toName, forState: UIControlState.Normal)
        
        bottomView.layer.borderColor = UIColor(red: 217/255, green: 217/255, blue: 219/255, alpha: 1.0).CGColor
        bottomView.layer.borderWidth = 2
        
        configureDatabase()
        textField.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(conversationViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        self.clientTable.rowHeight = UITableViewAutomaticDimension
        self.clientTable.estimatedRowHeight = 120
        
        let triggerTime = (Int64(NSEC_PER_SEC) * 3)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
            
            self.turnOffAnimation = true
            
        })
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if selectedImageToSend != nil {
            
            textField.text = selectedImageToSend
            selectedImageToSend = nil
            textFieldShouldReturn(textField)
            
        }
    }
    
    var keyboardShown = false
    func keyboardWillShow(notification:NSNotification) {
        if keyboardShown == false {
            keyboardShown = true
            let userInfo:NSDictionary = notification.userInfo!; let keyboardFrame:NSValue = userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue; let keyboardRectangle = keyboardFrame.CGRectValue(); let keyboardHeight = keyboardRectangle.height
            //textFieldBottom.constant = phoneheight - keyboardHeight - UIApplication.sharedApplication().statusBarFrame.size.height - self.navigationController!.navigationBar.frame.height - 40
            
            textFieldBottom.constant = keyboardHeight
            
            
            
            let triggerTime = (Int64(NSEC_PER_SEC) * 1/4)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
                self.clientTable.scrollToRowAtIndexPath(NSIndexPath(forRow: self.messages.count-1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
            })
        }
    }
    
    deinit {
        self.ref.child("ch").child("ro").child((msgDict["uid"] as! String)).removeObserverWithHandle(_refHandle)
    }
    
    var turnOffAnimation:Bool = false
    
    func configureDatabase() {
        ref = FIRDatabase.database().reference()
        // Listen for new messages in the Firebase database
        _refHandle = self.ref.child("ch").child("ro").child((msgDict["uid"] as! String)).observeEventType(.ChildAdded, withBlock: { (snapshot) -> Void in
            self.messages.append(snapshot)
            self.clientTable.insertRowsAtIndexPaths([NSIndexPath(forRow: self.messages.count-1, inSection: 0)], withRowAnimation: .Automatic)
            
            if self.turnOffAnimation == false {
                self.clientTable.scrollToRowAtIndexPath(NSIndexPath(forRow: self.messages.count-1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
                
            } else {
                self.clientTable.scrollToRowAtIndexPath(NSIndexPath(forRow: self.messages.count-1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
                
            }
        })
    }
    
    @IBAction func didSendMessage(sender: UIButton) {
        textFieldShouldReturn(textField)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        let newLength = text.utf16.count + string.utf16.count - range.length
        return newLength <= self.msglength.integerValue // Bool
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ClientCell", forIndexPath: indexPath) as! chatMessageTableViewCell
        
        let messageSnapshot: FIRDataSnapshot! = self.messages[indexPath.row]
        let message = messageSnapshot.value as! Dictionary<String, String>
        let name = message[Constants.MessageFields.name] as String!
        let text = message[Constants.MessageFields.text] as String!
        
        print(message)
        
        
        cell.messageLabel.text = ""
        cell.messageLabel2.text = ""
        cell.messageLabel.alpha = 0
        cell.messageLabel2.alpha = 0
        cell.sentImage.image = nil
        cell.sentImage2.image = nil
        
        cell.imageHeight.constant = 3
        cell.imageHeight2.constant = 3
        cell.behindMessage.alpha = 0
        cell.behindMessage2.alpha = 0
        
        if name == "\(myDict["fn"] as! String) \(myDict["ln"] as! String)" {
            //cell.nameLabel.textAlignment = .Right
            
            //if indexPath.row % 4 == 0 || indexPath.row == 1 {
            //cell.nameLabel.text = "You"
            //} else {
            //    cell.nameLabel.text = ""
            //}
            
            if text.hasPrefix("https://firebasestorage.googleapis.com") {
                cell.sentImage2!.kf_setImageWithURL(NSURL(string: text)!)
                cell.imageHeight2.constant = 180
                
            } else {
                cell.messageLabel2.alpha = 1
                cell.behindMessage2.alpha = 1
                cell.messageLabel2.text = text
            }
            
        } else {
            //cell.nameLabel.textAlignment = .Left
            
            //if indexPath.row % 4 == 0 || indexPath.row == 1 {
            //cell.nameLabel.text = "\(name)"
            //} else {
            //    cell.nameLabel.text = ""
            //}
            
            cell.messageLabel.layer.backgroundColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1).CGColor
            cell.messageLabel.textColor = UIColor.blackColor()
            
            if text.hasPrefix("https://firebasestorage.googleapis.com") {
                cell.sentImage!.kf_setImageWithURL(NSURL(string: text)!)
                cell.imageHeight.constant = 180
                
            } else {
                cell.messageLabel.alpha = 1
                cell.behindMessage.alpha = 1
                
                cell.messageLabel.text = text
            }
        }
        
        return cell
    }
    
    // UITextViewDelegate protocol methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let data = [Constants.MessageFields.text: textField.text! as String]
        sendMessage(data)
        return true
    }
    
    func sendMessage(data: [String: String]) {
        
        let messageCapture:String = self.textField.text!
        let fn = myDict["fn"] as! String
        let ln = myDict["ln"] as! String
        let fulln = "\(fn) \(ln)"
        
        var usImg = String()
        if myDict["iu"] != nil {
            usImg = myDict["iu"] as! String
        } else {
            usImg = ""
        }

        
        let chatuid = (msgDict["uid"] as! String)
        
        if textField.text != "" {
            
            let date = NSDate()
            // : "May 10, 2016, 8:55 PM" - Local Date Time
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
            let defaultTimeZoneStr = formatter.stringFromDate(date)
            // : "2016-05-10 20:55:06 +0300" - Local (GMT +3)
            //formatter.timeZone = NSTimeZone(abbreviation: "UTC")
            //let utcTimeZoneStr = formatter.stringFromDate(date)
            // : "2016-05-10 17:55:06 +0000" - UTC Time
            
            if messages.count == 1 {
                
                var usImg = String()
                if myDict["iu"] != nil {
                    usImg = myDict["iu"] as! String
                } else {
                    usImg = ""
                }
                
                    queryRef.child("ch").child("re").child(msgDict["id"] as! String).child(chatuid).setValue(["id":"\(myDict["uid"] as! String)", "na":"\(fulln)", "la":messageCapture, "ts":defaultTimeZoneStr, "pu":myPush, "iu":usImg, "re":0])
                
            } else {
                if messageCapture.hasPrefix("https://firebasestorage.googleapis.com") {
                    
                    queryRef.child("ch").child("re").child((self.msgDict["id"] as! String)).child(chatuid).updateChildValues(["la":"Image Received", "ts":defaultTimeZoneStr, "pu":myPush, "iu":usImg, "re":0])
                    
                    
                    if allowsPush == true && (msgDict["pu"]) != nil {
                        
                        if msgDict["pu"] as! String != "" {
                            OneSignal.defaultClient().postNotification(["contents": ["en": "You received a message."], "include_player_ids": ["\(msgDict["pu"] as! String)"]])
                            allowsPush = false
                            let triggerTime = (Int64(NSEC_PER_SEC) * 10)
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
                                self.allowsPush = true
                            })
                        }
                    }

                } else {
                    
                    queryRef.child("ch").child("re").child(self.msgDict["id"] as! String).child(chatuid).updateChildValues(["la":messageCapture, "ts":defaultTimeZoneStr,"pu":myPush, "iu":usImg, "re":0])
                    if allowsPush == true && (msgDict["pu"]) != nil {
                        if msgDict["pu"] as! String != "" {
                            
                            OneSignal.defaultClient().postNotification(["contents": ["en": "You received a message."], "include_player_ids": ["\(msgDict["pu"] as! String)"]])
                            
                            
                            allowsPush = false
                            let triggerTime = (Int64(NSEC_PER_SEC) * 10)
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
                                self.allowsPush = true
                            
                            })
                        
                        }
                    }
  
                }
                
            }
            
            var mdata = data
            let fn = myDict["fn"] as! String; let ln = myDict["ln"] as! String
            let nameo:String = "\(fn) \(ln)"
            
            mdata[Constants.MessageFields.name] = nameo
            self.ref.child("ch").child("ro").child((msgDict["uid"] as! String)).childByAutoId().setValue(mdata)
        }
        
        self.textField.text = ""
    }
    var allowsPush:Bool = true
    func pushTimer() {
        
    }
    
    @IBAction func shareImageTapped(sender: AnyObject) {
        
        let ref = NSUserDefaults.standardUserDefaults().objectForKey("likedImages")
        if ref == nil {
            SCLAlertView().showNotice("Hold On...", subTitle: "To share, you need to like a photo first")
        } else {
            
            self.performSegueWithIdentifier("selectPhotoToSend", sender: self)
            
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "selectPhotoToSend" {
            
            let detailScene = segue.destinationViewController as! likedViewController
            
            detailScene.cameFromMessages = true
        }
    }
}
