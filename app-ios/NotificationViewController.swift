//
//  NotificationViewController.swift
//  protonpay-ios
//
//  Created by Sinan Ulkuatam on 3/7/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

enum StockType {
    case Tech
    case Cars
    case Telecom
}

class NotificationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var itemsArray:Array<StockQuoteItem>?
    @IBOutlet var tableView: UITableView?
    
    var stockType: StockType = .Tech
    
    var refreshControl = UIRefreshControl()
    var dateFormatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        self.dateFormatter.timeStyle = NSDateFormatterStyle.LongStyle
        
        self.refreshControl.backgroundColor = UIColor.clearColor()
        
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView?.addSubview(refreshControl)
        
        self.loadStockQuoteItems()
    }
    
    func symbolsStringForCurrentStockType() -> Array<String>
    {
        switch self.stockType {
        case .Tech:
            return ["AAPL", "GOOG", "YHOO"]
        case .Cars:
            return ["GM", "F"]
        case .Telecom:
            return ["T", "VZ", "CMCSA"]
        }
    }
    
    @IBAction func stockTypeSegmentedControlValueChanged(sender: UISegmentedControl)
    {
        switch sender.selectedSegmentIndex {
        case 0:
            self.stockType = .Tech
        case 1:
            self.stockType = .Cars
        case 2:
            self.stockType = .Telecom
        default:
            print("Segment index out of known range, do you need to add to the enum or switch statement?")
        }
        
        // load data for our new symbols
        refresh(sender)
    }
    
    func loadStockQuoteItems() {
        let symbols = symbolsStringForCurrentStockType()
        StockQuoteItem.getFeedItems(symbols, completionHandler: { (items, error) in
            if error != nil
            {
                let alert = UIAlertController(title: "Error", message: "Could not load stock quotes :( \(error?.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            self.itemsArray = items
            
            // update "last updated" title for refresh control
            let now = NSDate()
            let updateString = "Last Updated at " + self.dateFormatter.stringFromDate(now)
            self.refreshControl.attributedTitle = NSAttributedString(string: updateString)
            if self.refreshControl.refreshing
            {
                self.refreshControl.endRefreshing()
            }
            
            self.tableView?.reloadData()
        })
    }
    
    func refresh(sender:AnyObject)
    {
        self.loadStockQuoteItems()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemsArray?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let item = self.itemsArray?[indexPath.row]
        cell.textLabel?.text = ""
        cell.detailTextLabel?.text = ""
        if let symbol = item?.symbol, ask = item?.ask
        {
            cell.textLabel?.text = symbol + " @ $" + ask
        }
        if let low = item?.yearLow, high = item?.yearHigh
        {
            cell.detailTextLabel?.text = "Year: " + low + " - " + high
        }
        return cell
    }
    
}
