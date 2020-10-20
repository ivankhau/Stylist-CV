//
//  stylistCreateViewController.swift
//  Hair CV
//
//  Created by Ivan Khau on 5/17/16.
//  Copyright © 2016 Peer Goggles. All rights reserved.
//

import UIKit
import Firebase

class stylistCreateViewController: UIViewController,UIAlertViewDelegate,UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var viewTitle: UILabel!
    @IBOutlet weak var salonName: UITextField!
    @IBOutlet weak var carrotLAbel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var licenseNumber: UITextField!
    @IBOutlet weak var workAddress: UITextField!
    @IBOutlet weak var signUpTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var titleHeightConstant: NSLayoutConstraint!
    
    var userOrStylist = String()
    var alertError:NSString!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if userOrStylist == "Stylist" {
            viewTitle.text = "HAIRSTYLIST REGISTRATION"
            //signUpButton.setTitle("Sign Up - Stylist", forState: .Normal)
            signUpTopConstraint.constant = 132
            createWorkAddressButton()
            
        } else if userOrStylist == "User" {
            viewTitle.text = "SIGN UP"
            titleHeightConstant.constant = 0
            
            //signUpButton.setTitle("Sign Up - Reviewer", forState: .Normal)
            signUpTopConstraint.constant = 12
            licenseNumber.hidden = true
            workAddress.hidden = true
            carrotLAbel.hidden = true
            salonName.hidden = true
            
        }
        
        assignTextfieldDelegates()
        formatTitle()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(stylistCreateViewController.DismissKeyboard))
        view.addGestureRecognizer(tap)
        
        carrotLAbel.layer.cornerRadius = 4
        carrotLAbel.layer.masksToBounds = true
        
    }
    
    override func viewDidAppear(animated: Bool) {
        DismissKeyboard()
        
        if selectedLocation == 1 {
            selectedLocation = 0
            
            
            print(addressSave)
            
            workAddress.text = "\(addressSave["Street"]!), \(addressSave["City"]!) \(addressSave["State"]!)"
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func signUpUser(sender: AnyObject) {
        DismissKeyboard()
        if checkSignup() == true {
            actionShowLoader()
            if userOrStylist == "Stylist" {
                
                createStylist()
                
            } else if userOrStylist == "User" {
                
                createUser()
                
            }
            
        } else {
            let alert = UIAlertView(title: "Incomplete Submission", message: alertError as String, delegate: self, cancelButtonTitle: "Okay")
            alert.show()
        }
    }
    
    func createStylist() {
        
        let emailTar = self.email.text
        let passwordTar = self.password.text
        
        FIRAuth.auth()?.createUserWithEmail(emailTar!, password: passwordTar!) { (user, error) in
            if error != nil {
                
                let error = error
                print(error!.localizedDescription)
                
                SCLAlertView().showError("Error", subTitle:"\(error!.localizedDescription)", closeButtonTitle:"OK")
                SwiftLoader.hide()
                
            } else {
            
            var addressLineOne = String()
            var addressLineTwo = String()
                        
            addressLineOne = "\(addressSave["Street"]!)"
            addressLineTwo = "\(addressSave["City"]!) \(addressSave["State"]!)"
            
            let date = NSDate()
            // : "May 10, 2016, 8:55 PM" - Local Date Time
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
            let formattedDate = formatter.stringFromDate(date)
            // : "2016-05-10 20:55:06 +0300" - Local (GMT +3)
            //formatter.timeZone = NSTimeZone(abbreviation: "UTC")
            //let utcTimeZoneStr = formatter.stringFromDate(date)
            // : "2016-05-10 17:55:06 +0000" - UTC Time
                
            let ref = database.reference()
            let userRef = ref.child("st").child(FIRAuth.auth()!.currentUser!.uid)
            userRef.setValue(["fn": "\(self.firstName.text!)", "ln": "\(self.lastName.text!)", "ao": addressLineOne, "at": addressLineTwo, "la": locationSave!.latitude, "lo": locationSave!.longitude, "rs": 0, "rc": 0, "li": "\(self.licenseNumber.text!)", "wn": "\(self.salonName.text!)", "em":"\(emailTar!)", "sc":0, "da":formattedDate, "uid":FIRAuth.auth()!.currentUser!.uid, "pu":"", "po":0], withCompletionBlock: { (error, FIRDatabaseReference) in
                
                stand.setDouble(0, forKey: "score")

                let geofireRef = ref.child("lo")
                let geoFire = GeoFire(firebaseRef: geofireRef)
                
                ref.child("ty").child(FIRAuth.auth()!.currentUser!.uid).setValue(["ty":1])
                
                geoFire.setLocation(CLLocation(latitude: locationSave!.latitude, longitude: locationSave!.longitude), forKey: FIRAuth.auth()!.currentUser!.uid, withCompletionBlock: { (error) in
                    
                     MeasurementHelper.sendLoginEvent()
                     stand.setDouble(0, forKey: "portfolioCount")
                     stand.setValue("Stylist", forKeyPath: "userType")
                     stand.synchronize()
                 myDict.setValuesForKeysWithDictionary(["li":self.licenseNumber.text!,"fn":self.firstName.text!,"ln":self.lastName.text!,"ao":addressLineOne,"at":addressLineTwo,"la":locationSave!.latitude,"lo":locationSave!.longitude,"rs":0,"rc":0,"wn":self.salonName.text!,"em":"\(emailTar!)", "sc":0, "da":formattedDate, "uid": (FIRAuth.auth()?.currentUser?.uid)!, "po":0, "pu":""])
                    
                     signedIn = true
                     justLoggedIn = true
                     SwiftLoader.hide()
                    
                     locationSave = nil
                     self.navigationController!.popViewControllerAnimated(true)
                     
                     })
            })
            }
        }
    }
    
    func createUser() {
        
        let emailTar = self.email.text
        let passwordTar = self.password.text

        FIRAuth.auth()?.createUserWithEmail(emailTar!, password: passwordTar!) { (user, error) in
            if error != nil {
                let error = error
                print(error!.localizedDescription)
                SCLAlertView().showError("Error", subTitle:"\(error!.localizedDescription)", closeButtonTitle:"OK")
                SwiftLoader.hide()
                
            } else {
            
                let montho = getDate("month"); let dayo = getDate("day"); let yearo = getDate("year")
                let formattedDate = "\(montho)-\(dayo)-\(yearo)"

                
            let ref = database.reference()
            let userRef = ref.child("us").child(FIRAuth.auth()!.currentUser!.uid)
            userRef.setValue(["fn": "\(self.firstName.text!)", "ln": "\(self.lastName.text!)", "em":"\(emailTar!)", "da":formattedDate, "pu":""], withCompletionBlock: { (error, FIRDatabaseReference) in
                
                ref.child("ty").child(FIRAuth.auth()!.currentUser!.uid).setValue(["ty":0])
                    
                    MeasurementHelper.sendLoginEvent()
                    stand.setValue("User", forKeyPath: "userType")
                
                    
                    stand.synchronize()
                
                
                    myDict.setValuesForKeysWithDictionary(["fn":self.firstName.text!,"ln":self.lastName.text!,"em":"\(emailTar!)", "uid":(FIRAuth.auth()?.currentUser?.uid)!, "da":formattedDate, "pu":""])
                    
                    signedIn = true
                    
                    justLoggedIn = true
                    SwiftLoader.hide()
                    self.navigationController!.popViewControllerAnimated(true)

            })
            }
        }

    }
    
    
    
    func formatTitle() {
        
        let titleLabelo = UILabel()
        titleLabelo.frame.size.height = 40
        titleLabelo.frame.size.width = 120
        
        titleLabelo.font = UIFont.init(name: "Georgia-Italic", size: 20)
        
        titleLabelo.textColor = UIColor.darkTextColor()
        titleLabelo.textAlignment = .Center
        titleLabelo.text = "Sign Up"
        self.navigationItem.titleView = titleLabelo
        
    }

    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let range = testStr.rangeOfString(emailRegEx, options:.RegularExpressionSearch)
        let result = range == nil ? true : false
        return result
    }
    
    func checkSignup()-> Bool {
        let name = email.text!
        let validLogin = isValidEmail(name)
        if userOrStylist == "Stylist" {
            if email.text!.isEmpty || password.text!.isEmpty || firstName.text!.isEmpty || lastName.text!.isEmpty || licenseNumber.text!.isEmpty || workAddress.text!.isEmpty {
                alertError = "You left a textfield blank."
                return false
            } else if name == "" || validLogin || name.rangeOfString("@") == nil || name.characters.count < 5 {
                alertError = "Invalid Email."
                return false
            } else if password.text!.characters.count < 5 {
                alertError = "Password should be more than 4 characters."
                return false
            }
            return true
        } else {
            
            if email.text!.isEmpty || password.text!.isEmpty || firstName.text!.isEmpty || lastName.text!.isEmpty {
                alertError = "You left a textfield blank."
                return false
            } else if name == "" || validLogin || name.rangeOfString("@") == nil || name.characters.count < 5 {
                alertError = "Invalid Email."
                return false
            } else if password.text!.characters.count < 5 {
                alertError = "Password should be more than 4 characters."
                return false
            }
            return true
            
        }
    }
 
    
    func createWorkAddressButton() {
        
        let workAddressButton = UIButton(frame: CGRectMake(workAddress.frame.origin.x, workAddress.frame.origin.y, workAddress.frame.size.width, workAddress.frame.size.height))
        workAddressButton.addTarget(self, action: #selector(stylistCreateViewController.workAddressPressed), forControlEvents: .TouchUpInside)
        self.view.addSubview(workAddressButton)
        
    }
    
    func workAddressPressed() {
        DismissKeyboard()
        self.performSegueWithIdentifier("stylistCreateToSelectAddressSegue", sender: self)
    }
    
    func assignTextfieldDelegates() {
        firstName.delegate = self
        lastName.delegate = self
        email.delegate = self
        password.delegate = self
        licenseNumber.delegate = self
        salonName.delegate = self
    }

    
    func DismissKeyboard(){
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        return false
    }
    
    struct MoveKeyboard {
        static let KEYBOARD_ANIMATION_DURATION : CGFloat = 0.3
        static let MINIMUM_SCROLL_FRACTION : CGFloat = 0.2;
        static let MAXIMUM_SCROLL_FRACTION : CGFloat = 0.8;
        static let PORTRAIT_KEYBOARD_HEIGHT : CGFloat = 216;
        static let LANDSCAPE_KEYBOARD_HEIGHT : CGFloat = 162;
    }
    var animateDistance: CGFloat!
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.layer.borderColor = UIColor(red: 13 / 255.0, green: 213 / 255.0, blue: 252 / 255.0, alpha: 1.0)
            .CGColor
        textField.layer.borderWidth = 3
        let textFieldRect : CGRect = self.view.window!.convertRect(textField.bounds, fromView: textField)
        let viewRect : CGRect = self.view.window!.convertRect(self.view.bounds, fromView: self.view)
        let midline : CGFloat = textFieldRect.origin.y + 0.5 * textFieldRect.size.height
        let numerator : CGFloat = midline - viewRect.origin.y - MoveKeyboard.MINIMUM_SCROLL_FRACTION * viewRect.size.height
        let denominator : CGFloat = (MoveKeyboard.MAXIMUM_SCROLL_FRACTION - MoveKeyboard.MINIMUM_SCROLL_FRACTION) * viewRect.size.height
        var heightFraction : CGFloat = numerator / denominator
        
        if heightFraction < 0.0 {
            heightFraction = 0.0
        } else if heightFraction > 1.0 {
            heightFraction = 1.0
        }
        let orientation : UIInterfaceOrientation = UIApplication.sharedApplication().statusBarOrientation
        if (orientation == UIInterfaceOrientation.Portrait || orientation == UIInterfaceOrientation.PortraitUpsideDown) {
            animateDistance = floor(MoveKeyboard.PORTRAIT_KEYBOARD_HEIGHT * heightFraction)
        } else {
            animateDistance = floor(MoveKeyboard.LANDSCAPE_KEYBOARD_HEIGHT * heightFraction)
        }
        var viewFrame : CGRect = self.view.frame
        viewFrame.origin.y -= animateDistance
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(NSTimeInterval(MoveKeyboard.KEYBOARD_ANIMATION_DURATION))
        self.view.frame = viewFrame
        UIView.commitAnimations()
    }
    func textFieldDidEndEditing(textField: UITextField) {
        textField.layer.borderColor = UIColor.clearColor().CGColor
        var viewFrame : CGRect = self.view.frame
        viewFrame.origin.y += animateDistance
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(NSTimeInterval(MoveKeyboard.KEYBOARD_ANIMATION_DURATION))
        self.view.frame = viewFrame
        UIView.commitAnimations()
    }


    
    
}
