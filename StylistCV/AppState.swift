//
//  AppState.swift
//  Hair CV
//
//  Created by Ivan Khau on 7/20/16.
//  Copyright © 2016 Peer Goggles. All rights reserved.
//

import Foundation

class AppState: NSObject {
    
    static let sharedInstance = AppState()
    
    var signedIn = false
    var displayName: String?
    var photoUrl: NSURL?
}



