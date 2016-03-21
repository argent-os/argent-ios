//
//  SupportMenuViewController.swift
//  paykloud-ios
//
//  Created by Sinan Ulkuatam on 3/19/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation

class SupportMenuViewController: UIViewController {
    
    
    @IBOutlet weak var cells: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.tintColor = UIColor.darkGrayColor()
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}