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
import MCSwipeTableViewCell
import CellAnimator

class BankConnectedListTableViewController: UITableViewController, MCSwipeTableViewCellDelegate {
    
    var banksArray:Array<Bank>?
    
    var bankRefreshControl = UIRefreshControl()
    
    var dateFormatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        
        addInfiniteScroll()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBar.tintColor = UIColor.lightBlue()
    }
    
    private func addInfiniteScroll() {
        // Add infinite scroll handler
        // change indicator view style to white
        self.tableView.infiniteScrollIndicatorStyle = .Gray
        
        // Add infinite scroll handler
        self.tableView.addInfiniteScrollWithHandler { (scrollView) -> Void in
            let tableView = scrollView as! UITableView
            
            //
            // fetch your data here, can be async operation,
            // just make sure to call finishInfiniteScroll in the end
            //
            
            // make sure you reload tableView before calling -finishInfiniteScroll
            tableView.reloadData()
            
            // finish infinite scroll animation
            tableView.finishInfiniteScroll()
        }
    }
    
    func configureView() {
        
        // Remove extra splitters in table
        self.tableView.tableFooterView = UIView()

        // During startup (viewDidLoad or in storyboard) do:
        self.tableView.allowsMultipleSelectionDuringEditing = false

        self.tableView.backgroundColor = UIColor.offWhite()
        
        self.navigationItem.title = "Connected Banks"
        self.navigationController?.navigationBar.tintColor = UIColor.lightBlue()
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 60)
        
        let indicator = UIActivityIndicatorView()
        addActivityIndicatorView(indicator, view: self.tableView, color: UIActivityIndicatorViewStyle.Gray)
        
        self.dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        self.dateFormatter.timeStyle = NSDateFormatterStyle.LongStyle
        
        self.bankRefreshControl.backgroundColor = UIColor.clearColor()
        
        self.bankRefreshControl.tintColor = UIColor.lightBlue()
        self.bankRefreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [
            NSFontAttributeName: UIFont.systemFontOfSize(13),
            NSForegroundColorAttributeName:UIColor.lightBlue()
        ])
        self.bankRefreshControl.addTarget(self, action: #selector(self.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
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
            self.banksArray = items
            
            // update "last updated" title for refresh control
            let now = NSDate()
            let updateString = "Last Updated at " + self.dateFormatter.stringFromDate(now)
            self.bankRefreshControl.attributedTitle = NSAttributedString(string: updateString, attributes: [
                NSFontAttributeName: UIFont.systemFontOfSize(13),
                NSForegroundColorAttributeName:UIColor.lightBlue()
                ])
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
    
    func refresh(sender:AnyObject) {
        self.loadBankAccounts()
    }
    
    private var lastSelected: NSIndexPath! = nil
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.banksArray?.count ?? 0
    }
    
    // Override to support conditional editing of the table view.
    // This only needs to be implemented if you are going to be returning NO
    // for some items. By default, all items are editable.
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return true if you want the specified item to be editable.
        return true
    }
    // Override to support editing the table view.
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            //add code here for when you hit delete
            let item = self.banksArray?[indexPath.row]
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
                        self.loadBankAccounts()
                        self.tableView.reloadData()
                    })
                }
                alertController.addAction(OKAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100.0
    }
    
}


extension BankConnectedListTableViewController {
    
    func headerView() -> UIView {
        // Selected cell
        let cell = self.tableView.cellForRowAtIndexPath(self.lastSelected) as! BankConnectedCell
        return cell.header
    }
    
    func headerCopy(subview: UIView) -> UIView {
        let cell = tableView.cellForRowAtIndexPath(self.lastSelected) as! BankConnectedCell
        let header = UIView(frame: cell.header.frame)
        header.backgroundColor = UIColor.lightBlue()
        return header
    }
    
}

extension BankConnectedListTableViewController {
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("connectedBankCell", forIndexPath: indexPath) as! BankConnectedCell
        
