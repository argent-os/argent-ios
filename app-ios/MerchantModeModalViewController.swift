//
//  MerchantModeModalViewController.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 8/9/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import MZFormSheetPresentationController
import CWStatusBarNotification
import Crashlytics
import KeychainSwift

class MerchantModeModalViewController: UIViewController, UITextFieldDelegate {
    
    let titleLabel = UILabel()
    
    let modeSelectionButton = UIButton()
    
    let merchantSwitch = UISwitch()

    let consumerSwitch = UISwitch()

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    // Found in Extensions.swift
    func merchantSwitchChanged(merchantSwitch: UISwitch) {
        print(merchantSwitch.on.boolValue)
        if merchantSwitch.on.boolValue {
            consumerSwitch.setOn(false, animated: true)
        } else {
            consumerSwitch.setOn(true, animated: true)
        }
    }
    
    func consumerSwitchChanged(consumerSwitch: UISwitch) {
        print(consumerSwitch.on.boolValue)
        if consumerSwitch.on.boolValue {
            merchantSwitch.setOn(false, animated: true)
        } else {
            merchantSwitch.setOn(true, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This will set to only one instance
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        // screen width and height:
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        _ = screen.size.height
        
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.barTintColor = UIColor.lightGrayColor()
        
        let imageMerchantBadge = UIImageView()
        imageMerchantBadge.image = UIImage(named: "IconCustomSettings")
        imageMerchantBadge.frame = CGRect(x: 140-35, y: 0, width: 70, height: 70)
        imageMerchantBadge.contentMode = .ScaleAspectFit
        imageMerchantBadge.frame.origin.y = 25
        self.view.addSubview(imageMerchantBadge)
        
        titleLabel.frame = CGRect(x: 0, y: 110, width: 280, height: 20)
        titleLabel.attributedText = adjustAttributedString("CONFIGURATION", spacing: 2, fontName: "MyriadPro-Regular", fontSize: 13, fontColor: UIColor.lightBlue(), lineSpacing: 0.0, alignment: .Center)
        titleLabel.textAlignment = .Center
        titleLabel.textColor = UIColor.darkBlue()
        self.view.addSubview(titleLabel)
        
        
        let merchantLabel = UILabel()
        merchantLabel.attributedText = adjustAttributedString("DEFAULT ENABLED", spacing: 2, fontName: "MyriadPro-Regular", fontSize: 13, fontColor: UIColor.lightBlue(), lineSpacing: 0.0, alignment: .Left)
        merchantLabel.frame = CGRect(x: 20, y: 167, width: 280, height: 20)
        merchantSwitch.on = true
        merchantSwitch.onTintColor = UIColor.brandGreen().colorWithAlphaComponent(0.5)
        merchantSwitch.userInteractionEnabled = false
        merchantSwitch.frame = CGRect(x: 210, y: 160, width: 280, height: 20)
        merchantSwitch.addTarget(self, action: #selector(self.merchantSwitchChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.view.addSubview(merchantLabel)
        self.view.addSubview(merchantSwitch)
        
        let consumerLabel = UILabel()
        consumerLabel.attributedText = adjustAttributedString("MINIMAL MODE", spacing: 2, fontName: "MyriadPro-Regular", fontSize: 13, fontColor: UIColor.lightBlue(), lineSpacing: 0.0, alignment: .Left)
        consumerLabel.frame = CGRect(x: 20, y: 175, width: 280, height: 20)
        consumerSwitch.on = false
        consumerSwitch.addTarget(self, action: #selector(self.consumerSwitchChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        consumerSwitch.frame = CGRect(x: 210, y: 170, width: 280, height: 20)
//        self.view.addSubview(consumerLabel)
//        self.view.addSubview(consumerSwitch)
        
        modeSelectionButton.frame = CGRect(x: 0, y: 220, width: 280, height: 60)
        modeSelectionButton.layer.borderColor = UIColor.whiteColor().CGColor
        modeSelectionButton.layer.borderWidth = 0
        modeSelectionButton.layer.cornerRadius = 0
        modeSelectionButton.layer.masksToBounds = true
        modeSelectionButton.setBackgroundColor(UIColor.pastelBlue(), forState: .Normal)
        modeSelectionButton.setBackgroundColor(UIColor.pastelBlue().darkerColor(), forState: .Highlighted)
        var attribs: [String: AnyObject] = [:]
        attribs[NSFontAttributeName] = UIFont(name: "MyriadPro-Regular", size: 15)
        attribs[NSForegroundColorAttributeName] = UIColor.whiteColor()
        let str = adjustAttributedString("RETURN HOME", spacing: 2, fontName: "MyriadPro-Regular", fontSize: 13, fontColor: UIColor.whiteColor(), lineSpacing: 0.0, alignment: .Center)
        modeSelectionButton.setAttributedTitle(str, forState: .Normal)
        let rectShape = CAShapeLayer()
        rectShape.bounds = modeSelectionButton.frame
        rectShape.position = modeSelectionButton.center
        rectShape.path = UIBezierPath(roundedRect: modeSelectionButton.bounds, byRoundingCorners: [.BottomLeft, .BottomRight], cornerRadii: CGSize(width: 5, height: 5)).CGPath
        
        modeSelectionButton.addTarget(self, action: #selector(self.close), forControlEvents: .TouchUpInside)
        modeSelectionButton.layer.backgroundColor = UIColor.mediumBlue().CGColor
        //Here I'm masking the textView's layer with rectShape layer
        modeSelectionButton.layer.mask = rectShape
        self.view.addSubview(modeSelectionButton)

    }

    override func viewDidDisappear(animated: Bool) {
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    func close() -> Void {
        if consumerSwitch.on == true {
            self.dismissViewControllerAnimated(true, completion: { })
        } else {
            self.dismissViewControllerAnimated(true, completion: { })
        }
    }
}