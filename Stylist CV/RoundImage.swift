//
//  RoundImage.swift
//  Hair CV
//
//  Created by Ivan Khau on 4/8/16.
//  Copyright © 2016 Peer Goggles. All rights reserved.
//

import UIKit

class RoundImage: UIImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = self.bounds.width / 2
        clipsToBounds = true
    }
    
}
