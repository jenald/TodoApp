//
//  NLPendingVCModel.swift
//  TodoAppML
//
//  Created by Rey Pena on 20/09/2016.
//  Copyright © 2016 Malaysia. All rights reserved.
//

import UIKit
import SugarRecord
//typealias Task = (
//    id : String?,
//    task : String?
//)

class MLPendingVCModel: NSObject {
    
    /*
     Return array of Pending task list
     @return: Array
     */
    func pendingTaskList() -> NSMutableArray {
        return DataModel.sharedInstance.pendingList
    }
    
    /*
     Returns number of Pending tasks
     */
    func pendingListCount() -> Int {
        return DataModel.sharedInstance.pendingList.count
    }

    
    /*
     Transfers the task to Done List
     @param: task
     */
    func addTaskToFinishedList(task : AnyObject) {
        
        // add to DOne List
        DataModel.sharedInstance.doneList.addObject(task)
        
        // Remove from Pending List
        DataModel.sharedInstance.pendingList.removeObject(task)
    }
    
    /*
     Adds a new Pending task
     @param: task
     */
    func addNewTask(task : AnyObject) {
        DataModel.sharedInstance.pendingList.addObject(task)
    }
    
    /*
     Deletes task from Pending List
     @param: index
     */
    func deleteTaskAtIndex(index : Int) {
        DataModel.sharedInstance.pendingList.removeObjectAtIndex(index)
    }

}
