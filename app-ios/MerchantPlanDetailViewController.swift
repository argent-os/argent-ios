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
        
        planTitleLabel.frame = CGRect(x: 40, y: 20, width: 300-80, height: 100)
        planTitleLabel.text = planName
        planTitleLabel.font = UIFont(name: "DINAlternate-Bold", size: 24)
        planTitleLabel.textAlignment = .Center
        planTitleLabel.textColor = UIColor.lightBlue()
        addSubviewWithBounce(planTitleLabel, parentView: self)
        
        circleView.frame = CGRect(x: 90, y: 130, width: 120, height: 120)
        circleView.backgroundColor = UIColor.clearColor()
        circleView.layer.cornerRadius = circleView.frame.height/2
        circleView.layer.borderColor = UIColor.lightBlue().colorWithAlphaComponent(0.5).CGColor
        circleView.layer.borderWidth = 1
        addSubviewWithBounce(circleView, parentView: self)
        
        planAmountLabel.frame = CGRect(x: 40, y: 105, width: 300-80, height: 150)
        planAmountLabel.attributedText = formatCurrency(planAmount!, fontName: "DINAlternate-Bold", superSize: 16, fontSize: 24, offsetSymbol: 5, offsetCents: 5)
        planAmountLabel.textAlignment = .Center
        planAmountLabel.textColor = UIColor.lightBlue().colorWithAlphaComponent(0.5)
        addSubviewWithBounce(planAmountLabel, parentView: self)
        if Int(planAmount!)! > 1000000 {
            planAmountLabel.attributedText = formatCurrency(planAmount!, fontName: "DINAlternate-Bold", superSize: 12, fontSize: 18, offsetSymbol: 3, offsetCents: 3)
        }
        
        planIntervalLabel.frame = CGRect(x: 40, y: 160, width: 300-80, height: 100)
        planIntervalLabel.text = "per " + planInterval!
        planIntervalLabel.font = UIFont(name: "DINAlternate-Bold", size: 12)
        planIntervalLabel.textAlignment = .Center
        planIntervalLabel.textColor = UIColor.lightBlue().colorWithAlphaComponent(0.5)
        addSubviewWithBounce(planIntervalLabel, parentView: self)
        
        planStatementDescriptorLabel.frame = CGRect(x: 40, y: 210, width: 300-80, height: 200)
        planStatementDescriptorLabel.numberOfLines = 8
        planStatementDescriptorLabel.font = UIFont(name: "DINAlternate-Bold", size: 12)
        planStatementDescriptorLabel.textAlignment = .Center
        planStatementDescriptorLabel.textColor = UIColor.lightBlue().colorWithAlphaComponent(0.7)
        addSubviewWithBounce(planStatementDescriptorLabel, parentView: self)
        if planStatementDescriptor == "" {
            planStatementDescriptorLabel.text = "No plan description provided for plan " + planName!
        } else {
            planStatementDescriptorLabel.text = planStatementDescriptor
        }

    }
    
//    func shouldUseContentViewFrameForPresentationController(presentationController: MZFormSheetPresentationController) -> Bool {
//        return true
//    }
//    
//    func contentViewFrameForPresentationController(presentationController: MZFormSheetPresentationController, currentFrame: CGRect) -> CGRect {
//        print(currentFrame.size.height)
//        print(currentFrame.origin.y)
//        var currentFrame = currentFrame
//        currentFrame.size.height = 250
//        currentFrame.origin.y = 20
//        return currentFrame
//    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

}