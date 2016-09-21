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
    var didFinishFetch : Bool = false
    
    let model : MLPendingVCModel = MLPendingVCModel()

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
        
        // if pending list is empty from model fetch from server
        if !self.didFinishFetch {
            // show loading animation
            SwiftSpinner.show("Fetching To Do List...").addTapHandler({
                SwiftSpinner.hide()
                }, subtitle: "Tap to hide while connecting!")

            // fetch all tasks
            NLModel.fetchTasksFromServer({ (data) in
                SwiftSpinner.hide()
                self.didFinishFetch = true
                self.tableView.reloadData()
            }) { (error) in
                print(error)
                SwiftSpinner.hide()
            }
        } else {
            // fetch from custom model
            self.tableView.reloadData()
        }
    }
    
    // MARK: IBAction
    @IBAction func didTapAddTaskButton(sender: AnyObject) {
        
        // Create instance of AlertController
        let altMessage = UIAlertController(title: "New Task", message: "What do you have in mind?", preferredStyle: UIAlertControllerStyle.Alert)
        
        // Add ADD action to Alert
        altMessage.addAction(UIAlertAction(title: "Add", style: .Default, handler: { (action) in
            
            // get text from text field
            let taskName = altMessage.textFields![0].text
            
            // create new task from text
            let newTask = NSDictionary(objects: [0,taskName!,0], forKeys: ["id","name","state"])
            
            // save to Pending List
            self.model.addNewTask(newTask)
            
            // Refresh display
            self.tableView.reloadData()
        }))
        
        // Add Cancel Button
        altMessage.addAction(UIAlertAction(title: "Cancel", style: .Destructive, handler: { (action) in
            // TODO: Handle Cancel
        }))
        
        // Add Textfield to Alert
        altMessage.addTextFieldWithConfigurationHandler { (textfield) in
            // TODO: Handle textfield
        }

        // Present alert to view
        self.presentViewController(altMessage, animated: true, completion: nil)
    }
    
}

// MARK: UITableViewDataSource
extension MLPendingViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.pendingListCount()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "PendingCell"
        
        // get instance of custom cell
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! MLPendingTableViewCell
        cell.delegate = self
        
        // update task label
        let task = self.model.pendingTaskList()[indexPath.row] as! NSDictionary
        cell.taskLabel.text = task["name"] as? String
        cell.data = task
        
        return cell
    }
}

// MARK: UITableViewDelegate
extension MLPendingViewController : UITableViewDelegate {
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
extension MLPendingViewController : MLPendingTableViewCellDelegate {
    
    func pendingCellDidFinishCount(cell: MLPendingTableViewCell) {
        
        self.model.addTaskToFinishedList(cell.data)
        
        // refresh display
        self.tableView.reloadData()
    }
    
    func pendingCellDidCancelOperation(cell: MLPendingTableViewCell) {
        cell.startCancelAnimation(false)
    }
}