        cell.background.layer.cornerRadius = 5
        cell.background.clipsToBounds = true
        cell.backgroundColor = UIColor.offWhite()
        tableView.separatorColor = UIColor.lightBlue().colorWithAlphaComponent(0.3)
        cell.selectionStyle = UITableViewCellSelectionStyle.Blue;
        cell.textLabel?.tintColor = UIColor.lightBlue()
        cell.detailTextLabel?.tintColor = UIColor.lightBlue().colorWithAlphaComponent(0.5)
        
        cell.tag = indexPath.row
        
        let item = self.banksArray?[indexPath.row]
        if let name = item?.bank_name {
            
            if name.containsString("STRIPE") {
                let bankName = NSAttributedString(string: name, attributes: [
                    NSForegroundColorAttributeName : UIColor.lightBlue(),
                    NSFontAttributeName : UIFont.systemFontOfSize(16, weight: UIFontWeightRegular)
                    ])
                cell.header.backgroundColor = UIColor.offWhite()
                cell.bankLogoImageView.image = UIImage(named: "bank_avatar_stripe")
                cell.bankLogoImageView.contentMode = .ScaleAspectFit
                cell.bankTitleLabel.attributedText = bankName
            } else if name.containsString("BANK OF AMERICA") {
                let bankName = NSAttributedString(string: name, attributes: [
                    NSForegroundColorAttributeName : UIColor.lightBlue(),
                    NSFontAttributeName : UIFont.systemFontOfSize(16, weight: UIFontWeightRegular)
                    ])
                //cell.header.backgroundColor = UIColor.bankBofa()
                cell.bankLogoImageView.image = UIImage(named: "bank_avatar_bofa")
                cell.bankLogoImageView.contentMode = .ScaleAspectFit
                cell.bankTitleLabel.attributedText = bankName
            } else if name.containsString("CITI") {
                let bankName = NSAttributedString(string: name, attributes: [
                    NSForegroundColorAttributeName : UIColor.lightBlue(),
                    NSFontAttributeName : UIFont.systemFontOfSize(16, weight: UIFontWeightRegular)
                    ])
                //cell.header.backgroundColor = UIColor.bankCiti()
                cell.bankLogoImageView.image = UIImage(named: "bank_avatar_citi")
                cell.bankLogoImageView.contentMode = .ScaleAspectFit
                cell.bankTitleLabel.attributedText = bankName
            } else if name.containsString("WELLS") {
                let bankName = NSAttributedString(string: name, attributes: [
                    NSForegroundColorAttributeName : UIColor.lightBlue(),
                    NSFontAttributeName : UIFont.systemFontOfSize(16, weight: UIFontWeightRegular)
                    ])
                //cell.header.backgroundColor = UIColor.bankWells()
                cell.bankLogoImageView.image = UIImage(named: "bank_avatar_wells")
                cell.bankLogoImageView.contentMode = .ScaleAspectFit
                cell.bankTitleLabel.attributedText = bankName
            } else if name.containsString("TD BANK") {
                let bankName = NSAttributedString(string: name, attributes: [
                    NSForegroundColorAttributeName : UIColor.lightBlue(),
                    NSFontAttributeName : UIFont.systemFontOfSize(16, weight: UIFontWeightRegular)
                    ])
                //cell.header.backgroundColor = UIColor.bankTd()
                cell.bankLogoImageView.image = UIImage(named: "bank_avatar_td")
                cell.bankLogoImageView.contentMode = .ScaleAspectFit
                cell.bankTitleLabel.attributedText = bankName
            } else if name.containsString("US BANK") {
                let bankName = NSAttributedString(string: name, attributes: [
                    NSForegroundColorAttributeName : UIColor.lightBlue(),
                    NSFontAttributeName : UIFont.systemFontOfSize(16, weight: UIFontWeightRegular)
                    ])
                //cell.header.backgroundColor = UIColor.bankUs()
                cell.bankLogoImageView.image = UIImage(named: "bank_avatar_us")
                cell.bankLogoImageView.contentMode = .ScaleAspectFit
                cell.bankTitleLabel.attributedText = bankName
            } else if name.containsString("PNC") {
                let bankName = NSAttributedString(string: name, attributes: [
                    NSForegroundColorAttributeName : UIColor.lightBlue(),
                    NSFontAttributeName : UIFont.systemFontOfSize(16, weight: UIFontWeightRegular)
                    ])
                //cell.header.backgroundColor = UIColor.bankPnc()
                cell.bankLogoImageView.image = UIImage(named: "bank_avatar_pnc")
                cell.bankLogoImageView.contentMode = .ScaleAspectFit
                cell.bankTitleLabel.attributedText = bankName
            } else if name.containsString("AMERICAN EXPRESS") {
                let bankName = NSAttributedString(string: name, attributes: [
                    NSForegroundColorAttributeName : UIColor.lightBlue(),
                    NSFontAttributeName : UIFont.systemFontOfSize(16, weight: UIFontWeightRegular)
                    ])
                //cell.header.backgroundColor = UIColor.bankAmex()
                cell.bankLogoImageView.image = UIImage(named: "bank_avatar_amex")
                cell.bankLogoImageView.contentMode = .ScaleAspectFit
                cell.bankTitleLabel.attributedText = bankName
            } else if name.containsString("NAVY") {
                let bankName = NSAttributedString(string: name, attributes: [
                    NSForegroundColorAttributeName : UIColor.lightBlue(),
                    NSFontAttributeName : UIFont.systemFontOfSize(16, weight: UIFontWeightRegular)
                    ])
                //cell.header.backgroundColor = UIColor.bankNavy()
                cell.bankLogoImageView.image = UIImage(named: "bank_avatar_navy")
                cell.bankLogoImageView.contentMode = .ScaleAspectFit
                cell.bankTitleLabel.attributedText = bankName
            } else if name.containsString("USAA") {
                let bankName = NSAttributedString(string: name, attributes: [
                    NSForegroundColorAttributeName : UIColor.lightBlue(),
                    NSFontAttributeName : UIFont.systemFontOfSize(16, weight: UIFontWeightRegular)
                    ])
                //cell.header.backgroundColor = UIColor.bankUsaa()
                cell.bankLogoImageView.image = UIImage(named: "bank_avatar_usaa")
                cell.bankLogoImageView.contentMode = .ScaleAspectFit
                cell.bankTitleLabel.attributedText = bankName
            } else if name.containsString("CHASE") {
                let bankName = NSAttributedString(string: name, attributes: [
                    NSForegroundColorAttributeName : UIColor.lightBlue(),
                    NSFontAttributeName : UIFont.systemFontOfSize(16, weight: UIFontWeightRegular)
                    ])
                //cell.header.backgroundColor = UIColor.bankChase()
                cell.bankLogoImageView.image = UIImage(named: "bank_avatar_chase")
                cell.bankLogoImageView.contentMode = .ScaleAspectFit
                cell.bankTitleLabel.attributedText = bankName
            } else if name.containsString("CAPITAL ONE") {
                let bankName = NSAttributedString(string: name, attributes: [
                    NSForegroundColorAttributeName : UIColor.lightBlue(),
                    NSFontAttributeName : UIFont.systemFontOfSize(16, weight: UIFontWeightRegular)
                    ])
                //cell.header.backgroundColor = UIColor.bankCapone()
                cell.bankLogoImageView.image = UIImage(named: "bank_avatar_capone")
                cell.bankLogoImageView.contentMode = .ScaleAspectFit
                cell.bankTitleLabel.attributedText = bankName
            } else if name.containsString("SCHWAB") {
                let bankName = NSAttributedString(string: name, attributes: [
                    NSForegroundColorAttributeName : UIColor.lightBlue(),
                    NSFontAttributeName : UIFont.systemFontOfSize(16, weight: UIFontWeightRegular)
                    ])
                //cell.header.backgroundColor = UIColor.bankSchwab()
                cell.bankLogoImageView.image = UIImage(named: "bank_avatar_schwab")
                cell.bankLogoImageView.contentMode = .ScaleAspectFit
                cell.bankTitleLabel.attributedText = bankName
            } else if name.containsString("FIDELITY") {
                let bankName = NSAttributedString(string: name, attributes: [
                    NSForegroundColorAttributeName : UIColor.lightBlue(),
                    NSFontAttributeName : UIFont.systemFontOfSize(16, weight: UIFontWeightRegular)
                    ])
                //cell.header.backgroundColor = UIColor.bankFidelity()
                cell.bankLogoImageView.image = UIImage(named: "bank_avatar_fidelity")
                cell.bankLogoImageView.contentMode = .ScaleAspectFit
                cell.bankTitleLabel.attributedText = bankName
            } else if name.containsString("SUNTRUST") {
                let bankName = NSAttributedString(string: name, attributes: [
                    NSForegroundColorAttributeName : UIColor.lightBlue(),
                    NSFontAttributeName : UIFont.systemFontOfSize(16, weight: UIFontWeightRegular)
                    ])
                //cell.header.backgroundColor = UIColor.bankSuntrust()
                cell.bankLogoImageView.image = UIImage(named: "bank_avatar_suntrust")
                cell.bankLogoImageView.contentMode = .ScaleAspectFit
                cell.bankTitleLabel.attributedText = bankName
            } else {
                let bankName = NSAttributedString(string: name, attributes: [
                    NSForegroundColorAttributeName : UIColor.lightBlue(),
                    NSFontAttributeName : UIFont.systemFontOfSize(14, weight: UIFontWeightRegular)
                    ])
                //cell.header.backgroundColor = UIColor.lightBlue()
                cell.bankLogoImageView.image = UIImage(named: "bank_avatar_default")
                cell.bankLogoImageView.contentMode = .ScaleAspectFit
                cell.bankTitleLabel.attributedText = bankName
            }
        }

//        let routingAttributedString = NSAttributedString(string: "Routing " + (item?.routing_number)!, attributes: [
//            NSForegroundColorAttributeName : UIColor.lightBlue(),
//            NSFontAttributeName : UIFont.systemFontOfSize(12, weight: UIFontWeightLight)
//            ])
//        let last4AttributedString = NSAttributedString(string: "Ending in " + (item?.last4)!, attributes: [
//            NSForegroundColorAttributeName : UIColor.lightBlue(),
//            NSFontAttributeName : UIFont.systemFontOfSize(12, weight: UIFontWeightLight)
//            ])
//        
//        cell.bankLastFourLabel?.attributedText = last4AttributedString
//        cell.bankRoutingLabel?.attributedText = routingAttributedString
        
