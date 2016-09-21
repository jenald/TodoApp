//
//  NLDoneViewController.swift
//  TodoAppML
//
//  Created by Rey Pena on 21/09/2016.
//  Copyright © 2016 Malaysia. All rights reserved.
//

import Foundation
import UIKit
import SwiftSpinner

class NLDoneViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let model : MLDoneVCModel = MLDoneVCModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // register tableview cell to custom NIB File
        self.tableView.registerNib(UINib(nibName: "PendingCell", bundle: nil), forCellReuseIdentifier: "PendingCell")
        
        // set table delegate and datasource
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // fetch from custom model
        self.tableView.reloadData()
    }
}

// MARK: UITableViewDataSource
extension NLDoneViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.completedListCount()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "PendingCell"
        
        // get instance of custom cell
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! MLPendingTableViewCell
        cell.delegate = self
        
        // update task label
        let task = self.model.finshedTaskList()[indexPath.row] as! NSDictionary
        cell.taskLabel.text = task["name"] as? String
        cell.data = task
        
        return cell
    }
}

// MARK: UITableViewDelegate
extension NLDoneViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // get instance of cell
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! MLPendingTableViewCell
        
        // trigger pulse animation
        cell.animateCancelButton()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        // load remove item at index
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            self.model.deleteTaskAtIndex(indexPath.row)
            self.tableView.reloadData()
        }        
    }
}

// MARK: MLPendingTableViewCellDelegate
extension NLDoneViewController : MLPendingTableViewCellDelegate {
    
    func pendingCellDidFinishCount(cell: MLPendingTableViewCell) {
        
        self.model.addTaskToPendingList(cell.data)
        
        // refresh display
        self.tableView.reloadData()
    }
    
    func pendingCellDidCancelOperation(cell: MLPendingTableViewCell) {
        cell.startCancelAnimation(false)
    }
}
