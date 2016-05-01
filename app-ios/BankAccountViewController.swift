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
        
//        self.view.backgroundColor = UIColor(rgba: "#f5f7fa")
        self.navigationItem.title = "Select a Bank"
        self.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()

        self.elements = [
            ["background_color": UIColor(rgba: "#11A0DD"), "bank_name": "amex", "long_bank_name": "American Express", "bank_logo": "bank_amex"],
            ["background_color": UIColor(rgba: "#D4001A"), "bank_name": "bofa", "long_bank_name": "Bank of America", "bank_logo": "bank_bofa"],
            ["background_color": UIColor(rgba: "#003C70"), "bank_name": "capone360", "long_bank_name": "Capital One", "bank_logo": "bank_capone"],
            ["background_color": UIColor(rgba: "#0f5ba7"), "bank_name": "chase", "long_bank_name": "Chase", "bank_logo": "bank_chase"],
            ["background_color": UIColor(rgba: "#000066"), "bank_name": "citi", "long_bank_name": "Citi", "bank_logo": "bank_citi"],
            ["background_color": UIColor(rgba: "#6ec260"), "bank_name": "fidelity", "long_bank_name": "Fidelity", "bank_logo": "bank_fidelity"],
            ["background_color": UIColor(rgba: "#04427e"), "bank_name": "nfcu", "long_bank_name": "Navy Federal", "bank_logo": "bank_navy"],
            ["background_color": UIColor(rgba: "#f48024"), "bank_name": "pnc", "long_bank_name": "PNC", "bank_logo": "bank_pnc"],
            ["background_color": UIColor(rgba: "#009fdf"), "bank_name": "schwab", "long_bank_name": "Charles Schwab", "bank_logo": "bank_schwab"],
            ["background_color": UIColor(rgba: "#f36b2b"), "bank_name": "suntrust", "long_bank_name": "SunTrust", "bank_logo": "bank_suntrust"],
            ["background_color": UIColor(rgba: "#2db357"), "bank_name": "td", "long_bank_name": "TD Bank", "bank_logo": "bank_td"],
            ["background_color": UIColor(rgba: "#0c2074"), "bank_name": "us", "long_bank_name": "US Bank", "bank_logo": "bank_us"],
            ["background_color": UIColor(rgba: "#00365b"), "bank_name": "usaa", "long_bank_name": "USAA", "bank_logo": "bank_usaa"],
            ["background_color": UIColor(rgba: "#bb0826"), "bank_name": "wells", "long_bank_name": "Wells Fargo", "bank_logo": "bank_wells"]
        ]
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("mainCell", forIndexPath: indexPath) as! BankTableViewCell
        cell.imageView?.image = nil
        
        let width = UIScreen.mainScreen().bounds.size.width
        let height = UIScreen.mainScreen().bounds.size.height
        
//        cell.header.layer.cornerRadius = 10
//        cell.header.backgroundColor = UIColor(rgba: "#f5f7fa")
//        cell.background.layer.cornerRadius = 10
//        cell.background.backgroundColor = UIColor(rgba: "#333")
//        cell.background.clipsToBounds = true
        
        // pass in the background image as a parameter here from self.elements above
         cell.header.backgroundColor = self.elements.objectAtIndex(indexPath.row).objectForKey("background_color") as? UIColor
         cell.background.backgroundColor = self.elements.objectAtIndex(indexPath.row).objectForKey("background_color") as? UIColor
         cell.contentView.backgroundColor = self.elements.objectAtIndex(indexPath.row).objectForKey("background_color") as? UIColor
        
        cell.center = CGPoint(x: cell.frame.width / 2.0, y: height / 2.0)
        let img: UIImage = UIImage(named: self.elements.objectAtIndex(indexPath.row).objectForKey("bank_logo") as! String)!
        cell.imageView!.image = img
        cell.imageView!.contentMode = .ScaleAspectFit
        cell.imageView!.frame = CGRectMake(width, (cell.frame.size.height-30)/2, 30, 30)

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

            let destination = segue.destinationViewController as! BankDetailViewController
            destination.color = element.objectForKey("background_color") as? UIColor
            destination.logo = element.objectForKey("bank_logo") as? String
            destination.bankName = element.objectForKey("bank_name") as? String
            destination.longBankName = element.objectForKey("long_bank_name") as? String
            print("color setting", destination.color!)
            print("logo setting", destination.logo!)
            print("bank setting", destination.bankName!)
            print("bank setting", destination.longBankName!)
            
        }
    }
}
