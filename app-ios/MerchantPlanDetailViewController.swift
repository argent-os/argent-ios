//
//  MerchantPlanDetailViewController.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 5/29/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import MZFormSheetPresentationController

class MerchantPlanDetailViewController: UIViewController {
    
    var planName:String?

    var planAmount:String?

    var planInterval:String?

    var planStatementDescriptor:String?

    var planTitleLabel = UILabel()

    var planStatementDescriptorLabel = UILabel()

    var planAmountLabel = UILabel()

    var planIntervalLabel = UILabel()

    var circleView = UIView()

    private let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutViews()
    }
    
    func layoutViews() {
                
        self.navigationController?.navigationBar.tintColor = UIColor.lightBlue()
        self.navigationController?.navigationBar.topItem!.backBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
        
        planTitleLabel.frame = CGRect(x: 0, y: 20, width: 310, height: 100)
        planTitleLabel.text = planName
        planTitleLabel.font = UIFont(name: "MyriadPro-Regular", size: 24)
        planTitleLabel.textAlignment = .Center
        planTitleLabel.textColor = UIColor.lightBlue()
        addSubviewWithBounce(planTitleLabel, parentView: self, duration: 0.3)
        
        circleView.frame = CGRect(x: (310-120)/2, y: 130, width: 120, height: 120)
        circleView.backgroundColor = UIColor.clearColor()
        circleView.layer.cornerRadius = circleView.frame.height/2
        circleView.layer.borderColor = UIColor.lightBlue().colorWithAlphaComponent(0.5).CGColor
        circleView.layer.borderWidth = 1
        addSubviewWithBounce(circleView, parentView: self, duration: 0.8)
        
        planAmountLabel.frame = CGRect(x: 0, y: 105, width: 310, height: 150)
        planAmountLabel.attributedText = formatCurrency(planAmount!, fontName: "MyriadPro-Regular", superSize: 16, fontSize: 24, offsetSymbol: 5, offsetCents: 5)
        planAmountLabel.textAlignment = .Center
        planAmountLabel.textColor = UIColor.lightBlue().colorWithAlphaComponent(0.9)
        addSubviewWithBounce(planAmountLabel, parentView: self, duration: 0.3)
        if Int(planAmount!)! > 1000000 {
            planAmountLabel.attributedText = formatCurrency(planAmount!, fontName: "MyriadPro-Regular", superSize: 12, fontSize: 18, offsetSymbol: 3, offsetCents: 3)
        }
        
        planIntervalLabel.frame = CGRect(x: 0, y: 160, width: 310, height: 100)
        planIntervalLabel.text = "per " + planInterval!
        planIntervalLabel.font = UIFont(name: "MyriadPro-Regular", size: 12)
        planIntervalLabel.textAlignment = .Center
        planIntervalLabel.textColor = UIColor.lightBlue().colorWithAlphaComponent(0.7)
        addSubviewWithBounce(planIntervalLabel, parentView: self, duration: 0.3)
        
        planStatementDescriptorLabel.frame = CGRect(x: 0, y: 210, width: 310, height: 200)
        planStatementDescriptorLabel.numberOfLines = 0
        planStatementDescriptorLabel.font = UIFont(name: "MyriadPro-Regular", size: 12)
        planStatementDescriptorLabel.textAlignment = .Center
        planStatementDescriptorLabel.textColor = UIColor.lightBlue().colorWithAlphaComponent(0.7)
        addSubviewWithBounce(planStatementDescriptorLabel, parentView: self, duration: 0.3)
        if planStatementDescriptor == "" {
            planStatementDescriptorLabel.text = "No statement descriptor provided \nfor plan " + planName!
        } else {
            planStatementDescriptorLabel.text = planStatementDescriptor
        }

    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

}