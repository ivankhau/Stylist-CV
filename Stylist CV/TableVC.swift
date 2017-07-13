//
//  TableVC.swift
//  Hair CV
//
//  Created by Ivan Khau on 4/8/16.
//  Copyright © 2016 Peer Goggles. All rights reserved.
//

import UIKit

class TableVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var table: UITableView!
    
    @IBAction func closeTableVC(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true) { 
            
        }
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.dataSource = self
        table.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TableVC.reloadTable(_:)), name: "reloadData", object: nil)
        
        DataService.inst.loadData()
    }
    
    func reloadTable(notif: AnyObject) {
        table.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataService.inst.dataList.count
        
        
        
        
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellOld = tableView.dequeueReusableCellWithIdentifier("PicsCell") as? PicsCell
        
        let cell = cellOld != nil ? cellOld! : PicsCell()
        
        cell.initializeCell(DataService.inst.dataList[indexPath.row])
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedPic = DataService.inst.dataList[indexPath.row]
        let view = ImageVC(pic: selectedPic)
        
        presentViewController(view, animated: true, completion: nil)
    }
    
}
