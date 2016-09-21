//
//  MLDoneVCModel.swift
//  TodoAppML
//
//  Created by Rey Pena on 21/09/2016.
//  Copyright © 2016 Malaysia. All rights reserved.
//

import UIKit
import Foundation

class MLDoneVCModel: UIViewController {
    
    /*
     Return array of finshed task list
     @return: Array
     */
    func finshedTaskList() -> NSMutableArray {
        return DataModel.sharedInstance.doneList
    }
    
    /*
     Returns number of finished tasks
     */
    func completedListCount() -> Int {
        return DataModel.sharedInstance.doneList.count
    }
    
    /*
     Transfers the task to Pending List
     @param: task
     */
    func addTaskToPendingList(task : AnyObject) {
        
        // add to Pending List
        DataModel.sharedInstance.pendingList.addObject(task)
        
        // Remove from Done List
        DataModel.sharedInstance.doneList.removeObject(task)
    }
    
    /*
     Deletes task from Done List
     @param: index
     */
    func deleteTaskAtIndex(index : Int) {
        DataModel.sharedInstance.doneList.removeObjectAtIndex(index)
    }
    
    
}
