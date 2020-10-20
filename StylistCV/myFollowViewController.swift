//
//  myFollowViewController.swift
//  Barber CV
//
//  Created by Ivan Khau on 7/27/16.
//  Copyright © 2016 Peer Goggles. All rights reserved.
//

import UIKit

class myFollowViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        formatTitle()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    func formatTitle() {
        let titleLabel = UILabel()
        titleLabel.frame.size.height = 40
        titleLabel.frame.size.width = 120
        titleLabel.font = UIFont(name: "Georgia-Italic", size: 22)
        titleLabel.textColor = UIColor.darkTextColor()
        titleLabel.textAlignment = .Center
        titleLabel.text = "My Followed"
        self.navigationItem.titleView = titleLabel
        
        
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myFollowing.count
        
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("myfollowcell", forIndexPath: indexPath) as! myFollowingTableViewCell
        
        
        if let imgo = myFollowing[indexPath.row]["iu"] {
            
            cell.followImage.kf_setImageWithURL(NSURL(string: imgo as! String)!, placeholderImage: nil)
        } else {
            cell.followImage.image = UIImage(named: "women-hair.png")
        }
        
        
        if let nameo = myFollowing[indexPath.row]["fn"] {
            
            let lnameo = myFollowing[indexPath.row]["ln"] as! String
            cell.followName.text = "\(nameo as! String) \(lnameo)"
            
        }
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        
        return cell
    }
    
    var selectedFollowee = NSMutableDictionary()
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        actionShowLoader()
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let styRef = queryRef.child("st").child(myFollowing[indexPath.row]["uid"] as! String)
        
        styRef.observeSingleEventOfType(.Value, withBlock: { (styRefo) in
            
            self.selectedFollowee = styRefo.value as! NSMutableDictionary
            
            self.selectedFollowee.setValuesForKeysWithDictionary(["uid":myFollowing[indexPath.row]["uid"] as! String])
            
            styRef.removeAllObservers()
            
            dispatch_async(dispatch_get_main_queue(), {
                
                SwiftLoader.hide()
                
                self.performSegueWithIdentifier("myFollowToProfile", sender: self)
                

            })
            
            }) { (error) in
                
                SwiftLoader.hide()
                
        }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "myFollowToProfile" {
            let detailScene = segue.destinationViewController as! stylistProfileViewController
            detailScene.selectedDict = selectedFollowee
        }
    }


}
