//
//  moreTableViewController.swift
//  Hair CV
//
//  Created by Ivan Khau on 4/5/16.
//  Copyright © 2016 Peer Goggles. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class moreTableViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate, UITextFieldDelegate, UIActionSheetDelegate  {
    
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var reviewCollectionView: UICollectionView!
    @IBOutlet weak var stylistTableView: UITableView!
    @IBOutlet weak var registerLoginTableView: UITableView!
    @IBOutlet weak var userTableView: UITableView!
    //@IBOutlet weak var reviewButtonOutlet: UIButton!
    @IBOutlet weak var hairStylistButtonOutlet: UIButton!
    @IBOutlet weak var loginButtonOutlet: UIButton!
    @IBOutlet weak var navTitle: UINavigationItem!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileAddress: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var membershipButton: UIButton!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var priceButton: UIButton!
    @IBOutlet weak var portfolioCountLabel: UILabel!
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var previewButton: UIButton!
    //@IBOutlet var userTableViewButtonCollection: [UIButton]!
    @IBOutlet weak var normalUserImage: UIImageView!
    @IBOutlet weak var normalUserName: UILabel!
    @IBOutlet weak var portfolioLabel: UILabel!
    @IBOutlet weak var pfImageOne: UIButton!
    @IBOutlet weak var pfImageTwo: UIButton!
    @IBOutlet weak var pfImageOneBack: UIImageView!
    @IBOutlet weak var pfImageTwoBack: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var loadingPortfolioImage: UIImageView!
    @IBOutlet weak var loadingReviewImage: UIImageView!
    @IBOutlet weak var workName: UILabel!
    @IBOutlet weak var portfolioHeight: NSLayoutConstraint!
    @IBOutlet weak var reviewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewAllPortfolio: UIButton!
    @IBOutlet weak var viewAllReviews: UIButton!
    
    var whichimage = Int()
    var alertError:NSString!
    var picker:UIImagePickerController?=UIImagePickerController()
    var popover:UIPopoverController?=nil
    var portDict = [NSMutableDictionary]()
    var revDict = [NSMutableDictionary]()
    var changeNumberTextfield = UITextField()
    //var loadingLabel = UILabel(frame: CGRectMake(phonewidth/2 - 50, phoneheight/2 - 100, 100, 45))
    var alertView: AlertViewLoveNotification!
    
    @IBAction func portfolioCollectionSegueAction(sender: AnyObject) {
        self.performSegueWithIdentifier("portfolioCollectionSegue", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        stylistTableView.hidden = true
        userTableView.hidden = true
        registerLoginTableView.hidden = true
        
        actionShowLoader()
        formatView()
        //formatLoadingLabel()
        
        self.collectionView.layer.borderColor = UIColor(red: 217/255, green: 217/255, blue: 219/255, alpha: 1.0).CGColor
        self.collectionView.layer.borderWidth = 1
        self.reviewCollectionView.layer.borderColor = UIColor(red: 217/255, green: 217/255, blue: 219/255, alpha: 1.0).CGColor
        self.reviewCollectionView.layer.borderWidth = 1
        
        self.addPhotoButton.layer.borderColor = UIColor(red: 217/255, green: 217/255, blue: 219/255, alpha: 1.0).CGColor
        self.addPhotoButton.layer.borderWidth = 1

        self.viewAllReviews.layer.borderColor = UIColor(red: 217/255, green: 217/255, blue: 219/255, alpha: 1.0).CGColor
        self.viewAllReviews.layer.borderWidth = 1

        self.viewAllPortfolio.layer.borderColor = UIColor(red: 217/255, green: 217/255, blue: 219/255, alpha: 1.0).CGColor
        self.viewAllPortfolio.layer.borderWidth = 1
        
        let profileImageTapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(moreTableViewController.profileImageTapped(_:))); profileImage.userInteractionEnabled = true; profileImage.addGestureRecognizer(profileImageTapGestureRecognizer)
        
        let nameTapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(moreTableViewController.nameTapped(_:))); profileName.userInteractionEnabled = true; profileName.addGestureRecognizer(nameTapGestureRecognizer)
        
        let addressTapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(moreTableViewController.addressTapped(_:))); profileAddress.userInteractionEnabled = true; profileAddress.addGestureRecognizer(addressTapGestureRecognizer)
        
        let workTapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(moreTableViewController.workTapped(_:))); workName.userInteractionEnabled = true; workName.addGestureRecognizer(workTapGestureRecognizer)
        
        let normalUserProfileImageTapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(moreTableViewController.normalUserProfileImageTapped(_:))); normalUserImage.userInteractionEnabled = true; normalUserImage.addGestureRecognizer(normalUserProfileImageTapGestureRecognizer)
        
        
        if FIRAuth.auth()?.currentUser == nil {
            checkLogin()

        } else {
            if signedIn == true {
                checkLogin()

            } else {
                reCheck()
            }

        }
        
    }
    
    func reCheck() {
        let triggerTime = (Int64(NSEC_PER_SEC) * 1)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
            if signedIn == true {
                self.checkLogin()
                
            } else {
                self.reCheck()
            }
            
        })
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

    
    override func viewDidAppear(animated: Bool) {
        
        if justLoggedIn == true {
            justLoggedIn = false
            checkLogin()
            
            self.alertView = AlertViewLoveNotification(imageName: "pushpromptwithcirc.png", labelTitle: "CHAT NOTIFICATIONS", labelDescription: "Would you like to be alerted when you receive a message? We also send push notifications with major updates.", buttonYESTitle: "Yes, of course!", buttonNOTitle: "No, sorry.")
            self.alertView.show()
        }
        
        if addedToPortfolio == true {
            addedToPortfolio = false
            loadCollectionViewData()
        }
        
        if selectedLocation == 1 {
            selectedLocation = 0
            
            let ref = database.reference()
            let userRef = ref.child("st").child(FIRAuth.auth()!.currentUser!.uid)
            
            userRef.updateChildValues(["ao" : "\(addressSave["Street"]!)", "at" : "\(addressSave["City"]!) \(addressSave["State"]!)"])
            
            self.profileAddress.text = "  \(addressSave["Street"]!)\r  \(addressSave["City"]!) \(addressSave["State"]!)"
            
            let geofireRef = ref.child("lo")
            let geoFire = GeoFire(firebaseRef: geofireRef)
        
            geoFire.setLocation(CLLocation(latitude: locationSave!.latitude, longitude: locationSave!.longitude), forKey: FIRAuth.auth()!.currentUser!.uid, withCompletionBlock: { (error) in
                
            })
            
            let addressLineOne = "\(addressSave["Street"]!)"
            let addressLineTwo = "\(addressSave["City"]!) \(addressSave["State"]!)"
            
            myDict.setValuesForKeysWithDictionary(["ao":addressLineOne,"at":addressLineTwo,"la":locationSave!.latitude,"lo":locationSave!.longitude])
            
            locationSave = nil
            
        }
    }
    
    func formatView() {
        
        let titleLabelo = UILabel(); titleLabelo.frame.size.height = 40; titleLabelo.frame.size.width = 120; titleLabelo.font = UIFont.init(name: "Georgia-Italic", size: 20); titleLabelo.textColor = UIColor.darkTextColor(); titleLabelo.textAlignment = .Center
        titleLabelo.text = "Profile"
        self.navigationItem.titleView = titleLabelo
    }
    
    func checkLogin() {
        
        if (FIRAuth.auth()?.currentUser) != nil {
            
            if stand.stringForKey("userType") == "Stylist" {
            
            loadCollectionViewData()

            stylistTableView.hidden = false
            userTableView.hidden = true
            registerLoginTableView.hidden = true
            SwiftLoader.hide()
            populateInformation()
                
            } else if stand.stringForKey("userType") == "User" {
                
                stylistTableView.hidden = true
                userTableView.hidden = false
                registerLoginTableView.hidden = true
                SwiftLoader.hide()
                populateInformation()
            }

        } else {
            stylistTableView.hidden = true
            userTableView.hidden = true
            registerLoginTableView.hidden = false
            SwiftLoader.hide()
            
        }
    }
    
    func normalUserProfileImageTapped(img: AnyObject) {
        whichimage = 69
        
        picker?.delegate = self
        
        picker?.allowsEditing = true
        
        self.openCamera()
        
        
    }
    
    func profileImageTapped(img: AnyObject) {
        
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: true
        )
        
        let alerto = SCLAlertView(appearance: appearance)
        
        let subview = UIView(frame: CGRectMake(0,0,0,0))
        alerto.customSubview = subview

        
        alerto.addButton("Take Photo") {
            self.whichimage = 1
            
            let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) {
                UIAlertAction in self.openCamera()
            }
            let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.Default) {
                UIAlertAction in self.openGallary()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
                UIAlertAction in
            }
            self.picker?.delegate = self; self.picker?.allowsEditing = true
            alert.addAction(cameraAction); alert.addAction(gallaryAction); alert.addAction(cancelAction)
            // Present the controller
            if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                self.popover=UIPopoverController(contentViewController: alert); self.popover!.presentPopoverFromRect(self.profileImage.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
            }
        }
        let icon = UIImage(named:"photo-camera-2")
        alerto.showCustom("Change Profile Image", subTitle: "A photo of you, your salon, or station is recommended.", color: UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 128 / 255.0, alpha: 1.0), icon: (icon)!)
        

    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            picker!.sourceType = UIImagePickerControllerSourceType.Camera
            self .presentViewController(picker!, animated: true, completion: nil)
        } else {
            openGallary()
        }
    }
    func openGallary()
    {
        picker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            self.presentViewController(picker!, animated: true, completion: nil)
        } else {
            popover=UIPopoverController(contentViewController: picker!)
            popover!.presentPopoverFromRect(profileImage.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        actionShowLoader()
        
        // Main PF Image
        if whichimage == 1 {
            picker.dismissViewControllerAnimated(true, completion: nil)
            let placeholderImage = ResizeImage((info[UIImagePickerControllerEditedImage] as? UIImage)!, targetSize: CGSizeMake(150.0, 150.0))
            let imageData = UIImageJPEGRepresentation(placeholderImage, 0.6)
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpg"
            
            let refoo = myDict["in"]
            
            if refoo != nil {
                
                let photoRef = storage.reference().child("up").child(refoo! as! String)
                
                photoRef.putData(imageData!, metadata: metadata).observeStatus(.Success) { (snapshot) in
                    
                    let chRef = database.reference().child("st").child(FIRAuth.auth()!.currentUser!.uid).child("in")
                    let imageURL = snapshot.metadata!.downloadURL()!.absoluteString
                    chRef.setValue(imageURL)
                    
                    myDict.setValuesForKeysWithDictionary(["iu":imageURL])
                    
                    self.profileImage.kf_setImageWithURL(NSURL(string: imageURL)!, placeholderImage: nil, optionsInfo: [.ForceRefresh])
                    SwiftLoader.hide()
                    updateScore()
                }
                
            } else {
                
                let photosRef = storage.reference().child("up")
                let photoRef = photosRef.child("\(NSUUID().UUIDString).jpg")
                photoRef.putData(imageData!, metadata: metadata).observeStatus(.Success) { (snapshot) in
                    
                    let chRef = database.reference().child("st").child(FIRAuth.auth()!.currentUser!.uid)
                    let imageURL = snapshot.metadata!.downloadURL()!.absoluteString
                    chRef.child("iu").setValue(imageURL)
                    let imageName = snapshot.metadata!.name!
                    chRef.child("in").setValue(imageName)
                    
                    myDict.setValuesForKeysWithDictionary(["iu":imageURL, "in":imageName])

                    
                    self.profileImage.kf_setImageWithURL(NSURL(string: imageURL)!, placeholderImage: nil, optionsInfo: [.ForceRefresh])
                    SwiftLoader.hide()
                    updateScore()
                }
            }
        }
        
        // PF Side Image 1
        if whichimage == 2 {
            
            picker.dismissViewControllerAnimated(true, completion: nil)
            
            let placeholderImage = ResizeImage((info[UIImagePickerControllerEditedImage] as? UIImage)!, targetSize: CGSizeMake(150.0, 150.0))
            
            let imageData = UIImageJPEGRepresentation(placeholderImage, 0.6)
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpg"
            
            let refoo = myDict["ino"]
            
            if refoo != nil {
                
                let photoRef = storage.reference().child("sp").child(refoo! as! String)
                
                photoRef.putData(imageData!, metadata: metadata).observeStatus(.Success) { (snapshot) in
                    
                    let chRef = database.reference().child("st").child(FIRAuth.auth()!.currentUser!.uid).child("iuo")
                    let imageURL = snapshot.metadata!.downloadURL()!.absoluteString
                    chRef.setValue(imageURL)
                    
                    myDict.setValuesForKeysWithDictionary(["iuo":imageURL])

                    
                    
                    self.pfImageOne.setTitle("", forState: .Normal)
                    self.pfImageOneBack.kf_setImageWithURL(NSURL(string: imageURL)!, placeholderImage: nil, optionsInfo: [.ForceRefresh])
                    SwiftLoader.hide()
                    updateScore()
                }
            } else {
                
                let photosRef = storage.reference().child("sp")
                let photoRef = photosRef.child("\(NSUUID().UUIDString).jpg")
                photoRef.putData(imageData!, metadata: metadata).observeStatus(.Success) { (snapshot) in
                    
                    let chRef = database.reference().child("st").child(FIRAuth.auth()!.currentUser!.uid)
                    let imageURL = snapshot.metadata!.downloadURL()!.absoluteString
                    chRef.child("iuo").setValue(imageURL)

                    let imageName = snapshot.metadata!.name!
                    chRef.child("ino").setValue(imageName)
                    self.pfImageOne.setTitle("", forState: .Normal)
                    self.pfImageOneBack.kf_setImageWithURL(NSURL(string: imageURL)!, placeholderImage: nil, optionsInfo: [.ForceRefresh])
                    
                    myDict.setValuesForKeysWithDictionary(["iuo":imageURL, "ino":imageName])
                    SwiftLoader.hide()
                    updateScore()
                }
            }
        }
        
        // PF Side Image 2
        if whichimage == 3 {
            picker.dismissViewControllerAnimated(true, completion: nil)
            
            let placeholderImage = ResizeImage((info[UIImagePickerControllerEditedImage] as? UIImage)!, targetSize: CGSizeMake(150.0, 150.0))
            let imageData = UIImageJPEGRepresentation(placeholderImage, 0.6)
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpg"
            let refoo = myDict["int"]
            
            if refoo != nil {
                
                let photoRef = storage.reference().child("sp").child(refoo! as! String)
                
                photoRef.putData(imageData!, metadata: metadata).observeStatus(.Success) { (snapshot) in
                    
                    let chRef = database.reference().child("st").child(FIRAuth.auth()!.currentUser!.uid).child("iut")
                    let imageURL = snapshot.metadata!.downloadURL()!.absoluteString
                    chRef.setValue(imageURL)
                    
                    myDict.setValuesForKeysWithDictionary(["iut":imageURL])
                    self.pfImageTwo.setTitle("", forState: .Normal)
                    self.pfImageTwoBack.kf_setImageWithURL(NSURL(string: imageURL)!, placeholderImage: nil, optionsInfo: [.ForceRefresh])
                    
                    SwiftLoader.hide()
                    updateScore()
                }
            } else {
                
                let photosRef = storage.reference().child("sp")
                let photoRef = photosRef.child("\(NSUUID().UUIDString).jpg")
                photoRef.putData(imageData!, metadata: metadata).observeStatus(.Success) { (snapshot) in
                    
                    let chRef = database.reference().child("st").child(FIRAuth.auth()!.currentUser!.uid)
                    let imageURL = snapshot.metadata!.downloadURL()!.absoluteString
                    chRef.child("iut").setValue(imageURL)
                    
                    let imageName = snapshot.metadata!.name!
                    chRef.child("int").setValue(imageName)
                    self.pfImageTwo.setTitle("", forState: .Normal)
                    self.pfImageTwoBack.kf_setImageWithURL(NSURL(string: imageURL)!, placeholderImage: nil, optionsInfo: [.ForceRefresh])
                    myDict.setValuesForKeysWithDictionary(["iut":imageURL,"int":imageName])
                    SwiftLoader.hide()
                    updateScore()
                }
            }
        }
        
        // Normal User Profile Pic Change
        if whichimage == 69 {
            picker.dismissViewControllerAnimated(true, completion: nil)
            
            let placeholderImage = ResizeImage((info[UIImagePickerControllerEditedImage] as? UIImage)!, targetSize: CGSizeMake(200.0, 200.0))
            let imageData = UIImageJPEGRepresentation(placeholderImage, 0.6)
            
            //SwiftLoader.hide()
            //self.normalUserImage.image = UIImage(data: imageData!)
            
            
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpg"
            
            let refoo = myDict["in"]
            
            if refoo != nil {
                
                let photoRef = storage.reference().child("nup").child(refoo! as! String)
                
                photoRef.putData(imageData!, metadata: metadata).observeStatus(.Success) { (snapshot) in
                    
                    let chRef = database.reference().child("us").child(FIRAuth.auth()!.currentUser!.uid).child("in")
                    let imageURL = snapshot.metadata!.downloadURL()!.absoluteString
                    chRef.setValue(imageURL)
                    
                    myDict.setValuesForKeysWithDictionary(["iu":imageURL])
                    
                    self.normalUserImage.kf_setImageWithURL(NSURL(string: imageURL)!, placeholderImage: nil, optionsInfo: [.ForceRefresh])
                    SwiftLoader.hide()

                }
                
            } else {
                
                let photosRef = storage.reference().child("nup")
                let photoRef = photosRef.child("\(NSUUID().UUIDString).jpg")
                photoRef.putData(imageData!, metadata: metadata).observeStatus(.Success) { (snapshot) in
                    
                    let chRef = database.reference().child("us").child(FIRAuth.auth()!.currentUser!.uid)
                    let imageURL = snapshot.metadata!.downloadURL()!.absoluteString
                    chRef.child("iu").setValue(imageURL)
                    let imageName = snapshot.metadata!.name!
                    chRef.child("in").setValue(imageName)
                    
                    myDict.setValuesForKeysWithDictionary(["iu":imageURL, "in":imageName])
                    
                    
                    self.normalUserImage.kf_setImageWithURL(NSURL(string: imageURL)!, placeholderImage: nil, optionsInfo: [.ForceRefresh])
                    SwiftLoader.hide()

                }
            }

            
            
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("picker cancel.")
        self.picker?.dismissViewControllerAnimated(true, completion: {
        })
    }
    
    @IBAction func pfImageOneAction(sender: AnyObject) {
        
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: true
        )
        
        let alerto = SCLAlertView(appearance: appearance)
        
        let subview = UIView(frame: CGRectMake(0,0,0,0))
        alerto.customSubview = subview

        
        alerto.addButton("Take Photo") {
            self.whichimage = 2
            
            let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                self.openCamera()
            }
            let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                self.openGallary()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
                UIAlertAction in
            }
            
            self.picker?.delegate = self
            
            self.picker?.allowsEditing = true
            alert.addAction(cameraAction)
            alert.addAction(gallaryAction)
            alert.addAction(cancelAction)
            // Present the controller
            if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                self.popover=UIPopoverController(contentViewController: alert)
                self.popover!.presentPopoverFromRect(self.pfImageOne.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
            }
        }
        let icon = UIImage(named:"photo-camera-2")
        alerto.showCustom("Preview Image 1", subTitle: "Preview Image is shown in search and should be a haircut you've done.", color: UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 128 / 255.0, alpha: 1.0), icon: (icon)!)
        
    }
    
    @IBAction func pfImageTwoAction(sender: AnyObject) {
        
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: true
        )
        
        let alerto = SCLAlertView(appearance: appearance)
        
        let subview = UIView(frame: CGRectMake(0,0,0,0))
        alerto.customSubview = subview

        
        alerto.addButton("Take Photo") {
            self.whichimage = 3
            
            let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                self.openCamera()
            }
            let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                self.openGallary()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
                UIAlertAction in
            }
            
            self.picker?.delegate = self
            self.picker?.allowsEditing = true
            alert.addAction(cameraAction)
            alert.addAction(gallaryAction)
            alert.addAction(cancelAction)
            // Present the controller
            if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                self.popover=UIPopoverController(contentViewController: alert)
                self.popover!.presentPopoverFromRect(self.pfImageTwo.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
            }
        }
        let icon = UIImage(named:"photo-camera-2")
        alerto.showCustom("Preview Image 2", subTitle: "Preview Image is shown in search and should be a haircut you've done.", color: UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 128 / 255.0, alpha: 1.0), icon: (icon)!)
        
    }
    
    func nameTapped(name: AnyObject) {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: true
        )
        
        
        var fplaceholder = ""
        var lplaceholder = ""
        
        if myDict["fn"] != nil {
            
            fplaceholder = myDict["fn"] as! String

            
            
        } else {
            fplaceholder = "First Name"
        }
        
        if myDict["ln"] != nil {
            lplaceholder = myDict["ln"] as! String
        } else {
            lplaceholder = "Last Name"
            
        }
        
        let alert = SCLAlertView(appearance: appearance)
        
        let subview = UIView(frame: CGRectMake(0,0,0,0))
        alert.customSubview = subview
        
        let textfield1 = alert.addTextField(fplaceholder)
        textfield1.autocorrectionType = .No
        textfield1.keyboardType = .ASCIICapable
        
        let textfield2 = alert.addTextField(lplaceholder)
        textfield2.autocorrectionType = .No
        textfield2.keyboardType = .ASCIICapable

        alert.addButton("Change") {
            if textfield1.text != "" && textfield2.text != "" && textfield1.text!.characters.count > 1 && textfield1.text!.characters.count > 0 {
            var fnameo = myDict["fn"] as! String
            var lnameo = myDict["ln"] as! String
            
            let pfRef = database.reference().child("st").child(FIRAuth.auth()!.currentUser!.uid)
            if textfield1.text != fnameo {
                fnameo = textfield1.text!
                pfRef.child("fn").setValue(textfield1.text!)
            }
            if textfield2.text != lnameo {
                lnameo = textfield2.text!
                pfRef.child("ln").setValue(textfield2.text!)
            }
            self.profileName.text = "  \(fnameo) \(lnameo)"
            myDict.setValuesForKeysWithDictionary(["fn":fnameo,"ln":lnameo])
            } else {
                SCLAlertView().showError("Unable to Change", subTitle:"You must fill in a first name and last name.", closeButtonTitle:"OK")
            }
        }
        let icon = UIImage(named:"alertedit.png")
        alert.showCustom("Edit Name", subTitle: "Once verified, name can only be changed by contacting support.", color: UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 128 / 255.0, alpha: 1.0), icon: (icon)!)
    }
    
    func workTapped(name: AnyObject) {
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
        let alert = SCLAlertView(appearance: appearance)
        
        let subview = UIView(frame: CGRectMake(0,0,0,0))
        alert.customSubview = subview
        
        let txt = alert.addTextField("Salon Name")
        if myDict["wn"] != nil {
            txt.text = (myDict["wn"] as! String)
        }
        txt.keyboardType = UIKeyboardType.ASCIICapable
        txt.autocapitalizationType = .Words
        alert.addButton("Change") {
            if txt.text!.characters.count > 3 {
                let pfRef = database.reference().child("st").child(FIRAuth.auth()!.currentUser!.uid)
                pfRef.child("wn").setValue(txt.text!, withCompletionBlock: { (error, FIRDatabaseReference) in
                    myDict.setValuesForKeysWithDictionary(["wn":txt.text!])
                    self.workName.text = "  \(txt.text!)"
                })
            } else {
                SCLAlertView().showError("Hold On...", subTitle:"Invalid Salon Name", closeButtonTitle:"OK")
            }
        }
        
        alert.showCustom("Edit Salon Name", subTitle: "Enter your work name below.", color: UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 128 / 255.0, alpha: 1.0), icon: UIImage(named: "alertedit.png")!)
        
    }

    
    var licenseMessage = String()
    
    @IBAction func verifyAction(sender: AnyObject) {
        var vero = false
        if myDict["ve"] != nil {
            if myDict["ve"] as! NSNumber == 1 {
                vero = true
            }
        } else {
        }
        if vero != true {
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
        let alert = SCLAlertView(appearance: appearance)
        let txt = alert.addTextField("Barber License Number")
            
            if myDict["li"] != nil {
                txt.text = (myDict["li"] as! String)
            }
            
        txt.keyboardType = UIKeyboardType.ASCIICapable
        txt.autocorrectionType = .No
        txt.autocapitalizationType = .AllCharacters
        alert.addButton("Change") {
            if txt.text!.characters.count > 3 && txt.text! != myDict["li"] as! String {
                let pfRef = database.reference().child("st").child(FIRAuth.auth()!.currentUser!.uid)
                pfRef.child("li").setValue(txt.text!, withCompletionBlock: { (error, FIRDatabaseReference) in
                    
                    myDict.setValuesForKeysWithDictionary(["li":txt.text!])
                    
                    SCLAlertView().showNotice("Notice", subTitle: "The license will be used for verification. This usually takes a few days, but the more complete your profile, the faster the verification process.")
                })
            } else {
                SCLAlertView().showError("Hold On...", subTitle:"You need to enter a valid barber license number for verification.", closeButtonTitle:"OK")
            }
            
        }
            
        alert.showCustom("Verification", subTitle: "Enter your Cosmetology or Barber License for verification. Verification usually takes a couple of days.", color: UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 128 / 255.0, alpha: 1.0), icon: UIImage(named: "alertedit.png")!)
            
        }
    
    }

    func addressTapped(address: AnyObject) {
        self.performSegueWithIdentifier("moreToAddressSelect", sender: self)
        print("Tap THAT [address field]!!")
    }
    
    @IBAction func phoneTapped(sender: AnyObject) {
        
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
        let alert = SCLAlertView(appearance: appearance)
        
        let subview = UIView(frame: CGRectMake(0,0,0,0))
        alert.customSubview = subview

        
        let txt = alert.addTextField("Phone Number")
        txt.keyboardType = UIKeyboardType.PhonePad
        txt.autocorrectionType = .No
        txt.autocapitalizationType = .AllCharacters
        txt.tag = 69
        txt.delegate = self
        
        alert.addButton("Change") {
            print("Text value: \(txt.text!)")
            
            let name = txt.text!
            
            let stringArray = name.componentsSeparatedByCharactersInSet(
                NSCharacterSet.decimalDigitCharacterSet().invertedSet)
            let newString = stringArray.joinWithSeparator("")
            
            if newString.characters.count == 10 && name != "" {

                let pfRef = database.reference().child("st").child(FIRAuth.auth()!.currentUser!.uid)
                    pfRef.child("pn").setValue(txt.text!, withCompletionBlock: { (error, FIRDatabaseReference) in

                        
                        self.phoneLabel.text = "Work Phone: \(name)"
                        
                        myDict.setValuesForKeysWithDictionary(["pn":name])
                        
                        
                        updateScore()
                        
                    })
                

            } else {
                SCLAlertView().showError("Hold On...", subTitle:"Your phone number should be 10 digits long.", closeButtonTitle:"OK")
            }
            
        }
        
        alert.showCustom("Edit Phone Number", subTitle: "Change your work phone number below.", color: UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 128 / 255.0, alpha: 1.0), icon: UIImage(named: "alertedit.png")!)
        
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let range = testStr.rangeOfString(emailRegEx, options:.RegularExpressionSearch)
        let result = range != nil ? true : false
        return result
    }

    @IBAction func emailTapped(sender: AnyObject) {
        
        let myEmail = myDict["em"] as! String
        var myTitle = String()
        var mySubTitle = String()
        var myButton = String()
        if myEmail == "" {
            myTitle = "Display Your Email?"
            mySubTitle = "Are you sure you want to display your email in your profile?"
            myButton = "Yes, Display My Email"
        } else {
            myTitle = "Hide Your Email?"
            mySubTitle = "Are you sure you want your email hidden from your profile?"
            myButton = "Yes, Hide My Email"
        }
        
        let currEmail = (FIRAuth.auth()?.currentUser?.email)!
        
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
        let alert = SCLAlertView(appearance: appearance)
        alert.addButton(myButton) {
            if myEmail == "" {
                
                queryRef.child("st").child((FIRAuth.auth()?.currentUser?.uid)!).child("em").setValue(currEmail)                
                myDict.setValuesForKeysWithDictionary(["em":currEmail])
                self.emailLabel.text = "Email: \(currEmail)"
                
                
            } else {
                queryRef.child("st").child((FIRAuth.auth()?.currentUser?.uid)!).child("em").setValue("")
                myDict.setValuesForKeysWithDictionary(["em":""])
                self.emailLabel.text = "Email: \(currEmail) (Hidden)"
            }
        }
        
        alert.showCustom(myTitle, subTitle: mySubTitle, color: UIColor(red:0,green:0,blue:128/255, alpha: 1.0), icon: UIImage(named:"alertedit.png")!)

    }
    
    @IBAction func aboutClicked(sender: AnyObject) {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: true
        )
        let alert = SCLAlertView(appearance: appearance)
        let subview = UIView(frame: CGRectMake(0,0,0,0))
        alert.customSubview = subview


        
        let textfield1 = alert.addTextView()
        
        let icon = UIImage(named:"alertedit.png")
        if let abouto = myDict["ab"] {
            textfield1.text = abouto as! String
        } else {
            textfield1.text = "I just joined Stylist CV!"
        }
        //alert.customSubview = subview
        alert.addButton("Submit") {
            
            if textfield1.text.characters.count > 4 {
                let abRef = database.reference().child("st").child(FIRAuth.auth()!.currentUser!.uid).child("ab")
                abRef.setValue(textfield1.text!, withCompletionBlock: { (error, FIRDatabaseReference) in
                    if (error == nil) {
                        self.aboutLabel.text = "About: \(textfield1.text!)"
                        
                        
                        myDict.setValuesForKeysWithDictionary(["ab":textfield1.text!])
                        
                        
                        updateScore()
                        
                        
                        
                    } else {
                        SCLAlertView().showError("Hold On...", subTitle:"No internet connection, please try again later.", closeButtonTitle:"OK")
                    }
                })
            } else {
                SCLAlertView().showError("Hold On...", subTitle:"Your about message needs to be longer.", closeButtonTitle:"OK")
            }
            
            
        }
        
        //UIColor(red: 76 / 255.0, green: 106 / 255.0, blue: 146 / 255.0, alpha: 1.0)
        alert.showCustom("Edit \"About\"", subTitle: "Your about message is seen on your profile as well as search.", color: UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 128 / 255.0, alpha: 1.0), icon: (icon)!)

        
    }
    
    
    func populateInformation() {
        if signedIn == true {
            if stand.objectForKey("userType") as! String == "Stylist" {
            // POPULATE STYLIST VIEW
            if let imgURL = myDict["iu"] {
                profileImage.kf_setImageWithURL(NSURL(string: imgURL as! String)!, placeholderImage: nil)
            } else {
            }
            if let imgURL = myDict["iuo"] {
                pfImageOneBack.kf_setImageWithURL(NSURL(string: imgURL as! String)!, placeholderImage: nil)
                self.pfImageOne.setTitle("", forState: .Normal)
            } else {
            }
            
            if let imgURL = myDict["iut"] {
                pfImageTwoBack.kf_setImageWithURL(NSURL(string: imgURL as! String)!, placeholderImage: nil)
                self.pfImageTwo.setTitle("", forState: .Normal)
            } else {
            }
            
            if let name = myDict["fn"] {
                self.profileName.text = "  \(name) \(myDict["ln"]!)"
            } else {
                self.profileName.text = ""
            }
            
            if let workNameo = myDict["wn"] {
                workName.text = "  \(workNameo)"
            } else {
                workName.text = ""
            }
            
            if let locate = myDict["ao"] {
                self.profileAddress.text = "  \(locate)\r  \(myDict["at"]!)"
            } else {
                profileAddress.text = ""
            }
            
            if let abouto = myDict["ab"] {
                aboutLabel.text = "About: \(abouto)"
            } else {
                aboutLabel.text = "About: I just joined Stylist CV!"
            }
            
            if let emailo = myDict["em"] {
                let currEmail = (FIRAuth.auth()?.currentUser?.email)!
                if emailo as! String == "" {
                    self.emailLabel.text = "Email: \(currEmail) (Hidden)"
                } else {
                self.emailLabel.text = "Email: \(currEmail)"
                }
            } else {
                self.emailLabel.text = "Add Email"
            }
            
            if let phono = myDict["pn"] {
                self.phoneLabel.text = "Work Phone: \(phono)"
            } else {
                self.phoneLabel.text = "Add Work Phone"
            }
            if let veri = myDict["ve"]{
            if veri as! NSNumber == 1 {
                    self.verifyButton.setTitle("Verified", forState: .Normal)
                }else {
                    self.verifyButton.setTitle("Unverified", forState: .Normal)
                }
                } else {
                    self.verifyButton.setTitle("Unverified", forState: .Normal)
            }
            
            } else {
                // POPULATE USER VIEW                
                if let name = myDict["fn"] {
                    self.normalUserName.text = "  \(name) \(myDict["ln"]!)"
                } else {
                    self.normalUserName.text = ""
                }
                
                if let imageo = myDict["iu"] {
                    normalUserImage.kf_setImageWithURL(NSURL(string: imageo as! String)!, placeholderImage: nil)
                } else {
                    
                }
                
                
            }
        }
   
    }
    
    
    func loadCollectionViewData() {
        
        self.portDict.removeAll()
        self.revDict.removeAll()
        
        self.collectionView.reloadData()
        self.reviewCollectionView.reloadData()
        
        if FIRAuth.auth()!.currentUser != nil && stand.stringForKey("userType") == "Stylist" {
 
            
            viewAllReviews.enabled = false
            viewAllReviews.alpha = 0.5
            
            viewAllPortfolio.enabled = false
            viewAllPortfolio.alpha = 0.5

            let queryRef = FIRDatabase.database().reference().child("po").child(FIRAuth.auth()!.currentUser!.uid).queryOrderedByChild("da")
            queryRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in
                
                var portArray = [NSMutableDictionary]()
                
                //let poopy = snapshot.children.key
                
                for item in snapshot.children {
                    
                    let portItem = NSMutableDictionary()
                    
                    if let actRef = item.value["ar"] {
                        portItem.setValuesForKeysWithDictionary(["ar":actRef])
                    } else {
                        portItem.setValuesForKeysWithDictionary(["ar":""])
                    }
                    if let gendo = item.value["ge"] {
                        portItem.setValuesForKeysWithDictionary(["ge":gendo])
                    } else {
                        portItem.setValuesForKeysWithDictionary(["ge":""])
                    }
                    if let namelargo = item.value["nl"] {
                        portItem.setValuesForKeysWithDictionary(["nl":namelargo])
                    } else {
                        portItem.setValuesForKeysWithDictionary(["nl":""])
                    }
                    if let namepetite = item.value["ns"] {
                        portItem.setValuesForKeysWithDictionary(["ns":namepetite])
                    } else {
                        portItem.setValuesForKeysWithDictionary(["ns":""])
                    }
                    if let captiono = item.value["te"] {
                        portItem.setValuesForKeysWithDictionary(["te":captiono])
                    } else {
                        portItem.setValuesForKeysWithDictionary(["te":""])
                    }
                    if let urlLargo = item.value["ul"] {
                        portItem.setValuesForKeysWithDictionary(["ul":urlLargo])
                    } else {
                        portItem.setValuesForKeysWithDictionary(["ul":""])
                    }
                    if let urlpetite = item.value["us"] {
                        portItem.setValuesForKeysWithDictionary(["us":urlpetite])
                    } else {
                        portItem.setValuesForKeysWithDictionary(["us":""])
                    }
                    let myfn = myDict["fn"] as! String
                    let myln = myDict["ln"] as! String
                    
                    portItem.setValuesForKeysWithDictionary(["fn":"\(myfn) \(myln)"])
                    
                    portArray.append(portItem)
                }
                

                self.portDict = portArray.reverse()
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    self.collectionView.reloadData()
                    
                    if self.portDict.count == 0 {

                    } else {
                        self.loadingPortfolioImage.hidden = true
                        self.viewAllPortfolio.enabled = true
                        self.viewAllPortfolio.alpha = 1.0
                        
                        if myDict["po"] != nil {
                            
                            if myDict["po"] as! Int != self.portDict.count {
                                FIRDatabase.database().reference().child("st").child((FIRAuth.auth()?.currentUser?.uid)!).updateChildValues(["po":self.portDict.count])
                                
                                myDict.setValuesForKeysWithDictionary(["po":self.portDict.count])
                            }
                        }
                    }
                    self.portfolioCountLabel.text = "\(self.portDict.count)"
                    
                    
                    
                    /*if Double(self.portCount.count) != stand.doubleForKey("portfolioCount") {
                    
                        stand.setDouble(Double(self.portDict.count), forKey: "portfolioCount")
                        
                    }*/
                    
                    
                    
                    

                })
            })
            
            let revRef = FIRDatabase.database().reference().child("re").child(FIRAuth.auth()!.currentUser!.uid).queryOrderedByChild("da")
            revRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in
                
                var revArray = [NSMutableDictionary]()
                
                for item in snapshot.children {
                    
                    var revItem = NSMutableDictionary()
                    
                    if let revRef = item.value["rf"] {
                        revItem.setValuesForKeysWithDictionary(["rf":revRef])
                    } else {
                        revItem.setValuesForKeysWithDictionary(["rf":""])
                    }
                    
                    if let namelargo = item.value["nl"] {
                        revItem.setValuesForKeysWithDictionary(["nl":namelargo])
                    } else {
                        revItem.setValuesForKeysWithDictionary(["nl":""])
                    }
                    
                    if let namepetite = item.value["ns"] {
                        revItem.setValuesForKeysWithDictionary(["ns":namepetite])
                    } else {
                        revItem.setValuesForKeysWithDictionary(["ns":""])
                    }
                    
                    if let captiono = item.value["te"] {
                        revItem.setValuesForKeysWithDictionary(["te":captiono])
                    } else {
                        revItem.setValuesForKeysWithDictionary(["te":""])
                    }
                    
                    if let urlLargo = item.value["ul"] {
                        revItem.setValuesForKeysWithDictionary(["ul":urlLargo])
                    } else {
                        revItem.setValuesForKeysWithDictionary(["ul":""])
                    }
                    if let urlpetite = item.value["us"] {
                        revItem.setValuesForKeysWithDictionary(["us":urlpetite])
                    } else {
                        revItem.setValuesForKeysWithDictionary(["us":""])
                    }
                    
                    if let nameo = item.value["fn"] {
                        revItem.setValuesForKeysWithDictionary(["fn":nameo])
                    } else {
                        revItem.setValuesForKeysWithDictionary(["fn":""])
                    }
                    if let ido = item.value["id"] {
                        revItem.setValuesForKeysWithDictionary(["id":ido])
                    } else {
                        revItem.setValuesForKeysWithDictionary(["id":""])
                    }
                    if let nao = item.value["na"] {
                        revItem.setValuesForKeysWithDictionary(["na":nao])
                    } else {
                        revItem.setValuesForKeysWithDictionary(["na":""])
                    }
                    if let ratingo = item.value["ra"] {
                        revItem.setValuesForKeysWithDictionary(["ra":ratingo])
                    } else {
                        revItem.setValuesForKeysWithDictionary(["ra":""])
                    }
                    
                    
                    
                    
                    
                    revArray.append(revItem)
                }
                self.revDict = revArray.reverse()

                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    self.reviewCollectionView.reloadData()
                    
                    if self.revDict.count == 0 {
                        
                    } else {

                        self.loadingReviewImage.hidden = true
                        self.viewAllReviews.enabled = true
                        self.viewAllReviews.alpha = 1.0

                    }
                    self.reviewCountLabel.text = "\(self.revDict.count)"
                    
                    
                    // Update Own Review Score BEGIN
                    var ratingSumArray = [Double]()
                    for obj in self.revDict {
                        ratingSumArray.append(obj["ra"] as! Double)
                    }
                    let sum = ratingSumArray.reduce(0, combine: +)
                    if myDict["rs"] as! Double != sum || self.revDict.count !=  myDict["rc"] as! Int {

                        
                        let scRef = FIRDatabase.database().reference().child("st").child((FIRAuth.auth()?.currentUser?.uid)!)
                        scRef.updateChildValues(["rs":sum,"rc": self.revDict.count])
                    
                        myDict.setValuesForKeysWithDictionary(["rs":sum,"rc":self.revDict.count])
                    }
                    // Update Own Review Score END
                    
                    revRef.removeAllObservers()
                })
            })

        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == reviewCollectionView {
            return revDict.count

        } else {
        
        return portDict.count
            
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if collectionView == reviewCollectionView{
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("selfReviewCell", forIndexPath: indexPath) as! stylistReviewCollectionViewCell
            
            if let imagee = self.revDict[indexPath.row].objectForKey("us") {
                cell.cellImage.kf_setImageWithURL(NSURL(string: imagee as! String)!, placeholderImage: nil)
            } else {
                
            }
            
            if let counto = self.revDict[indexPath.row]["ra"] {
                cell.ratingView.rating = counto as! Float
                
            } else {
                cell.ratingView.rating = 0
            }
            

            return cell
        } else {
            
        
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("moreCollectionCell", forIndexPath: indexPath) as! moreCollectionViewCell
        
            if let imagee = self.portDict[indexPath.row].objectForKey("us") {
                cell.cellImage.kf_setImageWithURL(NSURL(string: imagee as! String)!, placeholderImage: nil)
            } else {
                
            }

        
        return cell
        }
    }
    
    
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "portfolioCollectionSegue"){
            
            let detailScene = segue.destinationViewController as! portfolioCollectionViewController
            detailScene.portDict = portDict
            detailScene.fromOwnProfile = true

        }
        
        if(segue.identifier == "moreToServices"){
            
            let detailScene = segue.destinationViewController as! servicePriceViewController
            
            detailScene.allowEdit = true
            
        }


        if(segue.identifier == "previewOwnProfileSegue"){
            let detailScene = segue.destinationViewController as! stylistProfileViewController
            
            detailScene.selectedDict = backoDict
            //detailScene.selectedKey = backoKey
        }
        
        if(segue.identifier == "userCreateSegue"){
            let detailScene = segue.destinationViewController as! stylistCreateViewController
            detailScene.userOrStylist = "User"
        }
        
        if(segue.identifier == "stylistCreateSegue"){
            let detailScene = segue.destinationViewController as! stylistCreateViewController
            detailScene.userOrStylist = "Stylist"
        }

        if segue.identifier == "normalUserOwnReviewsSegue" {
            let detailScene = segue.destinationViewController as! normalUserReviewViewController
            detailScene.seeingOwnReviews = true
        }
        //let detailScene = segue.destinationViewController as! normalUserReviewViewController
        
        //detailScene.revDict = self.revDict
        //barberSeeOwnReviews
        
        if segue.identifier == "barberSeeOwnReviews" {
            let detailScene = segue.destinationViewController as! normalUserReviewViewController
            detailScene.revDict = self.revDict
        }

        
    }
    
    var backoDict = NSMutableDictionary()
    
    @IBAction func previewOwnProfileAction(sender: AnyObject) {
        
        backoDict = myDict
        self.performSegueWithIdentifier("previewOwnProfileSegue", sender: self)
        
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        /*loadingLabel.text = "0%"
        self.view.addSubview(loadingLabel)
        self.view.bringSubviewToFront(loadingLabel)*/
        
        actionShowLoader()
        
        
        let imageo = UIImageView()
        //self.stylistTableView.userInteractionEnabled = false
        
        if collectionView == reviewCollectionView {
            selectedImg = revDict[indexPath.row]
            
            imageo.kf_setImageWithURL(NSURL(string: revDict[indexPath.row]["ul"] as! String)!,
                                      placeholderImage: nil,
                                      optionsInfo: nil,
                                      progressBlock: { (receivedSize, totalSize) -> () in
                                        print("Download Progress: \(receivedSize)/\(totalSize)")
                                        
                                        /*let receivedub = Double(receivedSize)
                                        let totaldub = Double(totalSize)
                                        let divide = (receivedub/totaldub) * 100
                                        let rounded = round(divide)
                                        self.loadingLabel.text = "\(rounded)%"*/
                                        
                },
                                      completionHandler: { (image, error, cacheType, imageURL) -> () in
                                        print("Downloaded and set!")
                                        //self.stylistTableView.userInteractionEnabled = true
                                        //self.loadingLabel.removeFromSuperview()
                                        
                                        if error == nil {
                                            
                                            //let saveText = self.revDict[indexPath.row]["te"] as! String
                                            //backupText = saveText
                                            let imageInfo   = GSImageInfo(image: imageo.image!, imageMode: .AspectFit)
                                            let imageViewer = GSImageViewerController(imageInfo: imageInfo)
                                            imageViewer.hidesBottomBarWhenPushed = true
                                            SwiftLoader.hide()
                                            self.showViewController(imageViewer, sender: self)
                                            
                                        } else {
                                            SwiftLoader.hide()
                                            SCLAlertView().showError("No Internet Connection", subTitle:"Try again later.", closeButtonTitle:"OK")
                                            
                                        }
                }
            )
            
            
        } else {
            
            selectedImg = portDict[indexPath.row]
            
            
            imageo.kf_setImageWithURL(NSURL(string: portDict[indexPath.row]["ul"] as! String)!,
                                      placeholderImage: nil,
                                      optionsInfo: nil,
                                      progressBlock: { (receivedSize, totalSize) -> () in
                                        print("Download Progress: \(receivedSize)/\(totalSize)")
                                        
                                        /*var receivedub = Double(receivedSize)
                                        var totaldub = Double(totalSize)
                                        var divide = (receivedub/totaldub) * 100
                                        var rounded = round(divide)*/
                                        
                                        //self.loadingLabel.text = "\(rounded)%"
                                        
                },
                                      completionHandler: { (image, error, cacheType, imageURL) -> () in
                                        print("Downloaded and set!")
                                        self.stylistTableView.userInteractionEnabled = true
                                        //self.loadingLabel.removeFromSuperview()
                                        
                                        if error == nil {
                                            
                                            //let saveText = self.portDict[indexPath.row]["te"] as! String
                                            //backupText = saveText
                                            let imageInfo   = GSImageInfo(image: imageo.image!, imageMode: .AspectFit)
                                            let imageViewer = GSImageViewerController(imageInfo: imageInfo)
                                            imageViewer.hidesBottomBarWhenPushed = true
                                            SwiftLoader.hide()
                                            self.showViewController(imageViewer, sender: self)
                                            
                                        } else {
                                            SwiftLoader.hide()
                                            SCLAlertView().showError("No Internet Connection", subTitle:"Try again later.", closeButtonTitle:"OK")
                                            
                                        }
                }
            )
            
            
            
        }
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        if textField.tag == 69
        {
            let newString = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
            let components = newString.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
            
            let decimalString = components.joinWithSeparator("") as NSString
            let length = decimalString.length
            let hasLeadingOne = length > 0 && decimalString.characterAtIndex(0) == (1 as unichar)
            
            if length == 0 || (length > 10 && !hasLeadingOne) || length > 11
            {
                let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
                
                return (newLength > 10) ? false : true
            }
            var index = 0 as Int
            let formattedString = NSMutableString()
            
            if hasLeadingOne
            {
                formattedString.appendString("1 ")
                index += 1
            }
            if (length - index) > 3
            {
                let areaCode = decimalString.substringWithRange(NSMakeRange(index, 3))
                formattedString.appendFormat("(%@)", areaCode)
                index += 3
            }
            if length - index > 3
            {
                let prefix = decimalString.substringWithRange(NSMakeRange(index, 3))
                formattedString.appendFormat("%@-", prefix)
                index += 3
            }
            
            let remainder = decimalString.substringFromIndex(index)
            formattedString.appendString(remainder)
            textField.text = formattedString as String
            return false        }
        else
        {
            return true
        }
    }
    
    
    
    @IBAction func viewAllReviews(sender: AnyObject) {
        
        self.performSegueWithIdentifier("barberSeeOwnReviews", sender: self)
        
    }
    @IBAction func gotoLikedPhotos(sender: AnyObject) {
        
        let ref = NSUserDefaults.standardUserDefaults().objectForKey("likedImages")
        if ref == nil {
            SCLAlertView().showNotice("Hold On...", subTitle: "You need to like a photo first")
        } else {
            self.performSegueWithIdentifier("moreToLiked", sender: self)
        }
        
    }
    
    
    @IBAction func miscOptionsTapped(sender: AnyObject) {
        
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: true,
            kTitleHeight: 0
        )
        
        let alert = SCLAlertView(appearance: appearance)
        
        let subview = UIView(frame: CGRectMake(0,0,0,0))
        alert.customSubview = subview
        
        let color = UIColor.blackColor()
        alert.addButton("Terms of Service", backgroundColor: color, textColor: UIColor.whiteColor(), showDurationStatus: false) {
            
        }
        
        alert.addButton("Email Support", backgroundColor:color, textColor: UIColor.whiteColor(), showDurationStatus: false) {
            
        }

        alert.addButton("Credits", backgroundColor:color, textColor: UIColor.whiteColor(), showDurationStatus: false) {
            
        }
        //MISCELLANEOUS
        let icon = UIImage(named:"menu-4-white.png")
        alert.showCustom("Miscellaneous", subTitle: "Other Options", color: color, icon: (icon)!)
        
        
    }
    
    
    // User Logged View
    @IBAction func userLikedPhotosTapped(sender: AnyObject) {
        
        let ref = NSUserDefaults.standardUserDefaults().objectForKey("likedImages")
        if ref == nil {
            SCLAlertView().showNotice("Hold On...", subTitle: "You need to like a photo first")
        } else {
            self.performSegueWithIdentifier("moreToLiked", sender: self)
        }
        
    }
    
    @IBAction func userViewSeeReviewsTapped(sender: AnyObject) {
        
        self.performSegueWithIdentifier("normalUserOwnReviewsSegue", sender: self)
    }
    
    
    
    
    
}





