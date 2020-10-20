//
//  reviewStylistTableViewCell.swift
//  Hair CV
//
//  Created by Ivan Khau on 4/13/16.
//  Copyright © 2016 Peer Goggles. All rights reserved.
//

import UIKit

class reviewStylistTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var reviewView: FloatRatingView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var userReview: UILabel!
    
    @IBOutlet weak var cellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.userImage.layer.cornerRadius = 5
        self.userImage.layer.masksToBounds = true
        
        self.cellView.layer.borderColor = UIColor.whiteColor().CGColor
        self.cellView.layer.borderWidth = 1.5
        self.cellView.layer.masksToBounds = true

        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
