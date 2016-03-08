//
//  RecurringViewController.swift
//  paykloud-ios
//
//  Created by Sinan Ulkuatam on 3/7/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit

class RecurringViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded recurring")
        self.view.backgroundColor = UIColor.whiteColor()
        
    }
    
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}