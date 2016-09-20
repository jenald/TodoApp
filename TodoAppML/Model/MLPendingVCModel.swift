//
//  NLPendingVCModel.swift
//  TodoAppML
//
//  Created by Rey Pena on 20/09/2016.
//  Copyright © 2016 Malaysia. All rights reserved.
//

import UIKit

//typealias Task = (
//    id : String?,
//    task : String?
//)

class MLPendingVCModel: NSObject {
    
    /*
        On completion returns data requested from server or error if something occurs
        @block : success
        @block : failed
     */
    class func listOfPendingTasks(success: (data : Array<AnyObject>) -> Void, failed: (error : NSError) -> Void) {
        let urlString = "https://dl.dropboxusercontent.com/u/6890301/tasks.json"
        
        // get data from URL
        MLDataAccessManager.dataFromServerWithURL(NSURL(string: urlString)!, success: { (data) in
            let tasksList = MLPendingVCModel.parsePendingTasksOnly(data)
            success(data: tasksList!)
            }) { (error) in
            failed(error: error)
        }
    }
    
    
    class func parsePendingTasksOnly(data : AnyObject) -> Array<AnyObject>? {
        let dictionary = data.objectForKey("data") as! NSArray
        var tasks = Array<AnyObject>()
        for item in dictionary {
            let task = item as! NSDictionary
            if task.objectForKey("state") as! NSNumber == 0 {
                tasks.append(task)
            }
        }
        
        return tasks
    }
}
