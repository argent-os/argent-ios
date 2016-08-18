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
import Crashlytics
import EasyTipView

class RiskScoreViewController: UIViewController {
    
    let g = Gauge()

    let l = Gauge()
    
    let lbl = UILabel()
    
    let bg = UIImageView()
    
    let titleLabel = UILabel()
    
    let info = UIButton()
    
    let c = UIImageView()
    
    private var tipView = EasyTipView(text: "This is your risk profile. It's value ranges from 0-100 and provides an overall risk assessment based on your financial situation among other proprietary calculations.  The current risk profile values are Perfect, Great, Good, Average, and Poor. Contact support for more information regarding risk profiling.", preferences: EasyTipView.globalPreferences)

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        setData()
    }
    
    override func viewDidAppear(animated: Bool) {
        Answers.logCustomEventWithName("Risk Interest",
                                       customAttributes: ["type": "risk_profile_demo_view"])
    }
    
    //Changing Status Bar
//    override func prefersStatusBarHidden() -> Bool {
//        return false
//    }
//    
//    override func preferredStatusBarStyle() -> UIStatusBarStyle {
//        return .LightContent
//    }
    
    
    func configureView() {
        
        self.view.backgroundColor = UIColor.globalBackground()
//        self.navigationController?.navigationBar.tintColor = UIColor.lightBlue()

        g.frame = CGRect(x: 60, y: 84, width: self.view.layer.frame.width-120, height: 230)
        g.startColor = UIColor.greenColor()
        g.contentMode = .ScaleAspectFit
        g.bgColor = UIColor.offWhite()
        g.shadowRadius = 40
        g.shadowOpacity = 0.01
        g.lineWidth = 3
        g.maxValue = 100
        addSubviewWithFade(g, parentView: self, duration: 0.5)
        self.view.bringSubviewToFront(g)
        
        l.frame = CGRect(x: 100, y: 350, width: self.view.layer.frame.width-200, height: 100)
        l.type = .Line
        l.contentMode = .ScaleAspectFit
        l.shadowRadius = 40
        l.shadowOpacity = 0.01
        l.lineWidth = 3
        l.maxValue = 100
        addSubviewWithFade(l, parentView: self, duration: 0.3)

        c.frame = CGRect(x: 50, y: 80, width: self.view.layer.frame.width-100, height: 250)
        c.image = UIImage(named: "BackgroundCircleWhite")
        c.contentMode = .ScaleAspectFill
        addSubviewWithFade(c, parentView: self, duration: 0.5)
        self.view.sendSubviewToBack(c)
        
        lbl.frame = CGRect(x: 50, y: 60, width: self.view.layer.frame.width-100, height: 250)
        lbl.textColor = UIColor.lightBlue()
        lbl.textAlignment = .Center
        lbl.font = UIFont(name: "SFUIText-Regular", size: 36)
        let _ = Timeout(0.5) {
            addSubviewWithBounce(self.lbl, parentView: self, duration: 0.4)
        }
        
        titleLabel.frame = CGRect(x: 50, y: 100, width: self.view.layer.frame.width-100, height: 250)
        titleLabel.text = "Risk Score"
        titleLabel.alpha = 0.5
        titleLabel.textColor = UIColor.lightBlue()
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont(name: "SFUIText-Regular", size: 14)
        let _ = Timeout(0.3) {
            addSubviewWithBounce(self.titleLabel, parentView: self, duration: 0.4)
        }
        
        bg.frame = CGRect(x: 0, y: 0, width: self.view.frame.width+1, height: self.view.frame.height-250)
        bg.image = UIImage(named: "BackgroundGradientOffWhiteCurved")
        bg.contentMode = .ScaleAspectFill
        addSubviewWithFade(bg, parentView: self, duration: 0.5)
        self.view.sendSubviewToBack(bg)
        
        info.frame = CGRect(x: self.view.frame.width/2-13, y: self.view.frame.height-136, width: 26, height: 26)
        info.setBackgroundImage(UIImage(named: "ic_question"), forState: .Normal)
        info.contentMode = .ScaleAspectFit
        info.addTarget(self, action: #selector(RiskScoreViewController.showTutorial(_:)), forControlEvents: .TouchUpInside)
        info.addTarget(self, action: #selector(RiskScoreViewController.showTutorial(_:)), forControlEvents: .TouchUpOutside)
        self.view.addSubview(info)
        self.view.bringSubviewToFront(info)
        
    }
    
    func setData() {
        let score = KeychainSwift().get("riskScore")
        if score != nil, let floatScore = Float(score!) {
            lbl.text = String(Int(floatScore*100))
            g.rate = CGFloat(floatScore)*100
            l.rate = CGFloat(floatScore)*100
            
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
                l.endColor = UIColor.neonOrange()
                titleLabel.text = "Good Risk Score"
            } else if(g.rate > 39) {
                g.startColor = UIColor.neonOrange()
                l.startColor = UIColor.neonOrange()
                l.endColor = UIColor.yellowColor()
                titleLabel.text = "Average Risk Score"
            } else {
                g.startColor = UIColor.redColor()
                l.startColor = UIColor.redColor()
                l.endColor = UIColor.redColor()
                titleLabel.text = "Poor Risk Score"
            }
        } else {
            lbl.text = "91"
            g.startColor = UIColor.neonGreen()
            l.startColor = UIColor.neonGreen()
            l.endColor = UIColor.skyBlue()
            g.rate = 91
            l.rate = 100
        }

    }
    
    // MARK: Tutorial modal
    
    func showTutorial(sender: AnyObject) {
        tipView.show(forView: self.info, withinSuperview: self.view)
        
        Answers.logCustomEventWithName("Profile is verified tutorial presented",
                                       customAttributes: [:])
    }
    
}