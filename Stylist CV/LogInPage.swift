//
//  LogInPage
//  Barber CV
//
//  Created by Ivan Khau on 7/22/16.
//  Copyright © 2016 Peer Goggles. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

extension moreTableViewController {

    @IBAction func stylistRegisterAction(sender: AnyObject) {
        
        self.performSegueWithIdentifier("stylistCreateSegue", sender: self)
        
    }
    
    @IBAction func normalRegistrationAction(sender: AnyObject) {
        
        self.performSegueWithIdentifier("userCreateSegue", sender: self)
    }
    
    
    @IBAction func loginAction(sender: AnyObject) {
        
        self.performSegueWithIdentifier("toLoginSegue", sender: self)
    }



}