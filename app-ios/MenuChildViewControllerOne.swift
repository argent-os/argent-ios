//
//  MenuChildViewControllerOne.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 8/6/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import XLPagerTabStrip
import KeychainSwift

class MenuChildViewControllerOne: UIViewController, IndicatorInfoProvider {
    
    var itemInfo: IndicatorInfo = "View"
    
    let btnAcceptPayment = UIButton()

    let btnCreatePlan = UIButton()

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
        
        let str1 = adjustAttributedString("ACCEPT PAYMENT", spacing: 1, fontName: "MyriadPro-Regular", fontSize: 13, fontColor: UIColor.whiteColor(), lineSpacing: 0.0, alignment: .Left)
        btnAcceptPayment.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
        btnAcceptPayment.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
        btnAcceptPayment.contentHorizontalAlignment = .Left
        btnAcceptPayment.setAttributedTitle(str1, forState: .Normal)
        btnAcceptPayment.setBackgroundColor(UIColor.pastelBlue().darkerColor(), forState: .Normal)
        btnAcceptPayment.setBackgroundColor(UIColor.pastelBlue().lighterColor(), forState: .Highlighted)
        btnAcceptPayment.frame = CGRect(x: 15, y: 30, width: screenWidth-30, height: 60)
        btnAcceptPayment.layer.cornerRadius = 3
        btnAcceptPayment.layer.masksToBounds = true
        btnAcceptPayment.layer.borderColor = UIColor.lightBlue().colorWithAlphaComponent(0.2).CGColor
        btnAcceptPayment.layer.borderWidth = 1
        btnAcceptPayment.addTarget(self, action: #selector(terminalButtonSelected(_:)), forControlEvents: .TouchUpInside)
        scrollView.addSubview(btnAcceptPayment)
        scrollView.bringSubviewToFront(btnAcceptPayment)
        //        btnAcceptPayment.setImage(UIImage(named: "IconCard"), inFrame: CGRectMake(18, 18, 64, 64), forState: .Normal)
        //        btnAcceptPayment.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: btnAcceptPayment.frame.width-20, bottom: 0.0, right: 10.0)
        
        let str2 = adjustAttributedString("CREATE BILLING PLAN", spacing: 1, fontName: "MyriadPro-Regular", fontSize: 13, fontColor: UIColor.whiteColor(), lineSpacing: 0.0, alignment: .Left)
        btnCreatePlan.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
        btnCreatePlan.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
        btnCreatePlan.contentHorizontalAlignment = .Left
        btnCreatePlan.setAttributedTitle(str2, forState: .Normal)
        btnCreatePlan.setBackgroundColor(UIColor.oceanBlue().lighterColor(), forState: .Highlighted)
        btnCreatePlan.frame = CGRect(x: 15, y: 100, width: screenWidth-30, height: 60)
        btnCreatePlan.layer.cornerRadius = 3
        btnCreatePlan.layer.masksToBounds = true
        btnCreatePlan.layer.borderColor = UIColor.lightBlue().colorWithAlphaComponent(0.2).CGColor
        btnCreatePlan.layer.borderWidth = 1
        btnCreatePlan.backgroundColor = UIColor.oceanBlue()
        btnCreatePlan.addTarget(self, action: #selector(planButtonSelected(_:)), forControlEvents: .TouchUpInside)
        scrollView.addSubview(btnCreatePlan)
        scrollView.bringSubviewToFront(btnCreatePlan)
        
    }
    
    func terminalButtonSelected(sender: AnyObject) {
        self.presentViewController(ChargeViewController(), animated: true) { 

        }
    }
    
    func planButtonSelected(sender: AnyObject) {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("RecurringBillingViewController") as! RecurringBillingViewController
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    // MARK: - IndicatorInfoProvider
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
