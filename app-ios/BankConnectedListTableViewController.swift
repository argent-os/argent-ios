//
//  BankConnectedListTableViewController.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 4/5/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON
import JGProgressHUD
import MCSwipeTableViewCell

class BankConnectedListTableViewController: UITableViewController, MCSwipeTableViewCellDelegate {
    
    var itemsArray:Array<Bank>?
    
    var bankRefreshControl = UIRefreshControl()
    
    var dateFormatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Connected Accounts"
        self.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()
        
        let HUD: JGProgressHUD = JGProgressHUD.init(style: JGProgressHUDStyle.Dark)
        HUD.showInView(self.view!)
        HUD.textLabel.text = "Loading Connected Banks"
        HUD.dismissAfterDelay(0.7)
        
        self.dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        self.dateFormatter.timeStyle = NSDateFormatterStyle.LongStyle
        
        self.bankRefreshControl.backgroundColor = UIColor.clearColor()
        
        self.bankRefreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.bankRefreshControl.addTarget(self, action: #selector(BankConnectedListTableViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView?.addSubview(bankRefreshControl)
        
        self.loadBankAccounts()
    }
    
    //Changing Status Bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func loadBankAccounts() {
        Bank.getBankAccounts({ (items, error) in
            if error != nil
            {
                let alert = UIAlertController(title: "Error", message: "Could not load banks \(error?.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            self.itemsArray = items
            
            // update "last updated" title for refresh control
            let now = NSDate()
            let updateString = "Last Updated at " + self.dateFormatter.stringFromDate(now)
            self.bankRefreshControl.attributedTitle = NSAttributedString(string: updateString)
            if self.bankRefreshControl.refreshing
            {
                self.bankRefreshControl.endRefreshing()
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
        self.loadBankAccounts()
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

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let CellIdentifier: String = "cell";
        var cell: MCSwipeTableViewCell! = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as! MCSwipeTableViewCell!;
        if cell == nil {
            cell = MCSwipeTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: CellIdentifier);
            cell!.selectionStyle = UITableViewCellSelectionStyle.Gray;
            cell!.contentView.backgroundColor = UIColor.whiteColor();
            cell.textLabel?.tintColor = UIColor.lightBlue()
            cell.detailTextLabel?.tintColor = UIColor.lightBlue().colorWithAlphaComponent(0.5)
            cell.tag = indexPath.row

            let item = self.itemsArray?[indexPath.row]
            if let name = item?.bank_name, id = item?.id {
                cell.textLabel?.text = name
            }
            if let number = item?.last4 {
                // cell!.detailTextLabel?.text = "Current $" + current + " | " + "Available $" + available
                cell.detailTextLabel?.text = "For account ending in " + number
            }
        }

        let closeView: UIView = self.viewWithImageName("ic_close_light");

        cell.setSwipeGestureWithView(closeView, color:  UIColor.brandRed(), mode: .Exit, state: .State3) {
            (cell : MCSwipeTableViewCell!, state : MCSwipeTableViewCellState!, mode : MCSwipeTableViewCellMode!) in
            let item = self.itemsArray?[cell.tag]
            if let id = item?.id {
                print("Did swipe" + id);
                // send request to delete the bank account, on completion reload table data!
                // send request to delete, on completion reload table data!
                let alertController = UIAlertController(title: "Confirm deletion", message: "Are you sure?  This action cannot be undone.", preferredStyle: UIAlertControllerStyle.Alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                alertController.addAction(cancelAction)
                
                let OKAction = UIAlertAction(title: "Continue", style: .Default) { (action) in
                    // send request to delete, on completion reload table data!
                    Bank.deleteBankAccount(id, completionHandler: { (bool, err) in
                        print("deleted bank account ", bool)
                        self.loadBankAccounts()
                    })
                }
                alertController.addAction(OKAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        };

        return cell;
    }
    
}
