//
//  likedViewController.swift
//  Hair CV
//
//  Created by Ivan Khau on 7/14/16.
//  Copyright © 2016 Peer Goggles. All rights reserved.
//

import UIKit
import Kingfisher

class likedViewController: UIViewController {
    
    
    var cameFromMessages:Bool = false
    

    @IBOutlet weak var likedCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        formatTitle()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        self.likedCollectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func formatTitle() {
        let titleLabel = UILabel()
        titleLabel.frame.size.height = 40
        titleLabel.frame.size.width = 120
        titleLabel.font = UIFont(name: "Georgia-Italic", size: 22)
        titleLabel.textColor = UIColor.darkTextColor()
        titleLabel.textAlignment = .Center
        titleLabel.text = "Liked Photos"
        self.navigationItem.titleView = titleLabel
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let ref = NSUserDefaults.standardUserDefaults().objectForKey("likedImages")
        let arrayo = ref as! [NSString]
        return arrayo.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("likecell", forIndexPath: indexPath) as! likedCollectionViewCell
            
        let ref = NSUserDefaults.standardUserDefaults().objectForKey("likedImages")
        let arrayo = ref as! [NSString]
        
        
            cell.likedImage.kf_setImageWithURL(NSURL(string: arrayo[indexPath.row] as String)!, placeholderImage: nil)
            
            
            return cell
        
        
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        
            return CGSize(width: likedCollectionView.frame.size.width/2 - 1, height: likedCollectionView.frame.size.width/2 - 1)
        
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        //let cell = collectionView.dequeueReusableCellWithReuseIdentifier("likecell", forIndexPath: indexPath) as! likedCollectionViewCell
        
        
        let ref = NSUserDefaults.standardUserDefaults().objectForKey("likedImages")
        let arrayo = ref as! [NSString]
        let imageo = UIImageView()
        
        if cameFromMessages == false {
        imageo.kf_setImageWithURL(NSURL(string:arrayo[indexPath.row] as String)!)
        selectedImg = ["ul":arrayo[indexPath.row]]
        let imageInfo   = GSImageInfo(image: imageo.image!, imageMode: .AspectFit)
        let imageViewer = GSImageViewerController(imageInfo: imageInfo)
        imageViewer.hidesBottomBarWhenPushed = true
        self.presentViewController(imageViewer, animated: true, completion: nil)
        } else {
            
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: true
            )
            let alert = SCLAlertView(appearance: appearance)
            let subview = UIView(frame: CGRectMake(0,0,216,120))
            let imgo = UIImageView(frame: CGRectMake(216/2 - 55,10,110,110))
            imgo.layer.borderColor = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 128 / 255.0, alpha: 1.0).CGColor
            imgo.layer.borderWidth = 1.0
            
            imgo.kf_setImageWithURL(NSURL(string:arrayo[indexPath.row] as String)!)
            subview.addSubview(imgo)
            
            alert.customSubview = subview
            alert.addButton("Yes, Send Now") {
                selectedImageToSend = arrayo[indexPath.row] as String
                self.navigationController!.popViewControllerAnimated(true)

                
            }
            
            let icon = UIImage(named:"send.png")
            alert.showCustom("Send This Image?", subTitle: "", color: UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 128 / 255.0, alpha: 1.0), icon: (icon)!)
        }
    }
    
}