        if let status = item?.status, last4 = item?.last4 {
            
            switch status {
            case "new":
                let strStatus = NSAttributedString(string: "New Account | Ending in " + last4, attributes: [
                    NSFontAttributeName: UIFont.systemFontOfSize(11),
                    NSForegroundColorAttributeName:UIColor.lightBlue()
                    ])
                cell.bankStatusLabel?.attributedText = strStatus
            case "validated":
                let strStatus = NSAttributedString(string: "Validated | Ending in " + last4, attributes: [
                    NSFontAttributeName: UIFont.systemFontOfSize(11),
                    NSForegroundColorAttributeName:UIColor.lightBlue()
                    ])
                cell.bankStatusLabel?.attributedText = strStatus
            case "verified":
                let strStatus = NSAttributedString(string: "Verified | Ending in " + last4, attributes: [
                    NSFontAttributeName: UIFont.systemFontOfSize(11),
                    NSForegroundColorAttributeName:UIColor.lightBlue()
                    ])
                cell.bankStatusLabel?.attributedText = strStatus
            case "verification_failed":
                let strStatus = NSAttributedString(string: "Verification Failed | Ending in " + last4, attributes: [
                    NSFontAttributeName: UIFont.systemFontOfSize(11),
                    NSForegroundColorAttributeName:UIColor.lightBlue()
                    ])
                cell.bankStatusLabel?.attributedText = strStatus
            case "errored":
                let strStatus = NSAttributedString(string: "Error occurred | This account is invalid", attributes: [
                    NSFontAttributeName: UIFont.systemFontOfSize(11),
                    NSForegroundColorAttributeName:UIColor.lightBlue()
                    ])
                cell.bankStatusLabel?.attributedText = strStatus
            default:
                let strStatus = NSAttributedString(string: status, attributes: [
                    NSFontAttributeName: UIFont.systemFontOfSize(11),
                    NSForegroundColorAttributeName:UIColor.lightBlue()
                    ])
                cell.bankStatusLabel?.attributedText = strStatus
            }
            
        }
        
        return cell
    }
}

