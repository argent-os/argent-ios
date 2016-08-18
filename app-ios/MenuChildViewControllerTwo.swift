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
        
        let str1 = adjustAttributedString("VIEW SUBSCRIBERS", spacing: 1, fontName: "SFUIText-Regular", fontSize: 13, fontColor: UIColor.darkBlue(), lineSpacing: 0.0, alignment: .Left)
        let str1w = adjustAttributedString("VIEW SUBSCRIBERS", spacing: 1, fontName: "SFUIText-Regular", fontSize: 13, fontColor: UIColor.whiteColor(), lineSpacing: 0.0, alignment: .Left)
        btnViewCustomers.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
        btnViewCustomers.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
        btnViewCustomers.contentHorizontalAlignment = .Left
        btnViewCustomers.setAttributedTitle(str1, forState: .Normal)
        btnViewCustomers.setAttributedTitle(str1w, forState: .Highlighted)
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
        
        let str2 = adjustAttributedString("VIEW PLANS", spacing: 1, fontName: "SFUIText-Regular", fontSize: 13, fontColor: UIColor.darkBlue(), lineSpacing: 0.0, alignment: .Left)
        let str2w = adjustAttributedString("VIEW PLANS", spacing: 1, fontName: "SFUIText-Regular", fontSize: 13, fontColor: UIColor.whiteColor(), lineSpacing: 0.0, alignment: .Left)
        btnViewPlans.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
        btnViewPlans.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
        btnViewPlans.contentHorizontalAlignment = .Left
        btnViewPlans.setAttributedTitle(str2, forState: .Normal)
        btnViewPlans.setAttributedTitle(str2w, forState: .Highlighted)
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
        
        let str3 = adjustAttributedString("VIEW SUBSCRIPTIONS", spacing: 1, fontName: "SFUIText-Regular", fontSize: 13, fontColor: UIColor.darkBlue(), lineSpacing: 0.0, alignment: .Left)
        let str3w = adjustAttributedString("VIEW SUBSCRIPTIONS", spacing: 1, fontName: "SFUIText-Regular", fontSize: 13, fontColor: UIColor.whiteColor(), lineSpacing: 0.0, alignment: .Left)

        btnViewSubscriptions.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
        btnViewSubscriptions.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
        btnViewSubscriptions.contentHorizontalAlignment = .Left
        btnViewSubscriptions.setAttributedTitle(str3, forState: .Normal)
        btnViewSubscriptions.setAttributedTitle(str3w, forState: .Highlighted)
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
    
    // MARK: - IndicatorInfoProvider
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
