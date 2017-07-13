//
//  editAboutViewController.swift
//  Hair CV
//
//  Created by Ivan Khau on 4/17/16.
//  Copyright © 2016 Peer Goggles. All rights reserved.
//

import UIKit

class editAboutViewController: UIViewController, UIAlertViewDelegate {
    @IBAction func dismissView(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true) { 
            
        }
        
    }
    @IBAction func submitAbout(sender: AnyObject) {
        
        actionShowLoader()

        /*if textView.text == "" {
            currentUserObject!["about"] = "I'm a stylist on Hair CV"
            currentUserObject?.saveInBackgroundWithBlock({ (success, error) in
                
                SwiftLoader.hide()
                if error == nil {
                    self.dismissViewControllerAnimated(true, completion: {
                        
                    })
                } else {
                    let alertController = UIAlertController(title: "Error", message: "Could not change your about message at this time", preferredStyle:.Alert)
                    let alertActionOK = UIAlertAction(title: "OK", style: .Cancel) { action -> Void in
                        
                    }
                    alertController.addAction(alertActionOK)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            })
        } else {
            
            
            currentUserObject!["about"] = textView.text
            currentUserObject?.saveInBackgroundWithBlock({ (success, error) in
                SwiftLoader.hide()
                if error == nil {
                    
                    let alertController = UIAlertController(title: "Success", message: "Your About has been changed.", preferredStyle:.Alert)
                    let alertActionOK = UIAlertAction(title: "OK", style: .Cancel) { action -> Void in
                        
                        aboutChanged = true
                        
                        self.dismissViewControllerAnimated(true, completion: {
                            
                            
                            
                        })
                    }
                    alertController.addAction(alertActionOK)
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                    
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: "Could not change your about message at this time", preferredStyle:.Alert)
                    let alertActionOK = UIAlertAction(title: "OK", style: .Cancel) { action -> Void in
                        
                    }
                    alertController.addAction(alertActionOK)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            })
        }*/
        
        
        
    }

    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var submitButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*if let currentAbout = currentUserObject!["about"] {
           
            print(currentAbout)
            
            textView.text = currentAbout as! String
            
        } else {
            textView.text = "I just joined Hair Dew"
            
        }*/
        
        
        titleLabel.layer.borderWidth = 1
        titleLabel.layer.borderColor = UIColor.lightGrayColor().CGColor
        titleLabel.layer.masksToBounds = true
        
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGrayColor().CGColor
        textView.layer.cornerRadius = 5
        textView.layer.masksToBounds = true
        
        submitButtonOutlet.layer.cornerRadius = 7
        submitButtonOutlet.layer.masksToBounds = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(editAboutViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        textView.becomeFirstResponder()

    }
    
    func keyboardWillShow(notification:NSNotification) {
        let userInfo:NSDictionary = notification.userInfo!
        let keyboardFrame:NSValue = userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.CGRectValue()
        let keyboardHeight = keyboardRectangle.height
        
        textViewHeight.constant = phoneheight - keyboardHeight - 16 - 50 - 20 - 8 - 40
        UIView.animateWithDuration(0.5) {
            self.view.layoutIfNeeded()
            
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
