//
//  servicePriceViewController.swift
//  Hair CV
//
//  Created by Ivan Khau on 7/15/16.
//  Copyright © 2016 Peer Goggles. All rights reserved.
//

import UIKit
import Firebase

class servicePriceViewController: UIViewController, UITableViewDelegate {
    
    var servDict = [NSMutableDictionary]()
    //var uidArray = [String]()
    var selectedKey = String()
    
    var allowEdit = false
    
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func addButtonTapped(sender: AnyObject) {
        
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: true
        )

        let alert = SCLAlertView(appearance: appearance)

        let textfield1 = alert.addTextField("Service Name")
        let textfield2 = alert.addTextField("Price")
        
        var ftext = ""
        var ltext = ""
        
        if self.servDict.count == 0 {
            
            ftext = "Women's Haircut"
            textfield1.userInteractionEnabled = false
            
            textfield1.backgroundColor = UIColor(red: 227/255, green: 228/255, blue: 232/255, alpha: 1.0)
            
        } else if self.servDict.count == 1 {
            
            ftext = "Men's Haircut"
            textfield1.userInteractionEnabled = false

            textfield1.backgroundColor = UIColor(red: 227/255, green: 228/255, blue: 232/255, alpha: 1.0)
            
        } else {
            
        }

        textfield1.text = ftext
        textfield2.text = ltext
        
        textfield1.keyboardType = .ASCIICapable
        textfield2.keyboardType = .NumberPad
    
        alert.addButton("Add") {
            if textfield1.text?.characters.count > 2 && textfield2.text?.characters.count > 0 {
                
                let spuid = NSUUID().UUIDString
                
                let pfRef = database.reference().child("pr").child(FIRAuth.auth()!.currentUser!.uid)
                pfRef.child(spuid).setValue(["se": "\(textfield1.text!)", "pr": "\(textfield2.text!)", "rf":spuid], withCompletionBlock: { (error, FIRDatabaseReference) in
                    
                    let servObj: NSMutableDictionary = ["se": "\(textfield1.text!)", "pr": "\(textfield2.text!)", "rf":spuid]
                    self.servDict.append(servObj)
                    self.tableView.reloadData()
                    
                    if textfield1.text == "Women's Haircut" {
                        let pfRef = database.reference().child("st").child(FIRAuth.auth()!.currentUser!.uid)
                    
                        if Int(textfield2.text!) < 20 {
                            
                            pfRef.child("pr").setValue("$")
                        } else if Int(textfield2.text!) > 20 && Int(textfield2.text!) < 41 {
                            pfRef.child("pr").setValue("$$")

                        } else {
                            pfRef.child("pr").setValue("$$$")

                        }
                    }
                })

            } else {
                SCLAlertView().showError("Hold On...", subTitle:"Enter a service name and price.", closeButtonTitle:"OK")
            }
        }
        
