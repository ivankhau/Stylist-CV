//
//  ImageVC.swift
//  Hair CV
//
//  Created by Ivan Khau on 4/8/16.
//  Copyright © 2016 Peer Goggles. All rights reserved.
//

import UIKit

class ImageVC: UIViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    
    private var _img: UIImage?
    private var _title: String?
    private var _desc: String?
    
    convenience init(pic: Pics) {
        self.init(nibName: "ImageVC", bundle: nil)
        
        let img = DataService.inst.imageForName(pic.img)
        
        _img = img
        _title = pic.title
        _desc = pic.desc
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgView.image = _img
        titleLbl.text = _title
        descLbl.text = _desc
    }
    
    @IBAction func closeBtn(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}