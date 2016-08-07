//
//  MenuChildViewControllerTwo.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 8/6/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import XLPagerTabStrip

class MenuChildViewControllerTwo: UIViewController, IndicatorInfoProvider {
    
    var itemInfo: IndicatorInfo = "View"
    
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
        
        let btnViewCustomers = UIButton()
        let str1 = NSAttributedString(string: "View Customers", attributes: [
            NSForegroundColorAttributeName : UIColor.oceanBlue(),
            NSFontAttributeName : UIFont(name: "MyriadPro-Regular", size: 15)!
            ])
        btnViewCustomers.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
        btnViewCustomers.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
        btnViewCustomers.contentHorizontalAlignment = .Left
        btnViewCustomers.setAttributedTitle(str1, forState: .Normal)
        btnViewCustomers.setBackgroundColor(UIColor.whiteColor().lighterColor(), forState: .Highlighted)
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
        
        let btnViewPlans = UIButton()
        let str2 = NSAttributedString(string: "View Plans", attributes: [
            NSForegroundColorAttributeName : UIColor.oceanBlue(),
            NSFontAttributeName : UIFont(name: "MyriadPro-Regular", size: 15)!
            ])
        btnViewPlans.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
        btnViewPlans.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
        btnViewPlans.contentHorizontalAlignment = .Left
        btnViewPlans.setAttributedTitle(str2, forState: .Normal)
        btnViewPlans.setBackgroundColor(UIColor.whiteColor().lighterColor(), forState: .Highlighted)
        btnViewPlans.frame = CGRect(x: 15, y: 100, width: screenWidth-30, height: 60)
        btnViewPlans.layer.cornerRadius = 3
        btnViewPlans.layer.masksToBounds = true
        btnViewPlans.layer.borderColor = UIColor.lightBlue().colorWithAlphaComponent(0.2).CGColor
        btnViewPlans.layer.borderWidth = 1
        btnViewPlans.backgroundColor = UIColor.whiteColor()
        btnViewPlans.addTarget(self, action: #selector(viewPlansButtonSelected(_:)), forControlEvents: .TouchUpInside)
        scrollView.addSubview(btnViewPlans)
        scrollView.bringSubviewToFront(btnViewPlans)
        
        let btnViewSubscriptions = UIButton()
        let str3 = NSAttributedString(string: "View Subscriptions", attributes: [
            NSForegroundColorAttributeName : UIColor.oceanBlue(),
            NSFontAttributeName : UIFont(name: "MyriadPro-Regular", size: 15)!
            ])
        btnViewSubscriptions.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
        btnViewSubscriptions.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
        btnViewSubscriptions.contentHorizontalAlignment = .Left
        btnViewSubscriptions.setAttributedTitle(str3, forState: .Normal)
        btnViewSubscriptions.setBackgroundColor(UIColor.whiteColor().lighterColor(), forState: .Highlighted)
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
        self.presentViewController(CustomersListTableViewController(), animated: true) { }
    }
    
    func viewPlansButtonSelected(sender: AnyObject) {
        self.presentViewController(PlansListTableViewController(), animated: true) { }
    }
    
    func viewSubscriptionsButtonSelected(sender: AnyObject) {
        self.presentViewController(SubscriptionsListTableViewController(), animated: true) { }
    }
    
    // MARK: - IndicatorInfoProvider
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
