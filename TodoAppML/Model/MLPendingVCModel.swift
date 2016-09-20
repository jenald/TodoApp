//
//  NLPendingVCModel.swift
//  TodoAppML
//
//  Created by Rey Pena on 20/09/2016.
//  Copyright © 2016 Malaysia. All rights reserved.
//

import UIKit

class MLPendingVCModel: NSObject {
    
    /*
        On completion returns data requested from server or error if something occurs
        @block : success
        @block : failed
     */
    class func listOfPendingTasks(success: (data : AnyObject?) -> Void, failed: (error : NSError) -> Void) {
        let urlString = "https://dl.dropboxusercontent.com/u/6890301/tasks.json"
        
        // get data from URL
        MLDataAccessManager.dataFromServerWithURL(NSURL(string: urlString)!, success: { (data) in
            success(data: data)
            }) { (error) in
            failed(error: error)
        }        
    }
}
