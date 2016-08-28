//
//  MenuChildViewControllerTwo.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 8/6/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import XLPagerTabStrip
import KeychainSwift

class MenuChildViewControllerTwo: UIViewController, IndicatorInfoProvider {
    
    var itemInfo: IndicatorInfo = "View"
    
    let btnViewCustomers = UIButton()

    let btnViewPlans = UIButton()

    let btnViewSubscriptions = UIButton()

    init(itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.offWhite()
        
        configureView()
    }
    
    func configureView() {
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        let scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight+100)
        scrollView.bounces = true
        scrollView.alwaysBounceVertical = true
        scrollView.scrollEnabled = true
        self.view.addSubview(scrollView)
        
        self.loadCustomerList { (customers, err) in
            if customers?.count > 99 {
                let str1 = adjustAttributedString("VIEW CUSTOMERS (100+)", spacing: 1, fontName: "SFUIText-Regular", fontSize: 12, fontColor: UIColor.darkBlue(), lineSpacing: 0.0, alignment: .Left)
                let str1w = adjustAttributedString("VIEW CUSTOMERS (100+)", spacing: 1, fontName: "SFUIText-Regular", fontSize: 12, fontColor: UIColor.whiteColor(), lineSpacing: 0.0, alignment: .Left)
                self.btnViewCustomers.setAttributedTitle(str1, forState: .Normal)
                self.btnViewCustomers.setAttributedTitle(str1w, forState: .Highlighted)
            } else {
                let str1 = adjustAttributedString("VIEW CUSTOMERS (" + String(customers!.count) + ")", spacing: 1, fontName: "SFUIText-Regular", fontSize: 12, fontColor: UIColor.darkBlue(), lineSpacing: 0.0, alignment: .Left)
                let str1w = adjustAttributedString("VIEW CUSTOMERS (" + String(customers!.count) + ")", spacing: 1, fontName: "SFUIText-Regular", fontSize: 12, fontColor: UIColor.whiteColor(), lineSpacing: 0.0, alignment: .Left)
                self.btnViewCustomers.setAttributedTitle(str1, forState: .Normal)
                self.btnViewCustomers.setAttributedTitle(str1w, forState: .Highlighted)
            }
        }
        btnViewCustomers.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
        btnViewCustomers.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
        btnViewCustomers.contentHorizontalAlignment = .Left
        btnViewCustomers.setBackgroundColor(UIColor.oceanBlue(), forState: .Highlighted)
        btnViewCustomers.frame = CGRect(x: 15, y: 30, width: screenWidth-30, height: 60)
        btnViewCustomers.layer.cornerRadius = 3
        btnViewCustomers.layer.masksToBounds = true
        btnViewCustomers.layer.borderColor = UIColor.lightBlue().colorWithAlphaComponent(0.2).CGColor
        btnViewCustomers.layer.borderWidth = 1
        btnViewCustomers.backgroundColor = UIColor.whiteColor()
        btnViewCustomers.addTarget(self, action: #selector(viewCustomersButtonSelected(_:)), forControlEvents: .TouchUpInside)
        scrollView.addSubview(btnViewCustomers)
        scrollView.bringSubviewToFront(btnViewCustomers)
        //        btnViewCustomers.setImage(UIImage(named: "IconCard"), inFrame: CGRectMake(18, 18, 64, 64), forState: .Normal)
        //        btnViewCustomers.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: btnViewCustomers.frame.width-20, bottom: 0.0, right: 10.0)
        
        self.loadPlanList("100", starting_after: "") { (plans, err) in
            let str2 = adjustAttributedString("VIEW PLANS (" + String(plans!.count) + ")", spacing: 1, fontName: "SFUIText-Regular", fontSize: 12, fontColor: UIColor.darkBlue(), lineSpacing: 0.0, alignment: .Left)
            let str2w = adjustAttributedString("VIEW PLANS (" + String(plans!.count) + ")", spacing: 1, fontName: "SFUIText-Regular", fontSize: 12, fontColor: UIColor.whiteColor(), lineSpacing: 0.0, alignment: .Left)
            self.btnViewPlans.setAttributedTitle(str2, forState: .Normal)
            self.btnViewPlans.setAttributedTitle(str2w, forState: .Highlighted)
        }
        btnViewPlans.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
        btnViewPlans.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
        btnViewPlans.contentHorizontalAlignment = .Left
        btnViewPlans.setBackgroundColor(UIColor.oceanBlue(), forState: .Highlighted)
        btnViewPlans.frame = CGRect(x: 15, y: 100, width: screenWidth-30, height: 60)
        btnViewPlans.layer.cornerRadius = 3
        btnViewPlans.layer.masksToBounds = true
        btnViewPlans.layer.borderColor = UIColor.lightBlue().colorWithAlphaComponent(0.2).CGColor
        btnViewPlans.layer.borderWidth = 1
        btnViewPlans.backgroundColor = UIColor.whiteColor()
        btnViewPlans.addTarget(self, action: #selector(viewPlansButtonSelected(_:)), forControlEvents: .TouchUpInside)
        scrollView.addSubview(btnViewPlans)
        scrollView.bringSubviewToFront(btnViewPlans)
        
        self.loadSubscriptionList { (subscriptions, err) in
            let str3 = adjustAttributedString("VIEW SUBSCRIPTIONS (" + String(subscriptions!.count) + ")", spacing: 1, fontName: "SFUIText-Regular", fontSize: 12, fontColor: UIColor.darkBlue(), lineSpacing: 0.0, alignment: .Left)
            let str3w = adjustAttributedString("VIEW SUBSCRIPTIONS (" + String(subscriptions!.count) + ")", spacing: 1, fontName: "SFUIText-Regular", fontSize: 12, fontColor: UIColor.whiteColor(), lineSpacing: 0.0, alignment: .Left)
            self.btnViewSubscriptions.setAttributedTitle(str3, forState: .Normal)
            self.btnViewSubscriptions.setAttributedTitle(str3w, forState: .Highlighted)
        }
        btnViewSubscriptions.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
        btnViewSubscriptions.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
        btnViewSubscriptions.contentHorizontalAlignment = .Left
        btnViewSubscriptions.setBackgroundColor(UIColor.oceanBlue(), forState: .Highlighted)
        btnViewSubscriptions.frame = CGRect(x: 15, y: 170, width: screenWidth-30, height: 60)
        btnViewSubscriptions.layer.cornerRadius = 3
        btnViewSubscriptions.layer.masksToBounds = true
        btnViewSubscriptions.layer.borderColor = UIColor.lightBlue().colorWithAlphaComponent(0.2).CGColor
        btnViewSubscriptions.layer.borderWidth = 1
        btnViewSubscriptions.backgroundColor = UIColor.whiteColor()
        btnViewSubscriptions.addTarget(self, action: #selector(viewSubscriptionsButtonSelected(_:)), forControlEvents: .TouchUpInside)
        scrollView.addSubview(btnViewSubscriptions)
        scrollView.bringSubviewToFront(btnViewSubscriptions)
    }
    
    func viewCustomersButtonSelected(sender: AnyObject) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CustomersListTableViewController") as! CustomersListTableViewController
        self.presentViewController(vc, animated: true) { }
    }
    
    func viewPlansButtonSelected(sender: AnyObject) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("PlansListTableViewController") as! PlansListTableViewController
        self.presentViewController(vc, animated: true) { }
    }
    
    func viewSubscriptionsButtonSelected(sender: AnyObject) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SubscriptionsListTableViewController") as! SubscriptionsListTableViewController
        self.presentViewController(vc, animated: true) { }
    }
    
    // MARK: DATA

    // Load user data lists for customer and plan
    private func loadCustomerList(completionHandler: ([Customer]?, NSError?) -> ()) {
        Customer.getCustomerList("100", starting_after: "", completionHandler: { (customers, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "Could not load customers \(error?.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            print(customers?.count)
            completionHandler(customers!, error)
        })
    }

    private func loadPlanList(limit: String, starting_after: String, completionHandler: ([Plan]?, NSError?) -> ()) {
        Plan.getPlanList(limit, starting_after: starting_after, completionHandler: { (plans, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "Could not load plans \(error?.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            print(plans?.count)
            completionHandler(plans!, error)
        })
    }

    private func loadSubscriptionList(completionHandler: ([Subscription]?, NSError?) -> ()) {
        Subscription.getSubscriptionList({ (subscriptions, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "Could not load subscriptions \(error?.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            print(subscriptions?.count)
            completionHandler(subscriptions!, error)
        })
    }

    // MARK: - IndicatorInfoProvider
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
