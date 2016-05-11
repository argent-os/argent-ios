//
//  RiskScoreViewController.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 5/11/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import GaugeKit
import KeychainSwift
import MZFormSheetPresentationController

class RiskScoreViewController: UIViewController {
    
    let g = Gauge()

    let l = Gauge()
    
    let lbl = UILabel()
    
    let bg = UIImageView()
    
    let titleLabel = UILabel()
    
    let info = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        setData()
    }

    func configureView() {
        
        g.frame = CGRect(x: 50, y: 80, width: self.view.layer.frame.width-100, height: 250)
        g.startColor = UIColor.greenColor()
        g.contentMode = .ScaleAspectFit
        g.bgColor = UIColor.blackColor()
        g.shadowRadius = 40
        g.shadowOpacity = 0.01
        g.lineWidth = 2
        g.maxValue = 100
        self.view.addSubview(g)
        
        l.frame = CGRect(x: 100, y: 250, width: self.view.layer.frame.width-200, height: 600)
        l.type = .Right
        l.rotate = 135
        l.contentMode = .ScaleAspectFit
        l.shadowRadius = 40
        l.shadowOpacity = 0.01
        l.lineWidth = 20
        l.maxValue = 100
        self.view.addSubview(l)
        
        lbl.frame = CGRect(x: 50, y: 60, width: self.view.layer.frame.width-100, height: 250)
        lbl.textColor = UIColor.whiteColor()
        lbl.textAlignment = .Center
        lbl.font = UIFont(name: "AvenirNext-UltraLight", size: 36)
        self.view.addSubview(lbl)
        
        titleLabel.frame = CGRect(x: 50, y: 100, width: self.view.layer.frame.width-100, height: 250)
        titleLabel.text = "Risk Score"
        titleLabel.alpha = 0.5
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont(name: "Avenir-Light", size: 14)
        self.view.addSubview(titleLabel)
        
        bg.frame = CGRect(x: 0, y: 0, width: self.view.frame.width+1, height: self.view.frame.height-250)
        bg.image = UIImage(named: "BackgroundGradientInverseCurved")
        bg.contentMode = .ScaleAspectFill
        self.view.addSubview(bg)
        self.view.sendSubviewToBack(bg)
        
        info.frame = CGRect(x: self.view.frame.width/2-13, y: self.view.frame.height-136, width: 26, height: 26)
        info.setBackgroundImage(UIImage(named: "ic_question"), forState: .Normal)
        info.contentMode = .ScaleAspectFit
        info.addTarget(self, action: #selector(RiskScoreViewController.showInfoModal(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(info)
        
    }
    
    func setData() {
        let score = KeychainSwift().get("riskScore")
        if score != nil, let floatScore = Float(score!) {
            lbl.text = "91"
            g.rate = 91
            l.rate = 91
            
            if(g.rate == 100) {
                g.startColor = UIColor.lightBlue()
                l.startColor = UIColor.lightBlue()
                l.endColor = UIColor.mediumBlue()
                titleLabel.text = "Perfect Risk Score!"
            }
            else if(g.rate >= 79) {
                g.startColor = UIColor.greenColor()
                l.startColor = UIColor.greenColor()
                l.endColor = UIColor.lightBlue()
                titleLabel.text = "Great Risk Score"
            } else if(g.rate > 59) {
                g.startColor = UIColor.yellowColor()
                l.startColor = UIColor.yellowColor()
                l.endColor = UIColor.orangeColor()
                titleLabel.text = "Good Risk Score"
            } else if(g.rate > 39) {
                g.startColor = UIColor.orangeColor()
                l.startColor = UIColor.orangeColor()
                l.endColor = UIColor.yellowColor()
                titleLabel.text = "Average Risk Score"
            } else {
                g.startColor = UIColor.redColor()
                l.startColor = UIColor.redColor()
                l.endColor = UIColor.redColor()
                titleLabel.text = "Poor Risk Score"
            }
        } else {
            lbl.text = "N/A"
            g.startColor = UIColor.darkBlue()
            g.rate = 100
            l.rate = 100
        }

    }
    
    // MARK: Tutorial modal
    
    func showInfoModal(sender: AnyObject) {
        let navigationController = self.storyboard!.instantiateViewControllerWithIdentifier("infoModalNavigationController") as! UINavigationController
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: navigationController)
        
        // Initialize and style the terms and conditions modal
        formSheetController.presentationController?.shouldApplyBackgroundBlurEffect = true
        formSheetController.presentationController?.contentViewSize = CGSizeMake(300, 300)
        formSheetController.presentationController?.shouldUseMotionEffect = true
        formSheetController.presentationController?.containerView?.backgroundColor = UIColor.blackColor()
        formSheetController.presentationController?.containerView?.sizeToFit()
        formSheetController.presentationController?.blurEffectStyle = UIBlurEffectStyle.Light
        formSheetController.presentationController?.shouldDismissOnBackgroundViewTap = true
        formSheetController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyle.SlideFromBottom
        formSheetController.contentViewCornerRadius = 10
        formSheetController.allowDismissByPanningPresentedView = true
        formSheetController.interactivePanGestureDismissalDirection = .All;
        
        // Blur will be applied to all MZFormSheetPresentationControllers by default
        MZFormSheetPresentationController.appearance().shouldApplyBackgroundBlurEffect = true
        
        let presentedViewController = navigationController.viewControllers.first as! RiskTutorialViewController
        
        // keep passing along user data to modal
        presentedViewController.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
        presentedViewController.navigationItem.leftItemsSupplementBackButton = true
        
        // Be sure to update current module on storyboard
        self.presentViewController(formSheetController, animated: true, completion: nil)
    }
    
}