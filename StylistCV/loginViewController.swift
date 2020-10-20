//
//  loginViewController.swift
//  Hair CV
//
//  Created by Ivan Khau on 5/18/16.
//  Copyright © 2016 Peer Goggles. All rights reserved.
//

import UIKit
import Firebase

class loginViewController: UIViewController, UIAlertViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var alertError:NSString!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeView()
        formatTitle()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(stylistCreateViewController.DismissKeyboard))
        view.addGestureRecognizer(tap)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func customizeView() {
        email.delegate = self
        password.delegate = self
        
    }
    
    @IBAction func logIn(sender: AnyObject) {
            DismissKeyboard()
            actionShowLoader()
        
        if self.email.text == "" || self.password.text == "" {
            SwiftLoader.hide()
            SCLAlertView().showError("Error", subTitle:"Could not find credentials matching this email and password.", closeButtonTitle:"OK")
            return
        }
        
            // Sign In with credentials.
            let email = self.email.text
            let password = self.password.text
            FIRAuth.auth()?.signInWithEmail(email!, password: password!) { (user, error) in
                if error != nil {
                    let error = error
                    print(error!.localizedDescription)
                    //ADD ERROR FOR UNABLE TO LOGIN, NO INTERNET OR SOME SHIT.
                    
                    SwiftLoader.hide()
                
                    SCLAlertView().showError("Error", subTitle:"\(error!.localizedDescription)", closeButtonTitle:"OK")

                }
                
                if FIRAuth.auth()!.currentUser != nil {
                    
                    let queryRef = database.reference()
                    queryRef.child("ty").child((FIRAuth.auth()?.currentUser!.uid)!).child("ty").observeSingleEventOfType(.Value, withBlock: { (typee) in
                        
                        var typeToSearch = String()
                        
                        
                        if typee.value as! Int == 0 {
                            stand.setValue("User", forKeyPath: "userType")
                            typeToSearch = "us"

                        } else {
                            stand.setValue("Stylist", forKeyPath: "userType")
                            typeToSearch = "st"
                        }
                        
                        let queryRef = database.reference().child(typeToSearch).child((FIRAuth.auth()?.currentUser!.uid)!)
                        
                        queryRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                            MeasurementHelper.sendLoginEvent()
                            
                            myDict = snapshot.value as! NSMutableDictionary
                            myDict.setValuesForKeysWithDictionary(["uid":FIRAuth.auth()!.currentUser!.uid])
                            
                            print(snapshot.value)
                            signedIn = true
                            justLoggedIn = true
                            SwiftLoader.hide()
                            self.navigationController!.popViewControllerAnimated(true)
                        })
                        
                    })
                }
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let range = testStr.rangeOfString(emailRegEx, options:.RegularExpressionSearch)
        let result = range == nil ? true : false
        return result
    }
    
    func checkLogin()-> Bool {
        let validLogin = isValidEmail(self.email.text!)
        if email.text!.isEmpty || password.text!.isEmpty {
            alertError = "Oops! Text is empty"
            return false
        } else if self.email.text! == "" || validLogin || self.email.text!.rangeOfString("@") == nil || self.email.text!.characters.count < 5 {
            alertError = "Invalid Email."
            return false
        } else if password.text!.characters.count < 5 {
            alertError = "Password is more than 4 characters."
            return false
        }
        return true
    }
    
    func formatTitle() {
        let titleLabelo = UILabel()
        titleLabelo.frame.size.height = 40
        titleLabelo.frame.size.width = 120
        
        titleLabelo.font = UIFont.init(name: "Georgia-Italic", size: 20)
        
        titleLabelo.textColor = UIColor.darkTextColor()
        titleLabelo.textAlignment = .Center
        titleLabelo.text = "Log In"
        self.navigationItem.titleView = titleLabelo
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

    @IBAction func forgetPasswordTapped(sender: AnyObject) {
        
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
        let alert = SCLAlertView(appearance: appearance)
        
        let textField = alert.addTextField("Email")
        
        alert.addButton("Reset Password") { 
            actionShowLoader()
            if textField.text != "" && (textField.text?.containsString("@"))! {
            
                FIRAuth.auth()?.sendPasswordResetWithEmail(textField.text!, completion: { (error) in
                    
                    SwiftLoader.hide()
                    
                    if error != nil {
                        
                        SCLAlertView().showError("Error", subTitle:(error?.localizedDescription)!, closeButtonTitle:"OK")
                        return
                        
                    }
                    
                    let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
                    let alert = SCLAlertView(appearance: appearance)
                    alert.showCustom("Email Sent", subTitle: "We've sent you an email to reset your password. If you don't see the email, check your spam folder.", color: UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 128 / 255.0, alpha: 1.0), icon: UIImage(named: "alertedit.png")!)
                    
                })
            } else {
                SwiftLoader.hide()
                SCLAlertView().showError("Error", subTitle:"Invalid Email.", closeButtonTitle:"OK")
            }

        }
        
        alert.showCustom("Recover Password", subTitle: "Enter your email.", color: UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 128 / 255.0, alpha: 1.0), icon: UIImage(named: "alertedit.png")!)
        
        
    }


}
