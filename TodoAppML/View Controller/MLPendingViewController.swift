//
//  MLPendingViewController.swift
//  TodoAppML
//
//  Created by Rey Pena on 20/09/2016.
//  Copyright © 2016 Malaysia. All rights reserved.
//

import UIKit

class MLPendingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        MLPendingVCModel.listOfPendingTasks({ (data) in
                print(data)
            }) { (error) in
                print(error)
        }
    }
    

}
