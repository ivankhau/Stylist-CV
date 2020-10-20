//
//  MeasurementHelper.swift
//  Hair CV
//
//  Created by Ivan Khau on 6/17/16.
//  Copyright © 2016 Peer Goggles. All rights reserved.
//

import Firebase

class MeasurementHelper: NSObject {
    
    static func sendLoginEvent() {
        FIRAnalytics.logEventWithName(kFIREventLogin, parameters: nil)
    }
    
    static func sendLogoutEvent() {
        FIRAnalytics.logEventWithName("logout", parameters: nil)
    }
    
    static func sendMessageEvent() {
        FIRAnalytics.logEventWithName("message", parameters: nil)
    }
    
}