//
//  termsViewController.swift
//  Hair CV
//
//  Created by Ivan Khau on 5/7/16.
//  Copyright © 2016 Peer Goggles. All rights reserved.
//

import UIKit

class termsViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    //@IBOutlet weak var backB: UIButton!
    //var backBt = true
    
    //NSBundle.mainBundle().URLForResource("Peer Goggles TOS PP Combined", withExtension:"htm")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let url = NSBundle.mainBundle().URLForResource("Peer Goggles TOS PP Combined", withExtension:"htm")
        //let request = NSURLRequest(URL: url!)
        
        
        //webView.loadRequest(request)
        
        let url = NSURL (string: "http://www.google.com")
        let requestObj = NSURLRequest(URL: url!);
        webView.loadRequest(requestObj)
        
        
        //var url:NSURL = NSURL(string: termsUrl)!
        //var req:NSURLRequest = NSURLRequest(URL: url)
        //webView.loadRequest(req)
        
        //if backBt == false {
        //    backB.hidden = false
        //}
        
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
