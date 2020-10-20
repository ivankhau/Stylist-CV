//
//  conversationListTableViewCell.swift
//  Hair CV
//
//  Created by Ivan Khau on 7/20/16.
//  Copyright © 2016 Peer Goggles. All rights reserved.
//

import UIKit

class conversationListTableViewCell: UITableViewCell {
    @IBOutlet weak var lastMessage: UILabel!
    @IBOutlet weak var userImage: UIImageView!

    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var deleteImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImage.layer.cornerRadius = userImage.frame.size.height/2
        userImage.layer.masksToBounds = true
        
        //self.layer.borderWidth = 1
        //self.layer.borderColor = UIColor(red: 217/255, green: 217/255, blue: 219/255, alpha: 1.0).CGColor
        
        
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
