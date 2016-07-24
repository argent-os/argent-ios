//
//  SupportMenuViewController.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 3/19/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation

class SupportMenuViewController: UIViewController {
    
    
    @IBOutlet weak var cells: UITableViewCell!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Contact Support"
        self.navigationController?.navigationBar.tintColor = UIColor.lightBlue()
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.lightBlue()
        ]
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }
}