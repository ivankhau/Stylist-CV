//
//  myFollowingTableViewCell.swift
//  Barber CV
//
//  Created by Ivan Khau on 7/27/16.
//  Copyright © 2016 Peer Goggles. All rights reserved.
//

import UIKit

class myFollowingTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var followName: UILabel!

    @IBOutlet weak var followImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        followImage.layer.masksToBounds = true
        followImage.layer.cornerRadius = followImage.frame.size.height/2
        followImage.layer.borderColor = UIColor(red: 217/255, green: 217/255, blue: 219/255, alpha: 1.0).CGColor
        followImage.layer.borderWidth = 1
        
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor(red: 217/255, green: 217/255, blue: 219/255, alpha: 1.0).CGColor
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
