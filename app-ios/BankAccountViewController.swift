//
//  MainTableViewController.swift
//  Example
//
//  Created by Mathias Carignani on 5/19/15.
//  Copyright (c) 2015 Mathias Carignani. All rights reserved.
//

import UIKit
var emitColor:UIColor!

class MainTableViewController: UITableViewController {
    
    private var elements: NSArray! = []
    private var lastSelected: NSIndexPath! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Link Bank Account"
        
        self.elements = [
            ["color": UIColor(red: 25/255.0, green: 181/255.0, blue: 254/255.0, alpha: 1.0)],
            ["color": UIColor(red: 54/255.0, green: 215/255.0, blue: 183/255.0, alpha: 1.0)],
            ["color": UIColor(red: 210/255.0, green: 77/255.0, blue: 87/255.0, alpha: 1.0)],
            ["color": UIColor(red: 236/255.0, green: 236/255.0, blue: 236/255.0, alpha: 1.0)]
        ]
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.elements.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None

        let cell = tableView.dequeueReusableCellWithIdentifier("mainCell", forIndexPath: indexPath) as! MainTableViewCell
        
        cell.background.layer.cornerRadius = 10;
        cell.header.layer.cornerRadius = 10;
        cell.background.clipsToBounds = true
        cell.header.backgroundColor = self.elements.objectAtIndex(indexPath.row).objectForKey("color") as? UIColor
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 180.0
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "viewDetail" {
            self.lastSelected = self.tableView.indexPathForSelectedRow
            let element = self.elements.objectAtIndex(self.tableView.indexPathForSelectedRow!.row)

            // let destination = (self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController"))! as! DetailViewController

            let destination = segue.destinationViewController as! DetailViewController
            destination.color = element.objectForKey("color") as! UIColor
            print("color setting", destination.color!)

            // destination.element = element as! NSDictionary
            
        }
    }
}
