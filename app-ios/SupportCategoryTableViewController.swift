//
//  SupportCategoryTableViewController.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 5/27/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation

class SupportCategoryTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Send the subject with the segue
        let selected = self.tableView.indexPathForSelectedRow!.row
        
        let indexPath = tableView.indexPathForSelectedRow
        
        let currentCell = tableView.cellForRowAtIndexPath(indexPath!)! as UITableViewCell
        
        let destination = segue.destinationViewController as! SupportMessageViewController
        destination.subject = (currentCell.textLabel!.text)!
    }

}