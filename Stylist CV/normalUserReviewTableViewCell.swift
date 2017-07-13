//
//  normalUserReviewTableViewCell.swift
//  Barber CV
//
//  Created by Ivan Khau on 7/25/16.
//  Copyright © 2016 Peer Goggles. All rights reserved.
//

import UIKit

class normalUserReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var bglabel: UILabel!
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var rating: FloatRatingView!
    @IBOutlet weak var deleteCircle: UIImageView!

    @IBOutlet weak var caption: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.bglabel.layer.masksToBounds = true
        self.bglabel.layer.cornerRadius = 5
        
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor(red: 217/255, green: 217/255, blue: 219/255, alpha: 1.0).CGColor
        
        
        // Initialization code
    }
    

    


    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
