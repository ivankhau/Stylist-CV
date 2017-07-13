//
//  TitleViewStyle.swift
//  Hair CV
//
//  Created by Ivan Khau on 6/16/16.
//  Copyright © 2016 Peer Goggles. All rights reserved.
//

import UIKit

class TitleViewStyle: UILabel {
    
    init(text: String) {
        super.init(frame: CGRectMake(0,0,120,40))
        self.layer.backgroundColor = UIColor.clearColor().CGColor
        self.font = UIFont(name: "Georgia-Italic", size: 20)
        
        self.textColor = UIColor.darkTextColor()
        self.textAlignment = .Center
        self.text = text
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
}
