//
//  pictureFilterViewController.swift
//  Hair CV
//
//  Created by Ivan Khau on 5/26/16.
//  Copyright © 2016 Peer Goggles. All rights reserved.
//

import UIKit

class pictureFilterViewController: UIViewController {
    
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!

    var usernameArray = [String]()
    var selectedArray = [String]()

    var avgArray = [Double]()
    var countArray = [Int]()

    @IBOutlet weak var filterButton: UIButton!

    @IBOutlet weak var filterBackButton: UIButton!

    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var filterTableView: UITableView!
    
    
    @IBOutlet weak var promptLabel: UILabel!
    
    @IBOutlet weak var filterCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibs()
        
        filterBackButton.hidden = true
        tableViewTopConstraint.constant = filterCollectionView.frame.size.height
        
        //tableViewTopConstraint.constant = 0
        
        customizeObjects()
        
        //let shuffle = stylistObjects.shuffle()
        
        /*for sub in shuffle {
            
            //let subInt = sub["subscribed"] as! Int
            
            if sub["subscribed"] as! Int == 1 {
                
                if let picOne = sub["imagepreviewone"] {
                    
                    sideImageArray.append(picOne as! PFFile)
                    
                    
                    //if usernameArray.contains(sub["originalEmail"] as! String) {
                    //} else {
                    usernameArray.append(sub["originalEmail"] as! String)
                    //}
                    
                }
                
                if let picTwo = sub["imagepreviewtwo"] {
                    sideImageArray.append(picTwo as! PFFile)
                    usernameArray.append(sub["originalEmail"] as! String)


                }
                
                filterCollectionView.reloadData()
                print(usernameArray)
            }
            
        }*/
            
    }
    
    func registerNibs() {
        let businessCellNib = UINib(nibName: "searchViewControllerCell", bundle: nil);
        filterTableView.registerNib(businessCellNib, forCellReuseIdentifier: "searchCell")
        filterTableView.estimatedRowHeight = 75
        filterTableView.rowHeight = UITableViewAutomaticDimension
        filterTableView.separatorStyle = .None
    }

    
    func customizeObjects() {
        promptLabel.layer.borderWidth = 1
        promptLabel.layer.borderColor = SEPARATOR_COLOR.CGColor
        //promptLabel.layer.cornerRadius = 0
        promptLabel.layer.masksToBounds = true
    
        filterButton.hidden = true
        
        let titleLabel = UILabel()
        titleLabel.frame.size.height = 40
        titleLabel.frame.size.width = 120
        titleLabel.font = UIFont(name: "AvenirNext-Medium", size: 22)
        titleLabel.textColor = UIColor.darkTextColor()
        titleLabel.textAlignment = .Center
        titleLabel.text = "Hairdo Filter"
        self.navigationItem.titleView = titleLabel
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return stylistObjects.count
        //return sideImageArray.count
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("photoFilterCell", forIndexPath: indexPath) as! photoFilterCollectionViewCell
            
            /*if let finalImage = stylistObjects[indexPath.row]["imageSmall"] as? PFFile {
                finalImage.getDataInBackgroundWithBlock {
                    (imageData: NSData?, error: NSError?) -> Void in
                    if error == nil {
                        if let imageData = imageData {
                            cell.image.image = UIImage(data:imageData)
                            
                        }
                    }
                }
            }*/
        
        /*let finalImage = sideImageArray[indexPath.row]
            finalImage.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        cell.image.image = UIImage(data:imageData)
                        
                    }
                }
            }*/
        

        
            return cell
        
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        

            let collectionViewSize = filterCollectionView.frame.size.width/3 - 2
            
            
            return CGSize(width: collectionViewSize, height: collectionViewSize)
        
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        
        print("FASFASDF")
        
        if cell!.layer.borderWidth == 0 {
            cell!.layer.borderWidth = 9.0
            cell!.layer.borderColor = UIColor(red: 76 / 255.0, green: 106 / 255.0, blue: 146 / 255.0, alpha: 0.8).CGColor

            selectedArray.append(usernameArray[indexPath.row])
            print(selectedArray)
        
        } else {
            cell!.layer.borderWidth = 0
            cell!.layer.borderColor = UIColor.lightGrayColor().CGColor
            
            if let index = selectedArray.indexOf(usernameArray[indexPath.row]) {
                selectedArray.removeAtIndex(index)
                print(selectedArray)

            }


        }
        
        if selectedArray.count == 0 {
            //topConstraint.constant = 50
            //bottomConstraint.constant = 0
            filterButton.hidden = true
            
            

        } else {
            //topConstraint.constant = 0
            //bottomConstraint.constant = 48
            filterButton.hidden = false
        }
        
        UIView.animateWithDuration(0.20) {
            self.view.layoutIfNeeded()
        }

    }
    @IBAction func closeTableView(sender: AnyObject) {
        self.view.userInteractionEnabled = false
        let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            self.view.userInteractionEnabled = true
        })
        filterBackButton.hidden = true
        filterButton.hidden = false
        tableViewTopConstraint.constant = filterCollectionView.frame.size.height
        UIView.animateWithDuration(0.30) {
            self.view.layoutIfNeeded()
            
        }
        
    }
    
    @IBAction func filterShowTableView(sender: AnyObject) {
        
        //tableObjectArray.removeAll(keepCapacity: true)
        avgArray.removeAll()
        countArray.removeAll()

        
        filterBackButton.hidden = false
        filterButton.hidden = true
        self.view.userInteractionEnabled = false
        let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            self.view.userInteractionEnabled = true
        })

        tableViewTopConstraint.constant = 0
        //let array = selectedArray
        //let unique = Array(Set(array))
        
        UIView.animateWithDuration(0.30) {
            self.view.layoutIfNeeded()

        }

        
        /*for object in stylistObjects {
            
            for selected in unique {
                
                if object["originalEmail"] as! String == selected {
                    
                    if object["reviewCount"] == nil {
                        
                        self.avgArray.append(0)
                        self.countArray.append(0)
                        
                    } else {
                        
                        let sum = object["reviewSum"] as! Double
                        let count = object["reviewCount"] as! Double
                        let daAVG = sum/count
                        
                        
                        self.avgArray.append(daAVG)
                        self.countArray.append(Int(count))
                        
                    }
                    
                    self.tableObjectArray.append(object)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.filterTableView.reloadData()
                        
                    })

                    
                    
                }
                
            }
            
            
            
        }*/
        
        
        
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //return tableObjectArray.count
        return 0
        
        
        
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("searchCell", forIndexPath: indexPath) as! searchViewControllerCell
        
        
        
        /*if let finalImage = tableObjectArray[indexPath.row]["imageSmall"] as? PFFile {
            finalImage.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        cell.stylistImage.image = UIImage(data:imageData)
                    }
                }
            }
        }
        
        if let finalImage = tableObjectArray[indexPath.row]["imagepreviewone"] as? PFFile {
            finalImage.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        cell.previewImageOne.image = UIImage(data:imageData)
                    }
                }
            }
        }
        
        if let finalImage = tableObjectArray[indexPath.row]["imagepreviewtwo"] as? PFFile {
            finalImage.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        cell.previewImageTwo.image = UIImage(data:imageData)
                    }
                }
            }
        }
        
        
        
        if let nameConvert = tableObjectArray[indexPath.row]["name"] {
            //cell.setBusinessName(indexPath.row+1, name: String(nameConvert))
            
            cell.stylistNameLabel.text = String(nameConvert)
            
        }
        
        if let locationDict = tableObjectArray[indexPath.row]["addressDict"] {
            
            let convertDict = locationDict as! NSMutableDictionary
            
            //if convertDict["Street"] != nil {
            
            var street = ""
            
            if convertDict["Street"] != nil {
                street = convertDict["Street"] as! String
            } else {
                street = ""
            }
            
            var city = ""
            
            if convertDict["City"] != nil {
                city = convertDict["City"] as! String
            } else {
                city = ""
            }
            
            //let city = convertDict["City"] as! String
            
            var state = ""
            
            if convertDict["State"] != nil {
                state = convertDict["State"] as! String
            } else {
                state = ""
            }
            
            //let state = convertDict["State"] as! String
            cell.addressLabel.text = "\(street)\r\(city) \(state)"
        }
        
        cell.numberLabel.text = "\(indexPath.row+1)"
        
        cell.reviewCountLabel.text = "\(countArray[indexPath.row]) reviews"
        cell.ratingView.rating = Float(avgArray[indexPath.row])
        //print(avgArray)
        cell.aboutLabel.text = tableObjectArray[indexPath.row]["about"] as! String*/
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        /*backupReviewAVG = avgArray[indexPath.row]
        backupReviewCount = countArray[indexPath.row]
        selectedObject = stylistObjects[indexPath.row]
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if currentuser != nil {
            
            print("!=nil")
            print(String(currentuser!.objectForKey("username")!))
            print(String(stylistObjects[indexPath.row]["originalEmail"]!))
            
            if String(currentuser!.objectForKey("username")!) == String(stylistObjects[indexPath.row]["originalEmail"]!) {
                
                print("==")
                
                selfViewFromSearch = true
            }
        }
        self.performSegueWithIdentifier("photoFilterToStylistSegue", sender: self)*/
    }
    
}

extension Array where Element : Equatable {
    var unique: [Element] {
        var uniqueValues: [Element] = []
        forEach { item in
            if !uniqueValues.contains(item) {
                uniqueValues += [item]
            }
        }
        return uniqueValues
    }
}