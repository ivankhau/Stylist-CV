//
//  AddVC.swift
//  Hair CV
//
//  Created by Ivan Khau on 4/8/16.
//  Copyright © 2016 Peer Goggles. All rights reserved.
//

import UIKit
import Firebase


class AddVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate {
    
    //@IBOutlet weak var imgView: RoundImage!
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var imgHeight: NSLayoutConstraint!
    
    @IBOutlet weak var imgWidth: NSLayoutConstraint!
    
    @IBOutlet weak var segControl: UISegmentedControl!
    
    
    
    override func viewDidLoad() {
        
        self.navigationItem.titleView = TitleViewStyle(text: "Portfolio Submission")

        
        super.viewDidLoad()
        imgView.layer.borderColor = UIColor(red: 216/255, green: 216/255, blue: 221/255, alpha: 1.0).CGColor
        imgView.layer.borderWidth = 2
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(editAboutViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func keyboardWillShow(notification:NSNotification) {
        let userInfo:NSDictionary = notification.userInfo!
        let keyboardFrame:NSValue = userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.CGRectValue()
        let keyboardHeight = keyboardRectangle.height
        
        imgHeight.constant = phoneheight - keyboardHeight - 8 - 22 - 30 - 38 - 26 - 10 - 65 - 37
        imgWidth.constant = phoneheight - keyboardHeight - 8 - 22 - 30 - 38 - 26 - 10 - 65 - 37
        UIView.animateWithDuration(0.5) {
            self.view.layoutIfNeeded()
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBOutlet weak var imgBtn: UIButton!
    @IBOutlet weak var descTxt: UITextField!
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        imgView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        addedImageBool = true
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addImg(sender: UIButton!) {
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        imgPicker.allowsEditing = true
        presentViewController(imgPicker, animated: true, completion: nil)
        
        imgBtn.setTitle("", forState: .Normal)
    }
    
    var addedImageBool = false
    
    @IBAction func addPost(sender: UIButton!) {
        
        actionShowLoader()
        
        var sex = String()
        if segControl.selectedSegmentIndex == 0 {
            sex = "f"
        } else {
            sex = "m"
        }
        
        if addedImageBool != false {
            
            let calcHeight = (600*imgView.image!.size.height)/imgView.image!.size.width
            let roundHeight = round(calcHeight)
            let convImg = ResizeImage(imgView.image!, targetSize: CGSizeMake(600, roundHeight))
            let imageData = UIImageJPEGRepresentation(convImg, 0.50)

            let calcHeight2 = (200*self.imgView.image!.size.height)/self.imgView.image!.size.width
            let roundHeight2 = round(calcHeight2)
            let convImg2 = ResizeImage(self.imgView.image!, targetSize: CGSizeMake(200, roundHeight2))
            let imageData2 = UIImageJPEGRepresentation(convImg2, 0.50)
            
            let autoIdAndSmallName = NSUUID().UUIDString
            
            let photosRef = storage.reference().child("pp")
            let photoRef = photosRef.child("\(NSUUID().UUIDString).jpg")
            let photoRef2 = photosRef.child("\(autoIdAndSmallName).jpg")

            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpg"
            
            let date = NSDate()
            // : "May 10, 2016, 8:55 PM" - Local Date Time
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
            let formattedDate = formatter.stringFromDate(date)
            // : "2016-05-10 20:55:06 +0300" - Local (GMT +3)
            //formatter.timeZone = NSTimeZone(abbreviation: "UTC")
            //let utcTimeZoneStr = formatter.stringFromDate(date)
            // : "2016-05-10 17:55:06 +0000" - UTC Time


            // ADDS LARGE IMAGE
            photoRef.putData(imageData!, metadata: metadata, completion: { (metadata, error) in
                
                let largeName = metadata!.name!
                let largeURL = metadata!.downloadURL()!.absoluteString
                
                let ref = NSUserDefaults.standardUserDefaults()
                var arrayo = [NSString]()
                if ref.objectForKey("likedImages") != nil {
                    arrayo = ref.objectForKey("likedImages") as! [NSString]
                    if arrayo.contains(largeURL as NSString) {
                        arrayo = arrayo.filter{$0 != (largeURL as NSString)}
                        ref.setObject(arrayo, forKey: "likedImages")
                    } else {
                        arrayo.append(largeURL as NSString)
                        ref.setObject(arrayo, forKey: "likedImages")
                    }
                } else {
                    arrayo.append(largeURL as NSString)
                    ref.setObject(arrayo, forKey: "likedImages")
                }
                
                // ADDS SMALL IMAGE
                photoRef2.putData(imageData2!, metadata: metadata, completion: { (metadata2, error) in
                    //let smallName = metadata2!.name!
                    let smallURL = metadata2!.downloadURL()!.absoluteString
                    
                    
                    // ADDS METADATA TO PORTFOLIO
                    let portRef = database.reference().child("po")
                    portRef.child(FIRAuth.auth()!.currentUser!.uid).child(autoIdAndSmallName).setValue(["ul":largeURL, "nl":largeName,"us":smallURL,"ns":autoIdAndSmallName,"te":"\(self.descTxt.text!)", "ge" : sex, "da":formattedDate], withCompletionBlock: { (error, refo) in
                        
                        //let portfolioReference = refo.key
                        
                        let userNameo = "\(myDict["fn"] as! String) \(myDict["ln"] as! String)"
                        
                        
                        // ADDS METADATA TO ACTIVITY
                        let actRef = database.reference().child("ac")
                        actRef.childByAutoId().setValue(["na":"\(FIRAuth.auth()!.currentUser!.uid)","ul":largeURL, "nl":largeName,"us":smallURL,"ns":autoIdAndSmallName,"te":"\(self.descTxt.text!)", "ge" : sex, "da":formattedDate, "fn":userNameo], withCompletionBlock: { (error, actrefo) in
                            
                            let activityReference = actrefo.key
                            
                            portRef.child(FIRAuth.auth()!.currentUser!.uid).child(refo.key).updateChildValues(["ar":activityReference])
                            
                            var currPortCount = Int()
                            if myDict["po"] != nil {
                                currPortCount = myDict["po"] as! Int
                            } else {
                                currPortCount = 0
                            }
                            
                            currPortCount = currPortCount + 1
                            
                            queryRef.child("st").child((FIRAuth.auth()?.currentUser?.uid)!).updateChildValues(["po":currPortCount])
                            
                            myDict.setValuesForKeysWithDictionary(["po":currPortCount])
                            
                            addedToPortfolio = true
                            SwiftLoader.hide()
                            self.navigationController?.popViewControllerAnimated(true)
                            
                            
                        })
                        
                        
                    })
                })
            })
            

            
        } else {
            SwiftLoader.hide()
            let alertView = UIAlertController(title: "Incomplete", message: "Select a photo.", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            presentViewController(alertView, animated: true, completion: nil)
        }
        
        
    }
    
}
