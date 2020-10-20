//
//  Pics.swift
//  Hair CV
//
//  Created by Ivan Khau on 4/8/16.
//  Copyright © 2016 Peer Goggles. All rights reserved.
//

import Foundation
import UIKit

class Pics: NSObject, NSCoding {
    private var _img: String!
    private var _title: String!
    private var _desc: String!
    
    var img: String {
        return _img
    }
    
    var title: String {
        return _title
    }
    
    var desc: String {
        return _desc
    }
    
    init(img: String, title: String, description: String) {
        _img = img
        _title = title
        _desc = description
    }
    
    override init() {
        
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init()
        self._img = aDecoder.decodeObjectForKey("img") as? String
        self._title = aDecoder.decodeObjectForKey("title") as? String
        self._desc = aDecoder.decodeObjectForKey("desc") as? String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self._img, forKey: "img")
        aCoder.encodeObject(self._title, forKey: "title")
        aCoder.encodeObject(self._desc, forKey: "desc")
    }
    
}
