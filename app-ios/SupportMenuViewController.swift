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
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "MyriadPro-Regular", size: 17)!,
            NSForegroundColorAttributeName: UIColor.darkBlue()
        ]
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBar.tintColor = UIColor.darkBlue()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }
}