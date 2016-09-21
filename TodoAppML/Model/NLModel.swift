//
//  NLModel.swift
//  TodoAppML
//
//  Created by Rey Pena on 21/09/2016.
//  Copyright © 2016 Malaysia. All rights reserved.
//

import Foundation
import UIKit

extension UILabel{
    dynamic var defaultFont: UIFont? {
        get { return self.font }
        set { self.font = newValue }
    }
}

class NLModel: NSObject {
    
    /*
     On completion returns data requested from server or error if something occurs
     @block : success
     @block : failed
     */
    class func fetchTasksFromServer(success: (data : Bool) -> Void, failed: (error : NSError) -> Void) {
        let urlString = "https://dl.dropboxusercontent.com/u/6890301/tasks.json"
        
        // get data from URL
        MLDataAccessManager.dataFromServerWithURL(NSURL(string: urlString)!, success: { (data) in
            NLModel.parseTasks(data)
            success(data: true)
        }) { (error) in
            failed(error: error)
        }
    }
    
    /*
     Parse data and separate Pending and Done Tasks
     @param: data
     */
    class func parseTasks(data : AnyObject) {
        let dictionary = data.objectForKey("data") as! NSArray
        for item in dictionary {
            let task = item as! NSDictionary
            if task.objectForKey("state") as! NSNumber == 0 {
                DataModel.sharedInstance.pendingList.addObject(item)
            } else {
                DataModel.sharedInstance.doneList.addObject(item)
            }
        }
    }

}
