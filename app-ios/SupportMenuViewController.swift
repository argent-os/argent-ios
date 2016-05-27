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
        self.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont.systemFontOfSize(14),
            NSForegroundColorAttributeName: UIColor.darkGrayColor()
        ]
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}