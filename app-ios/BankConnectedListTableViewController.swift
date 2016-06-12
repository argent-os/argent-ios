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
import MCMHeaderAnimated

class BankConnectedListTableViewController: UITableViewController, MCSwipeTableViewCellDelegate, MCMHeaderAnimatedDelegate {
    
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
        
        self.elements = [
            ["color": UIColor(rgba: "#e32b49")],
            ["color": UIColor(rgba: "#2b2be3")],
            ["color": UIColor.skyBlue()],
            ["color": UIColor.brandGreen()]
        ]
        
        self.navigationItem.title = "Connected Accounts"
        self.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()
        
        let HUD: JGProgressHUD = JGProgressHUD.init(style: JGProgressHUDStyle.Dark)
        HUD.showInView(self.view!)
        HUD.textLabel.text = "Loading Connected Banks"
        HUD.dismissAfterDelay(0.7)
        
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
    
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 80.0
//    }
//    
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.banksArray?.count ?? 0
//    }

    // MARK DELEGATE MCTABLEVIEWCELL
    
//    func viewWithImageName(name: String) -> UIView {
//        let image: UIImage = UIImage(named: name)!;
//        let imageView: UIImageView = UIImageView(image: image);
//        imageView.contentMode = UIViewContentMode.Center;
//        return imageView;
//    }
//
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//    }
    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let CellIdentifier: String = "cell";
//        var cell: MCSwipeTableViewCell! = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as! MCSwipeTableViewCell!;
//        if cell == nil {
//            cell = MCSwipeTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: CellIdentifier);
//            cell!.selectionStyle = UITableViewCellSelectionStyle.Gray;
//            cell!.contentView.backgroundColor = UIColor.whiteColor();
//            cell.textLabel?.tintColor = UIColor.lightBlue()
//            cell.detailTextLabel?.tintColor = UIColor.lightBlue().colorWithAlphaComponent(0.5)
//
//            cell.tag = indexPath.row
//            
//            let item = self.banksArray?[indexPath.row]
//            if let name = item?.bank_name, status = item?.status {
//                let strName = name
//                
//                switch status {
//                case "new":
//                    let strStatus = NSAttributedString(string: "New Account", attributes: [
//                        NSFontAttributeName: UIFont.systemFontOfSize(11),
//                        NSForegroundColorAttributeName:UIColor.skyBlue()
//                        ])
//                    cell.textLabel?.attributedText = NSAttributedString(string: strName + " ", attributes: [
//                        NSForegroundColorAttributeName : UIColor.mediumBlue(),
//                        NSFontAttributeName : UIFont.systemFontOfSize(14, weight: UIFontWeightLight)
//                        ]) + strStatus
//                case "validated":
//                    let strStatus = NSAttributedString(string: "Validated ✓", attributes: [
//                        NSFontAttributeName: UIFont.systemFontOfSize(11),
//                        NSForegroundColorAttributeName:UIColor.iosBlue()
//                        ])
//                    cell.textLabel?.attributedText = NSAttributedString(string: strName + " ", attributes: [
//                        NSForegroundColorAttributeName : UIColor.mediumBlue(),
//                        NSFontAttributeName : UIFont.systemFontOfSize(14, weight: UIFontWeightLight)
//                        ]) + strStatus
//                case "verified":
//                    let strStatus = NSAttributedString(string: "Verified ✓", attributes: [
//                        NSFontAttributeName: UIFont.systemFontOfSize(11),
//                        NSForegroundColorAttributeName:UIColor.brandGreen()
//                        ])
//                    cell.textLabel?.attributedText = NSAttributedString(string: strName + " ", attributes: [
//                        NSForegroundColorAttributeName : UIColor.mediumBlue(),
//                        NSFontAttributeName : UIFont.systemFontOfSize(14, weight: UIFontWeightLight)
//                        ]) + strStatus
//                case "verification_failed":
//                    let strStatus = NSAttributedString(string: "Verification Failed", attributes: [
//                        NSFontAttributeName: UIFont.systemFontOfSize(11),
//                        NSForegroundColorAttributeName:UIColor.brandRed()
//                        ])
//                    cell.textLabel?.attributedText = NSAttributedString(string: strName + " ", attributes: [
//                        NSForegroundColorAttributeName : UIColor.mediumBlue(),
//                        NSFontAttributeName : UIFont.systemFontOfSize(14, weight: UIFontWeightLight)
//                        ]) + strStatus
//                case "errored":
//                    let strStatus = NSAttributedString(string: "Error Occurred", attributes: [
//                        NSFontAttributeName: UIFont.systemFontOfSize(11),
//                        NSForegroundColorAttributeName:UIColor.brandRed()
//                        ])
//                    cell.textLabel?.attributedText = NSAttributedString(string: strName + " ", attributes: [
//                        NSForegroundColorAttributeName : UIColor.mediumBlue(),
//                        NSFontAttributeName : UIFont.systemFontOfSize(14, weight: UIFontWeightLight)
//                        ]) + strStatus
//                default:
//                    let strStatus = NSAttributedString(string: status, attributes: [
//                        NSFontAttributeName: UIFont.systemFontOfSize(11),
//                        NSForegroundColorAttributeName:UIColor.skyBlue()
//                        ])
//                    cell.textLabel?.attributedText = NSAttributedString(string: strName + " ", attributes: [
//                        NSForegroundColorAttributeName : UIColor.mediumBlue(),
//                        NSFontAttributeName : UIFont.systemFontOfSize(14, weight: UIFontWeightLight)
//                        ]) + strStatus
//                }
//                
//            }
//            if let last4 = item?.last4, routing = item?.routing_number {
//                let last4AttributedString = NSAttributedString(string: "For account ending in " + last4 + " | Routing " + routing, attributes: [
//                    NSForegroundColorAttributeName : UIColor.lightBlue().colorWithAlphaComponent(0.5),
//                    NSFontAttributeName : UIFont.systemFontOfSize(11, weight: UIFontWeightRegular)
//                    ])
//                
//                cell.detailTextLabel?.attributedText = last4AttributedString
//            }
//        }
//
//        let closeView: UIView = self.viewWithImageName("ic_close_light");
//
//        cell.setSwipeGestureWithView(closeView, color:  UIColor.brandRed(), mode: .Exit, state: .State3) {
//            (cell : MCSwipeTableViewCell!, state : MCSwipeTableViewCellState!, mode : MCSwipeTableViewCellMode!) in
//            let item = self.banksArray?[cell.tag]
//            if let id = item?.id {
//                print("Did swipe" + id);
//                // send request to delete the bank account, on completion reload table data!
//                // send request to delete, on completion reload table data!
//                let alertController = UIAlertController(title: "Confirm deletion", message: "Are you sure?  This action cannot be undone.", preferredStyle: UIAlertControllerStyle.Alert)
//                
//                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
//                alertController.addAction(cancelAction)
//                
//                let OKAction = UIAlertAction(title: "Continue", style: .Default) { (action) in
//                    // send request to delete, on completion reload table data!
//                    Bank.deleteBankAccount(id, completionHandler: { (bool, err) in
//                        print("deleted bank account ", bool)
//                        self.loadBankAccounts()
//                    })
//                }
//                alertController.addAction(OKAction)
//                self.presentViewController(alertController, animated: true, completion: nil)
//            }
//        };
//
//        return cell;
//    }
    
    private let transitionManager = MCMHeaderAnimated()
    
    private var elements: NSArray! = []
    private var lastSelected: NSIndexPath! = nil
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.elements.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("connectedBankCell", forIndexPath: indexPath) as! BankConnectedCell
        
        cell.background.layer.cornerRadius = 30
        cell.background.clipsToBounds = true
        cell.header.backgroundColor = self.elements.objectAtIndex(indexPath.row).objectForKey("color") as? UIColor
        tableView.separatorColor = UIColor.clearColor()
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 190.0
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "viewBankDetail" {
            print("performing segue")
            self.lastSelected = self.tableView.indexPathForSelectedRow
            let element = self.elements.objectAtIndex(self.tableView.indexPathForSelectedRow!.row)
            
            let destination = segue.destinationViewController as! BankConnectedDetailViewController
            destination.element = element as! NSDictionary
            destination.transitioningDelegate = self.transitionManager
            
            self.transitionManager.destinationViewController = destination
        }
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
        header.backgroundColor = self.elements.objectAtIndex(self.lastSelected.row).objectForKey("color") as? UIColor
        return header
    }
    
}

