//
//  chatMessageTableViewCell.swift
//  Barber CV
//
//  Created by Ivan Khau on 7/21/16.
//  Copyright © 2016 Peer Goggles. All rights reserved.
//

import UIKit

class chatMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var imageHeight: NSLayoutConstraint!

    @IBOutlet weak var imageHeight2: NSLayoutConstraint!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var sentImage: UIImageView!

    @IBOutlet weak var behindMessage: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var behindMessage2: UILabel!
    @IBOutlet weak var messageLabel2: UILabel!
    
    @IBOutlet weak var sentImage2: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        behindMessage.layer.cornerRadius = 8
        behindMessage.layer.masksToBounds = true
        
        behindMessage2.layer.cornerRadius = 8
        behindMessage2.layer.masksToBounds = true


        
        sentImage.layer.cornerRadius = 8
        sentImage.layer.masksToBounds = true
        sentImage2.layer.cornerRadius = 8
        sentImage2.layer.masksToBounds = true

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
