//
//  CreditCardListViewController.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 4/7/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON
import JGProgressHUD
import MCSwipeTableViewCell

class CreditCardListViewController: UITableViewController, MCSwipeTableViewCellDelegate {
    
    var itemsArray:Array<Card>?
    var cardRefreshControl = UIRefreshControl()
    var dateFormatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Credit Cards"
        self.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()
        
        let HUD: JGProgressHUD = JGProgressHUD.init(style: JGProgressHUDStyle.Dark)
        HUD.showInView(self.view!)
        HUD.textLabel.text = "Loading Credit Cards"
        HUD.dismissAfterDelay(0.7)
        
        self.dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        self.dateFormatter.timeStyle = NSDateFormatterStyle.LongStyle
        
        self.cardRefreshControl.backgroundColor = UIColor.clearColor()
        
        self.cardRefreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.cardRefreshControl.addTarget(self, action: #selector(CreditCardListViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView?.addSubview(cardRefreshControl)
        
        self.loadCreditCards()
    }
    
    func loadCreditCards() {
        Card.getCreditCards({ (items, error) in
            if error != nil
            {
                let alert = UIAlertController(title: "Error", message: "Could not load credit cards \(error?.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            self.itemsArray = items
            
            // update "last updated" title for refresh control
            let now = NSDate()
            let updateString = "Last Updated at " + self.dateFormatter.stringFromDate(now)
            self.cardRefreshControl.attributedTitle = NSAttributedString(string: updateString)
            if self.cardRefreshControl.refreshing
            {
                self.cardRefreshControl.endRefreshing()
            }
            self.tableView?.reloadData()
        })
    }
    
    func timeStringFromUnixTime(unixTime: Double) -> String {
        let date = NSDate(timeIntervalSince1970: unixTime)
        let dateFormatter = NSDateFormatter()
        
        // Returns date formatted as 12 hour time.
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.stringFromDate(date)
    }
    
    func dayStringFromTime(unixTime: Double) -> String {
        let dateFormatter = NSDateFormatter()
        let date = NSDate(timeIntervalSince1970: unixTime)
        dateFormatter.locale = NSLocale(localeIdentifier: NSLocale.currentLocale().localeIdentifier)
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.stringFromDate(date)
    }
    
    func refresh(sender:AnyObject)
    {
        self.loadCreditCards()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80.0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemsArray?.count ?? 0
    }

    // MARK DELEGATE MCTABLEVIEWCELL
    
    func viewWithImageName(name: String) -> UIView {
        let image: UIImage = UIImage(named: name)!;
        let imageView: UIImageView = UIImageView(image: image);
        imageView.contentMode = UIViewContentMode.Center;
        return imageView;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let CellIdentifier: String = "cell";
        var cell: MCSwipeTableViewCell! = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as! MCSwipeTableViewCell!;
        if cell == nil {
            cell = MCSwipeTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: CellIdentifier);
            cell!.selectionStyle = UITableViewCellSelectionStyle.Gray;
            cell!.contentView.backgroundColor = UIColor.whiteColor();
            
            let item = self.itemsArray?[indexPath.row]
            if let brand = item?.brand {
                cell.textLabel?.text = brand
            }
            if let number = item?.last4 {
                cell.detailTextLabel?.text = "For card ending in " + number
            }
        }
        
        let closeView: UIView = self.viewWithImageName("ic_close_light");
        
        cell.setSwipeGestureWithView(closeView, color:  UIColor.brandRed(), mode: .Exit, state: .State3) {
            (cell : MCSwipeTableViewCell!, state : MCSwipeTableViewCellState!, mode : MCSwipeTableViewCellMode!) in print("Did swipe \"Clock \"");
                NSLog("Did swipe \"close\" cell")
        };
        
        return cell;
    }
    
    // Called when the user starts swiping the cell.
    
    // Called during a swipe.
    
    func swipeTableViewCell(cell: MCSwipeTableViewCell, didSwipeWithPercentage percentage: CGFloat) {
    }

}
