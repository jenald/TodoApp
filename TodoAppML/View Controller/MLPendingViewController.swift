//
//  MLPendingViewController.swift
//  TodoAppML
//
//  Created by Rey Pena on 20/09/2016.
//  Copyright © 2016 Malaysia. All rights reserved.
//

import UIKit
import SwiftSpinner
import SnapKit

class MLPendingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var taskList : Array<AnyObject>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // register tableview cell to custom NIB File
        self.tableView.registerNib(UINib(nibName: "PendingCell", bundle: nil), forCellReuseIdentifier: "PendingCell")
        
        // initialize task list array
        self.taskList = []
        
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
        
        // show loading animation
        SwiftSpinner.show("Fetching To Do List...").addTapHandler({
            SwiftSpinner.hide()
            }, subtitle: "Tap to hide while connecting!")
        
        // fetch pending task list
        MLPendingVCModel.listOfPendingTasks({ (data) in
                SwiftSpinner.hide()
                self.taskList = data
                self.tableView.reloadData()
            }) { (error) in
                print(error)
                SwiftSpinner.hide()
        }
    }
}

extension MLPendingViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.taskList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "PendingCell"
        
        // get instance of custom cell
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! MLPendingTableViewCell
        cell.delegate = self
        
        // update task label
        let task = self.taskList[indexPath.row] as! NSDictionary
        cell.taskLabel.text = task["name"] as? String
        
        return cell
    }
}

extension MLPendingViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! MLPendingTableViewCell
        
        cell.animateCancelButton()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
}

extension MLPendingViewController : MLPendingTableViewCellDelegate {
    
    func pendingCellDidFinishCount(cell: MLPendingTableViewCell) {
        
    }
    
    func pendingCellDidCancelOperation(cell: MLPendingTableViewCell) {
        cell.startCancelAnimation(false)
    }
}
