//
//  searchViewControllerCell.swift
//  Hair Dew
//
//  Created by Ivan Khau on 4/1/16.
//  Copyright © 2016 Peer Goggles. All rights reserved.
//

//import Foundation
import UIKit

class searchViewControllerCell: UITableViewCell {
    
    @IBOutlet weak var portfolioCount: UILabel!

    @IBOutlet weak var stylistNameLabel: UILabel!
    @IBOutlet weak var stylistImage: UIImageView!
    //@IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var previewImageOne: UIImageView!
    @IBOutlet weak var previewImageTwo: UIImageView!

    
    let GRAY_TEXT_COLOR = UIColor(white: 0.53, alpha: 1.0)
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.borderColor = UIColor(red: 212/255, green: 212/255, blue: 213/255, alpha: 1.0).CGColor
        
        self.layer.borderWidth = 1
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
    func setReviewCount(count: Int) {
        if (count <= 0) {
            self.reviewCountLabel.text = "No Reviews"
        }
        else if (count == 1) {
            self.reviewCountLabel.text = "1 Review"
        }
        else {
            self.reviewCountLabel.text = String(count) + " Reviews"
        }
    }
    
    func setAddress(address: [String], neighborhoods: [String]) {
        var displayAddress = ""
        for line in address {
            if (displayAddress != "") {
                displayAddress += ", "
            }
            displayAddress += line
        }
        // Add the first neighborhood in the list
        if neighborhoods.count != 0 {
            if (displayAddress != "") {
                displayAddress += ", "
            }
            displayAddress += neighborhoods[0] + " "
        }
        self.addressLabel.text = displayAddress
    }
    /*
    func setCategories(categories: [(displayName: String, id: String)]) {
        var displayCategories = ""
        for category in categories {
            if (displayCategories != "") {
                displayCategories += ", "
            }
            displayCategories += category.displayName
        }
        self.categoriesLabel.text = displayCategories
    }*/
    /*
    func setImage(imageURL: NSURL) {
        self.stylistImage?.layer.cornerRadius = 4
        self.stylistImage?.layer.masksToBounds = true
        fadeInImageFromURL(self.businessImage, url: imageURL)
    }
    
    func setRatingImage(ratingImageURL: NSURL) {
        ratingImage.setImageWithURL(ratingImageURL)
    }*/
    
    func setBusinessName(number: Int, name: String) {
        self.stylistNameLabel.text =  String(number) + ". " + name
        self.stylistNameLabel.numberOfLines = 0
        self.stylistNameLabel.sizeToFit()
    }
    
    /*
    func fadeInImageFromURL(imageView :UIImageView, url: NSURL) {
        let request = NSURLRequest(URL: url)
        imageView.setImageWithURLRequest(request, placeholderImage: nil, success: { (request, response, image) -> Void in
            if (response == nil) {
                imageView.image = image
                return
            }
            imageView.alpha = 0.0
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                imageView.image = image
                imageView.alpha = 1.0
            })
            }, failure: nil)
    }*/

    

}