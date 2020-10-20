//
//  activityObject.swift
//  Stylist CV
//
//  Created by Ivan Khau on 8/4/16.
//  Copyright © 2016 Peer Goggles. All rights reserved.
//

import Firebase

class activityObject: NSObject {
    var us: String
    var ul :String
    var ge: String
    let ref: FIRDatabaseReference?
    
    init(urlSmall: String, urlLarge: String, gender: String) {
        self.us = urlSmall
        self.ul = urlLarge
        self.ge = gender
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        us = (snapshot.value!["us"] as? String)!
        ul = (snapshot.value!["ul"] as? String)!
        ge = (snapshot.value!["ge"] as? String)!
        ref = snapshot.ref
    }
    
    convenience override init() {
        self.init(urlSmall:"",urlLarge: "", gender: "")
    }
}