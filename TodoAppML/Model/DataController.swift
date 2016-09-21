//
//  DataController.swift
//  TodoAppML
//
//  Created by Rey Pena on 21/09/2016.
//  Copyright © 2016 Malaysia. All rights reserved.
//

import UIKit
import Foundation

private let sharedModel = DataModel()
class DataModel {
    
    var pendingList : NSMutableArray = []
    var doneList : NSMutableArray = []
    
    class var sharedInstance: DataModel {
        
        return sharedModel
    }
}