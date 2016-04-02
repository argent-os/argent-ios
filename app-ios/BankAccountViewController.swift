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
            ["background_color": UIColor(rgba: "#11A0DD"), "bank_name": "amex", "bank_logo": "bank_amex"],
            ["background_color": UIColor(rgba: "#D4001A"), "bank_name": "bofa", "bank_logo": "bank_bofa"],
            ["background_color": UIColor(rgba: "#003C70"), "bank_name": "capone", "bank_logo": "bank_capone"],
            ["background_color": UIColor(rgba: "#0f5ba7"), "bank_name": "chase", "bank_logo": "bank_chase"],
            ["background_color": UIColor(rgba: "#000066"), "bank_name": "citi", "bank_logo": "bank_citi"],
            ["background_color": UIColor(rgba: "#04427e"), "bank_name": "navy", "bank_logo": "bank_navy"],
            ["background_color": UIColor(rgba: "#f48024"), "bank_name": "pnc", "bank_logo": "bank_pnc"],
            ["background_color": UIColor(rgba: "#009fdf"), "bank_name": "schwab", "bank_logo": "bank_schwab"],
            ["background_color": UIColor(rgba: "#f36b2b"), "bank_name": "suntrust", "bank_logo": "bank_suntrust"],
            ["background_color": UIColor(rgba: "#2db357"), "bank_name": "td", "bank_logo": "bank_td"],
            ["background_color": UIColor(rgba: "#0c2074"), "bank_name": "us", "bank_logo": "bank_us"],
            ["background_color": UIColor(rgba: "#00365b"), "bank_name": "usaa", "bank_logo": "bank_usaa"],
            ["background_color": UIColor(rgba: "#bb0826"), "bank_name": "wells", "bank_logo": "bank_wells"]
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
        
        let width = UIScreen.mainScreen().bounds.size.width
        let height = UIScreen.mainScreen().bounds.size.height
        
        cell.background.layer.cornerRadius = 0
        cell.background.backgroundColor = UIColor.clearColor()
        cell.header.backgroundColor = UIColor.clearColor()
        cell.header.layer.cornerRadius = 0
        cell.background.clipsToBounds = true
        
        // pass in the background image as a parameter here from self.elements above
        cell.contentView.backgroundColor = self.elements.objectAtIndex(indexPath.row).objectForKey("background_color") as? UIColor
//        cell.imageView!.frame = CGRectMake(0, 0, width, height)
        cell.imageView!.image = UIImage(named: self.elements.objectAtIndex(indexPath.row).objectForKey("bank_logo") as! String)
        
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
            destination.color = element.objectForKey("background_color") as? UIColor
            print("color setting", destination.color!)

            // destination.element = element as! NSDictionary
            
        }
    }
}
