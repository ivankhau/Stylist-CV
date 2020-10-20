//
//  servicePriceTableViewCell.swift
//  Hair CV
//
//  Created by Ivan Khau on 7/15/16.
//  Copyright © 2016 Peer Goggles. All rights reserved.
//

import UIKit

class servicePriceTableViewCell: UITableViewCell {

    @IBOutlet weak var serviceName: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //self.layer.borderWidth = 1
        //self.layer.borderColor = UIColor(red: 217/255, green: 217/255, blue: 219/255, alpha: 1).CGColor
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
