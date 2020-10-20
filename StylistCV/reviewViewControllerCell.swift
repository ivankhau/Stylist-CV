//
//  reviewViewControllerCell.swift
//  Hair CV
//
//  Created by Ivan Khau on 5/7/16.
//  Copyright © 2016 Peer Goggles. All rights reserved.
//

import UIKit

class reviewViewControllerCell: UITableViewCell {
    
    @IBOutlet weak var ratingView: FloatRatingView!
    
    @IBOutlet weak var reviewImage: UIImageView!
    
    @IBOutlet weak var reviewUser: UILabel!
    
    @IBOutlet weak var reviewText: UILabel!
    
    
    let GRAY_TEXT_COLOR = UIColor(white: 0.53, alpha: 1.0)
    let SEPARATOR_COLOR = UIColor(white: 0.8, alpha: 0.5)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.borderWidth = 0.25
        self.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.layer.masksToBounds = true
        
        reviewImage.layer.masksToBounds = true
        reviewImage.layer.cornerRadius = 5
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
        
}