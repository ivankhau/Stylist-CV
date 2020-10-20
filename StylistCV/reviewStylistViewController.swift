//
//  reviewStylistViewController.swift
//  Hair CV
//
//  Created by Ivan Khau on 4/13/16.
//  Copyright © 2016 Peer Goggles. All rights reserved.
//

import UIKit
import Firebase

class reviewStylistViewController: UIViewController, FloatRatingViewDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate, UITextFieldDelegate, UIActionSheetDelegate {
    
    var liveLabel = UILabel()
    var updatedLabel = UILabel()
    var picker:UIImagePickerController?=UIImagePickerController()
    var popover:UIPopoverController?=nil
    var selectedDict = NSMutableDictionary()
    
    var ratingSelected:Bool = false
    var imageSelected:Bool = false
    
    
    
    @IBAction func closeReview(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) {}
    }
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    @IBOutlet weak var starChosenLabel: UILabel!
    @IBOutlet weak var reviewName: UILabel!
    @IBOutlet weak var addImage: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var floatRatingView: FloatRatingView!
    @IBOutlet weak var pictureButton: UIButton!
    
    @IBAction func addImageAction(sender: AnyObject) {
        
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default)
        {
            UIAlertAction in
            self.openCamera()
            
        }
        let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.Default)
        {
            UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel)
        {
            UIAlertAction in
            
        }
        
        // Add the actions
        picker?.delegate = self
        picker?.allowsEditing = true
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        // Present the controller
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else
        {
            popover=UIPopoverController(contentViewController: alert)
            popover!.presentPopoverFromRect(pictureButton.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }

    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
        {
            picker!.sourceType = UIImagePickerControllerSourceType.Camera
            self .presentViewController(picker!, animated: true, completion: nil)
        }
        else
        {
            openGallary()
        }
    }
    func openGallary()
    {
        picker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            self.presentViewController(picker!, animated: true, completion: nil)
            
        }
        else
        {
            popover=UIPopoverController(contentViewController: picker!)
            popover!.presentPopoverFromRect(pictureButton.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        picker .dismissViewControllerAnimated(true, completion: nil)
        addImage.image=info[UIImagePickerControllerEditedImage] as? UIImage
        
        self.imageSelected = true
        
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        print("picker cancel.")
        
        self.picker?.dismissViewControllerAnimated(true, completion: {
            
        })
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let revFName = selectedDict["fn"] as! String
        let refLName = selectedDict["ln"] as! String
        reviewName.text = "Reviewing:\r\(revFName) \(refLName)"
        
        
        formatView()
    }
    
    func formatView() {
        
        self.floatRatingView.emptyImage = UIImage(named: "StarEmpty")
        self.floatRatingView.fullImage = UIImage(named: "StarFull")
        self.floatRatingView.delegate = self
        self.floatRatingView.contentMode = UIViewContentMode.ScaleAspectFit
        self.floatRatingView.maxRating = 5
        self.floatRatingView.minRating = 1
        self.floatRatingView.rating = 2.5
        self.floatRatingView.editable = true
        self.floatRatingView.halfRatings = true
        self.floatRatingView.floatRatings = false
        self.floatRatingView.halfRatings = true
        
        // Labels init
        self.liveLabel.text = NSString(format: "%.2f", self.floatRatingView.rating) as String
        self.updatedLabel.text = NSString(format: "%.2f", self.floatRatingView.rating) as String
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(editAboutViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)

    }
    
    override func viewDidAppear(animated: Bool) {
        textView.becomeFirstResponder()
        
    }
    
    func keyboardWillShow(notification:NSNotification) {
        let userInfo:NSDictionary = notification.userInfo!
        let keyboardFrame:NSValue = userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.CGRectValue()
        let keyboardHeight = keyboardRectangle.height
        
        textViewHeight.constant = phoneheight - keyboardHeight - 98 - 20 - 8 - 56
        UIView.animateWithDuration(0.5) {
            self.view.layoutIfNeeded()
        }
    }

    func floatRatingView(ratingView: FloatRatingView, isUpdating rating:Float) {
        
        let theChosenOne = NSString(format: "%.1f", self.floatRatingView.rating) as String
        self.liveLabel.text = theChosenOne
        print(liveLabel.text!)
        
        self.ratingSelected = true
        
        starChosenLabel.text = "\(theChosenOne)/5\rSTARS"
        
        
    }
    
    func floatRatingView(ratingView: FloatRatingView, didUpdate rating: Float) {
        let theChosenOne = NSString(format: "%.1f", self.floatRatingView.rating) as String
        self.updatedLabel.text = theChosenOne
        
        print(updatedLabel.text!)
        starChosenLabel.text = "\(theChosenOne)/5\rSTARS"
        
        self.ratingSelected = true

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func submitReviewAction(sender: AnyObject) {
        
        if self.ratingSelected == true && self.imageSelected == true && self.textView.text != "" {
        
        actionShowLoader()

        let calcHeight = (550*addImage.image!.size.height)/addImage.image!.size.width
        let roundHeight = round(calcHeight)
        let convImg = ResizeImage(addImage.image!, targetSize: CGSizeMake(550, roundHeight))
        let imageData = UIImageJPEGRepresentation(convImg, 0.55)
        
        let calcHeight2 = (180*self.addImage.image!.size.height)/self.addImage.image!.size.width
        let roundHeight2 = round(calcHeight2)
        let convImg2 = ResizeImage(self.addImage.image!, targetSize: CGSizeMake(180, roundHeight2))
        let imageData2 = UIImageJPEGRepresentation(convImg2, 0.55)
        
        let photosRef = storage.reference().child("rp")

        let photoRef = photosRef.child("\(NSUUID().UUIDString).jpg")
        
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpg"
        
        
        // UPLOAD LARGE IMAGE
        photoRef.putData(imageData!, metadata: metadata, completion: { (metadata, error) in
            
            let largeName = metadata!.name!
            let largeURL = metadata!.downloadURL()!.absoluteString
            
            //let photosRef2 = storage.reference().child("rp")
            // Get a reference to store the file at chat_photos/<FILENAME>
            let photoRef2 = photosRef.child("\(NSUUID().UUIDString).jpg")
            
            // UPLOAD SMALL IMAGE
            photoRef2.putData(imageData2!, metadata: metadata, completion: { (metadata2, error) in
                let smallName = metadata2!.name!
                let smallURL = metadata2!.downloadURL()!.absoluteString
                let keyConv = self.selectedDict["uid"] as! String
                
                
                let date = NSDate()
                // : "May 10, 2016, 8:55 PM" - Local Date Time
                let formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
                let formattedDate = formatter.stringFromDate(date)
                // : "2016-05-10 20:55:06 +0300" - Local (GMT +3)
                //formatter.timeZone = NSTimeZone(abbreviation: "UTC")
                //let utcTimeZoneStr = formatter.stringFromDate(date)
                // : "2016-05-10 17:55:06 +0000" - UTC Time


                
                database.reference().child("ra").childByAutoId().setValue(["na":keyConv,"ul":largeURL, "nl":largeName,"us":smallURL,"ns":smallName,"te":"\(self.textView.text!)", "ra":self.floatRatingView.rating, "fn":myDict["fn"] as! String, "id":FIRAuth.auth()!.currentUser!.uid, "da":formattedDate], withCompletionBlock: { (error, refi) in

                    let raRef = refi.key
                
                // ADD REFERENCE TO BARBER'S REVIEWS
                let portRef = database.reference().child("re")
                portRef.child(keyConv).child(FIRAuth.auth()!.currentUser!.uid).setValue(["ul":largeURL, "nl":largeName,"us":smallURL,"ns":smallName,"te":"\(self.textView.text!)","ra":self.floatRatingView.rating, "na":FIRAuth.auth()!.currentUser!.uid, "fn":myDict["fn"] as! String, "id":FIRAuth.auth()!.currentUser!.uid, "rf":raRef, "da":formattedDate], withCompletionBlock: { (error, refo) in
                    
                        // ADD USER REFERENCE
                        database.reference().child("ur").child(FIRAuth.auth()!.currentUser!.uid).child(keyConv).setValue(["na":keyConv,"ul":largeURL, "nl":largeName,"us":smallURL,"ns":smallName,"te":"\(self.textView.text!)", "ra":self.floatRatingView.rating, "fn":myDict["fn"] as! String, "id": FIRAuth.auth()!.currentUser!.uid, "rf":raRef, "da":formattedDate], withCompletionBlock: { (error, refo) in
                            
                            SwiftLoader.hide()
                            self.dismissViewControllerAnimated(true, completion: {
                            })
                        })
                    
                })
                    })
            })
        })
        } else {
            SCLAlertView().showError("Hold On...", subTitle:"Make sure you've taken a photo, selected a rating, and wrote a review.", closeButtonTitle:"OK")
        }
        
    }
}
