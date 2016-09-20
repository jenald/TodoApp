//
//  NLDataAccessManager.swift
//  TodoAppML
//
//  Created by Rey Pena on 20/09/2016.
//  Copyright © 2016 Malaysia. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MLDataAccessManager: NSObject {
    
    /*
        Requests data from server with URL
        @param : url
        @block : success
        @block : failed
    */
    class func dataFromServerWithURL(url : NSURL, success: (data : AnyObject) -> Void, failed: (error : NSError) -> Void) {
        Alamofire.request(.GET, url).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    success(data: json.rawValue)
                }
            case .Failure(let error):
                print(error)
                failed(error: error)
            }
        }
    }
}
