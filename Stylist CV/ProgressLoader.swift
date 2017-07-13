//
//  ProgressLoader.swift
//  Hair CV
//
//  Created by Ivan Khau on 7/11/16.
//  Copyright © 2016 Peer Goggles. All rights reserved.
//

import UIKit

class ProgressLoader: UILabel {
    
    init(text: String) {
        super.init(frame: CGRectMake(phonewidth/2 - 50, phoneheight/2 - 100, 100, 45))
        self.hidden = false
        self.layer.backgroundColor = UIColor.blackColor().CGColor
        //self.font = UIFont(name: "Georgia-Italic", size: 18)
        self.alpha = 0.9
        self.textColor = UIColor.whiteColor()
        self.textAlignment = .Center
        self.text = text
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
}
