//
//  BankListModalViewController.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 7/24/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import MZFormSheetPresentationController
import XLActionController
import Alamofire
import Stripe
import SwiftyJSON
import DZNEmptyDataSet
import CellAnimator
import AvePurchaseButton
import EmitterKit
import PassKit
import CWStatusBarNotification
import XLActionController
import Crashlytics

class BankListModalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UIGestureRecognizerDelegate {
    
    private var dateFormatter = NSDateFormatter()
    
    private var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    private var merchantLabel:UILabel = UILabel()
    
    private var tableView = UITableView()
    
    private var cellReuseIdendifier = "idCellMerchantPlan"
    
    private var selectedRow: Int?
    
    private var selectedAmount: Float?
    
    let currencyFormatter = NSNumberFormatter()
    
    var planId: String?
    
    var paymentMethod: String = "None"
    
    var paymentType: String?
    
    var paymentSuccessSignal: Signal? = Signal()
    
    var paymentCancelSignal: Signal? = Signal()
    
    var paymentSuccessListener: Listener?
    
    var paymentCancelListener: Listener?
    
    var globalTag: Int?
    
    var detailAmount: Float?
    
    var bankId: String?
    
    var detailUser: User? {
        didSet {
        }
    }
    
    // Extension
    private var lastSelected: NSIndexPath! = nil
    
    var banksArray:Array<Bank>?
    
    var bankRefreshControl = UIRefreshControl()
    
    override func viewDidAppear(animated: Bool) {
        self.childViewControllerForStatusBarStyle()?.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setupBankCell()
        addInfiniteScroll()
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
    
    func setupBankCell() {
        tableView.registerNib(UINib(nibName: "BankACHConnectedCell", bundle: nil), forCellReuseIdentifier: "connectedBankACHCell")
    }
    
    func configure() {
        
        // This will set to only one instance
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.layer.borderWidth = 1
        self.view.layer.masksToBounds = true
        self.view.layer.cornerRadius = 10.0
        self.view.layer.borderColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.2).CGColor
        self.view.layer.borderWidth = 1
        self.view.layer.shadowColor = UIColor.blackColor().CGColor
        self.view.layer.shadowOpacity = 0.8
        self.view.layer.shadowRadius = 3.0
        self.view.layer.shadowOffset = CGSizeMake(2.0, 2.0)
        
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.barTintColor = UIColor.lightGrayColor()
        
        tableView.registerClass(MerchantPlanCell.self, forCellReuseIdentifier: cellReuseIdendifier)
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.reloadData()
        tableView.showsVerticalScrollIndicator = false
        tableView.frame = CGRect(x: 0, y: 0, width: 280, height: 390)
        self.view.addSubview(tableView)
        
        self.dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        self.dateFormatter.timeStyle = NSDateFormatterStyle.LongStyle
        
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: 280, height: 50))
        navBar.barTintColor = UIColor.whiteColor()
        navBar.translucent = false
        navBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.lightBlue(),
            NSFontAttributeName : UIFont(name: "MyriadPro-Regular", size: 14)!
        ]
        self.view.addSubview(navBar);
        let navItem = UINavigationItem(title: "Select ACH Bank");
        navBar.setItems([navItem], animated: false);
        
        // add gesture recognizer to window
        let recognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MerchantPlansViewController.handleTapBehind(_:)))
        recognizer.numberOfTapsRequired = 1
        recognizer.cancelsTouchesInView = false
        //So the user can still interact with controls in the modal view
        self.view.addGestureRecognizer(recognizer)
        recognizer.delegate = self
        
        self.loadBanks("100", starting_after: "0") { (banks, err) in
            //
        }
    }
    
    func handleTapBehind(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            // passing nil gives us coordinates in the window
            let location: CGPoint = sender.locationInView(nil)
            // convert the tap's location into the local view's coordinate system, and test to see if it's in or outside. If outside, dismiss the view.
            if !self.view!.pointInside(self.view!.convertPoint(location, fromView: self.view.window), withEvent: nil) {
                // remove the recognizer first so it's view.window is valid
                self.view.removeGestureRecognizer(sender)
                self.paymentCancelSignal?.emit()
            }
        }
    }
    
    private func loadBanks(limit: String, starting_after: String, completionHandler: ([Bank]?, NSError?) -> ()) {
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        // self.view.addSubview(activityIndicator)
        Bank.getBankAccounts({ (banks, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "Could not load banks \(error?.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            self.banksArray = banks
            self.activityIndicator.stopAnimating()
            
            // sets empty data set if data is nil
            self.tableView.emptyDataSetSource = self
            self.tableView.emptyDataSetDelegate = self
            self.tableView.tableFooterView = UIView()
            self.tableView.reloadData()
        })
    }
    
    // MARK: DZNEmptyDataSet delegate
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = ""
        //let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
        return NSAttributedString(string: str, attributes: headerAttrs)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "No banks linked"
        //let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
        return NSAttributedString(string: str, attributes: bodyAttrs)
    }
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "IconBank")
    }
    
    func buttonTitleForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> NSAttributedString! {
        let str = ""
        //let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleCallout)]
        return NSAttributedString(string: str, attributes: calloutAttrs)
    }
    
    func emptyDataSetDidTapButton(scrollView: UIScrollView!) {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("RecurringBillingViewController") as! RecurringBillingViewController
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}

extension BankListModalViewController {
    
    func configureView() {
        
        // Remove extra splitters in table
        self.tableView.tableFooterView = UIView()
        
        // During startup (viewDidLoad or in storyboard) do:
        self.tableView.allowsMultipleSelectionDuringEditing = false
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.backgroundColor = UIColor.whiteColor()
        
        self.navigationItem.title = "Connected Banks"
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
        self.tableView.addSubview(bankRefreshControl)
        
        self.loadBankAccounts()
    }
    
    //Changing Status Bar
    override func prefersStatusBarHidden() -> Bool {
        return false
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
            self.tableView.reloadData()
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
    
    // Override to support conditional editing of the table view.
    // This only needs to be implemented if you are going to be returning NO
    // for some items. By default, all items are editable.
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return true if you want the specified item to be editable.
        return true
    }
    // Override to support editing the table view.
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
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
}

extension BankListModalViewController {
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100.0
    }
    
    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.selectedRow = indexPath.row
        print(banksArray![self.selectedRow!].id)
        self.performSegueWithIdentifier("confirmACHTransferView", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "confirmACHTransferView" {
            let destination = segue.destinationViewController as! BankACHConfirmationModalViewController
            destination.bankId = banksArray![self.selectedRow!].id
            destination.bankFingerprint = banksArray![self.selectedRow!].fingerprint
            destination.bankAccountHolderName = banksArray![self.selectedRow!].account_holder_name
            destination.bankAccountHolderType = banksArray![self.selectedRow!].account_holder_type
            destination.bankName = banksArray![self.selectedRow!].bank_name
            destination.bankLast4 = banksArray![self.selectedRow!].last4
            destination.bankCountry = banksArray![self.selectedRow!].country
            destination.bankCurrency = banksArray![self.selectedRow!].currency
            destination.bankRoutingNumer = banksArray![self.selectedRow!].routing_number
            destination.bankVerificationStatus = banksArray![self.selectedRow!].status
            destination.detailUser = detailUser
            destination.detailAmount = detailAmount
            destination.planId = planId
            destination.paymentType = paymentType
            
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.banksArray?.count ?? 0
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = self.tableView.dequeueReusableCellWithIdentifier("connectedBankACHCell", forIndexPath: indexPath) as! BankACHConnectedCell

        cell.backgroundColor = UIColor.whiteColor()
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