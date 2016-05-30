//
//  MerchantPlansViewController.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 5/27/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import MZFormSheetPresentationController
import XLActionController
import Alamofire
import Stripe
import SwiftyJSON
import JGProgressHUD
import JSSAlertView
import DZNEmptyDataSet
import CellAnimator

class MerchantPlansViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    private var dateFormatter = NSDateFormatter()
    
    private var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    private var merchantLabel:UILabel = UILabel()
    
    private var tableView = UITableView()
    
    private var plansArray:Array<Plan>?

    private var cellReuseIdendifier = "idCellMerchantPlan"
    
    private var selectedRow: Int?
    
    var detailUser: User? {
        didSet {
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        self.childViewControllerForStatusBarStyle()?.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    func configure() {
        
        // This will set to only one instance
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.layer.borderWidth = 1
        self.view.layer.masksToBounds = true
        // border radius
        self.view.layer.cornerRadius = 10.0
        // border
        self.view.layer.borderColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.2).CGColor
        self.view.layer.borderWidth = 1
        // drop shadow
        self.view.layer.shadowColor = UIColor.blackColor().CGColor
        self.view.layer.shadowOpacity = 0.8
        self.view.layer.shadowRadius = 3.0
        self.view.layer.shadowOffset = CGSizeMake(2.0, 2.0)
        
        
        // screen width and height:
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.barTintColor = UIColor.lightGrayColor()
        
        //Looks for single or multiple taps.  Close keyboard on tap
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewPlanDetails(_:)))
//        view.addGestureRecognizer(tap)
        
        activityIndicator.center = tableView.center
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        
        tableView.registerClass(MerchantPlanCell.self, forCellReuseIdentifier: cellReuseIdendifier)
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        // test empty works
        // tableView.emptyDataSetSource = self
        // tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        tableView.reloadData()
        tableView.showsVerticalScrollIndicator = false
        print(self.view.frame.height)
        tableView.frame = CGRect(x: 0, y: 50, width: 300, height: 260)
        self.view.addSubview(tableView)
        
        self.dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        self.dateFormatter.timeStyle = NSDateFormatterStyle.LongStyle
        
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        navBar.barTintColor = UIColor.offWhite()
        navBar.translucent = false
        navBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.lightBlue(),
            NSFontAttributeName : UIFont(name: "DINAlternate-Bold", size: 18)!
        ]
        self.view.addSubview(navBar);
        let navItem = UINavigationItem(title: "Plans");
        navBar.setItems([navItem], animated: false);
        
        self.loadPlans()
    }
    
    private func loadPlans() {
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        // self.view.addSubview(activityIndicator)
        Plan.getDelegatedPlanList((detailUser?.username)!, completionHandler: { (plans, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "Could not load plans \(error?.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            self.plansArray = plans
            self.activityIndicator.stopAnimating()
            
            // sets empty data set if data is nil
            self.tableView.emptyDataSetSource = self
            self.tableView.emptyDataSetDelegate = self
            self.tableView.tableFooterView = UIView()
            self.tableView.reloadData()
        })
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.plansArray?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdendifier, forIndexPath: indexPath) as! MerchantPlanCell
        
        CellAnimator.animateCell(cell, withTransform: CellAnimator.TransformTilt, andDuration: 0.3)

        if let name = plansArray![indexPath.row].name {
            cell.planNameLabel.text = name
        }
        if let amount = plansArray![indexPath.row].amount, let interval = plansArray![indexPath.row].interval {
            let fc = formatCurrency(amount, fontName: "DINAlternate-Bold", superSize: 11, fontSize: 14, offsetSymbol: 2, offsetCents: 2)
            
            let attrs: [String: AnyObject] = [
                NSForegroundColorAttributeName : UIColor.lightBlue().colorWithAlphaComponent(0.5),
                NSFontAttributeName : UIFont(name: "DINAlternate-Bold", size: 12)!
            ]
            
            let attrs2: [String: AnyObject] = [
                NSForegroundColorAttributeName : UIColor.brandGreen(),
                NSFontAttributeName : UIFont(name: "DINAlternate-Bold", size: 14)!
            ]
            
            cell.planButton.attributedNormalTitle = fc
            cell.planButton.attributedConfirmationTitle = NSAttributedString(string: "Confirm", attributes: attrs2)
            
            switch interval {
            case "day":
                let interval = NSAttributedString(string: " / day", attributes: attrs)
                cell.planAmountLabel.attributedText = fc + interval
            case "week":
                let interval = NSAttributedString(string: " / wk", attributes: attrs)
                cell.planAmountLabel.attributedText = fc + interval
            case "month":
                let interval = NSAttributedString(string: " / mo", attributes: attrs)
                cell.planAmountLabel.attributedText = fc + interval
            case "year":
                let interval = NSAttributedString(string: " / yr", attributes: attrs)
                cell.planAmountLabel.attributedText = fc + interval
            default:
                let interval = NSAttributedString(string: " / " + interval, attributes: attrs)
                cell.planAmountLabel.attributedText = fc + interval
            }
        }

        //let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(subscribeToPlan(_:)))
        //cell.planButton.addGestureRecognizer(tap)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.selectedRow = indexPath.row
        self.performSegueWithIdentifier("viewPlanDetail", sender: self)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "viewPlanDetail" {
            let destination = segue.destinationViewController as! MerchantPlanDetailViewController
            guard let name = plansArray![self.selectedRow!].name else {
                return
            }
            guard let amount = plansArray![self.selectedRow!].amount else {
                return
            }
            guard let interval = plansArray![self.selectedRow!].interval else {
                return
            }
            guard let desc = plansArray![self.selectedRow!].statement_desc else {
                return
            }
            destination.planName = name
            destination.planAmount = amount
            destination.planInterval = interval
            destination.planStatementDescriptor = desc
        }
    }
    
    func subscribeToPlan(sender: AnyObject) {
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    
    // MARK: DZNEmptyDataSet delegate
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = ""
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "This user does not have any currently available plans."
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "IconEmptyPlans")
    }
    
    func buttonTitleForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> NSAttributedString! {
        let str = ""
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleCallout)]
        return NSAttributedString(string: str, attributes: attrs)
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