        alert.showCustom("Add Service", subTitle: "Enter a service and price below.", color: UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 128 / 255.0, alpha: 1.0), icon: UIImage(named: "scissors-opened-tool.png")!)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatTitle()
        
        if allowEdit == false {
            self.tableView.allowsSelection = false
            self.addButton.enabled = false
            self.addButton.tintColor = UIColor.clearColor()

        }
        
        var typo = String()
        
        if allowEdit == true {
            typo = FIRAuth.auth()!.currentUser!.uid
        } else {
            typo = selectedKey
        }
        
        
        let queryRef = FIRDatabase.database().reference().child("pr").child(typo)
        queryRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in
            
            var servDictArray = [NSMutableDictionary]()
            
            for item in snapshot.children {
                
                let servObject = NSMutableDictionary()
                
                if let servico = item.value!["se"] {
                    servObject.setValuesForKeysWithDictionary(["se":servico])
                } else {
                    servObject.setValuesForKeysWithDictionary(["se":""])
                }
                if let priceo = item.value!["pr"] {
                    servObject.setValuesForKeysWithDictionary(["pr":priceo])
                } else {
                    servObject.setValuesForKeysWithDictionary(["pr":""])

                }
                if let refo = item.value!["rf"] {
                    servObject.setValuesForKeysWithDictionary(["rf":refo])
                } else {
                    servObject.setValuesForKeysWithDictionary(["rf":""])
                }
                servDictArray.append(servObject)
                
            }
            
            self.servDict = servDictArray
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()

                print(self.servDict)
                //print(self.uidArray)
            })
            
            queryRef.removeAllObservers()

        })

    }
    
    func formatTitle() {
        let titleLabel = UILabel()
        titleLabel.frame.size.height = 40
        titleLabel.frame.size.width = 120
        titleLabel.font = UIFont.init(name: "Georgia-Italic", size: 22)
        titleLabel.textColor = UIColor.darkTextColor()
        titleLabel.textAlignment = .Center
        titleLabel.text = "Services & Price"
        self.navigationItem.titleView = titleLabel
        
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return servDict.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("servicePriceCell", forIndexPath: indexPath) as! servicePriceTableViewCell
        
        if let servo = servDict[indexPath.row]["se"] {
            
            cell.serviceName.text = (servo as! String)
            
        }
        
        if let priceo = servDict[indexPath.row]["pr"] {
            
            cell.price.text = "$\(priceo as! String)"
            
        } else {
            
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        
        
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: true
        )
        
        // Initialize SCLAlertView using custom Appearance
        let alert = SCLAlertView(appearance: appearance)
        
        let textfield1 = alert.addTextField("Service Name")
        let textfield2 = alert.addTextField("Price")
        
        textfield1.text = "\(servDict[indexPath.row]["se"]!)"
        
        textfield2.text = "\(servDict[indexPath.row]["pr"]!)"
        
        textfield1.keyboardType = .ASCIICapable
        textfield2.keyboardType = .NumberPad
        
        if indexPath.row < 2 {
            textfield1.backgroundColor = UIColor(red: 227/255, green: 228/255, blue: 232/255, alpha: 1.0)
            textfield1.userInteractionEnabled = false
            
        }
        
        alert.addButton("Change") {
            
            if textfield1.text?.characters.count > 2 && textfield2.text?.characters.count > 0 {
                let queryRef = FIRDatabase.database().reference().child("pr").child(FIRAuth.auth()!.currentUser!.uid).child(self.servDict[indexPath.row]["rf"] as! String)
                queryRef.setValue(["se": "\(textfield1.text!)", "pr": "\(textfield2.text!)"], withCompletionBlock: { (error, FIRDatabaseReference) in
                
                
                    self.servDict[indexPath.row].setValuesForKeysWithDictionary(["se": "\(textfield1.text!)", "pr": "\(textfield2.text!)"])
                
                    self.tableView.reloadData()
                    
                    if textfield1.text == "Women's Haircut" {
                        let pfRef = database.reference().child("st").child(FIRAuth.auth()!.currentUser!.uid)
                        
                        if Int(textfield2.text!) < 20 {
                            
                            pfRef.child("pr").setValue("$")
                            
                            myDict.setValuesForKeysWithDictionary(["pr":"$"])
                            
                        } else if Int(textfield2.text!) > 20 && Int(textfield2.text!) < 41 {
                            pfRef.child("pr").setValue("$$")
                            myDict.setValuesForKeysWithDictionary(["pr":"$$"])
                            
                        } else {
                            pfRef.child("pr").setValue("$$$")
                            myDict.setValuesForKeysWithDictionary(["pr":"$$$"])
                            
                        }
                        
                    }

                    
                })
            } else {
                SCLAlertView().showError("Hold On...", subTitle:"Enter a service name and price.", closeButtonTitle:"OK")
            }
        }
        
        if indexPath.row > 1 {
            alert.addButton("Delete", backgroundColor: UIColor(red: 128 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 1.0), textColor: UIColor.whiteColor(), showDurationStatus: false) {
            
                
                let queryRef = FIRDatabase.database().reference().child("pr").child(FIRAuth.auth()!.currentUser!.uid).child(self.servDict[indexPath.row]["rf"] as! String)
                
                queryRef.removeValueWithCompletionBlock({ (error, FIRDatabaseReference) in
                    
                    self.servDict.removeAtIndex(indexPath.row)
                    
                    self.tableView.reloadData()
                    
                })
                
                
            }
            
        }
        
        alert.showCustom("Edit Service", subTitle: "Make changes below.", color: UIColor.darkGrayColor(), icon: UIImage(named: "settings.png")!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    


}
