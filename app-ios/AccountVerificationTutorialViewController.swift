//
//  AccountVerificationTutorialViewController.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 7/3/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import MZFormSheetPresentationController

class AccountVerificationTutorialViewController: UIViewController {
    
    let titleLabel = UILabel()

    let titleLabelDetail = UILabel()

    let tutImage1 = UIImageView()
    
    let tutImage2 = UIImageView()
    
    let tutImage3 = UIImageView()

    let tutImage4 = UIImageView()

    let tutText1 = UILabel()
    
    let tutText2 = UILabel()
    
    let tutText3 = UILabel()
    
    let tutText4 = UILabel()
    
    let tutSubText1 = UILabel()

    let tutSubText2 = UILabel()

    let tutSubText3 = UILabel()

    let bottomColorView = UIView()

    let exitButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    func configureView() {
        // This will set to only one instance
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        // screen width and height:
        let screen = UIScreen.mainScreen().bounds
        _ = screen.size.width
        _ = screen.size.height
        
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.barTintColor = UIColor.lightGrayColor()
        
        titleLabel.frame = CGRect(x: 0, y: 30, width: 300, height: 20)
        titleLabel.text = "How to Verify Account"
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont.systemFontOfSize(17, weight: UIFontWeightRegular)
        titleLabel.textColor = UIColor.mediumBlue()
        self.view.addSubview(titleLabel)
        
        titleLabelDetail.frame = CGRect(x: 0, y: 50, width: 300, height: 20)
        titleLabelDetail.text = "To Accept Payments"
        titleLabelDetail.textAlignment = .Center
        titleLabelDetail.font = UIFont(name: "SFUIText-Regular", size: 12)!
        titleLabelDetail.textColor = UIColor.lightBlue()
        self.view.addSubview(titleLabelDetail)
        
        tutImage1.frame = CGRect(x: 30, y: 90, width: 50, height: 50)
        tutImage1.image = UIImage(named: "IconCustomSettings")
        tutImage1.contentMode = .ScaleAspectFit
        self.view.addSubview(tutImage1)
        tutText1.frame = CGRect(x: 90, y: 80, width: 210, height: 50)
        tutText1.text = "Complete your profile"
        tutText1.textAlignment = .Left
        tutText1.textColor = UIColor.mediumBlue()
        self.view.addSubview(tutText1)
        tutSubText1.frame = CGRect(x: 90, y: 100, width: 210, height: 50)
        tutSubText1.text = "In 'Profile'"
        tutSubText1.textAlignment = .Left
        tutSubText1.textColor = UIColor.lightBlue()
        tutSubText1.font = UIFont(name: "SFUIText-Regular", size: 12)!
        self.view.addSubview(tutSubText1)
        
        tutImage2.frame = CGRect(x: 30, y: 170, width: 50, height: 50)
        tutImage2.image = UIImage(named: "IconCustomBank")
        tutImage2.contentMode = .ScaleAspectFit
        self.view.addSubview(tutImage2)
        tutText2.frame = CGRect(x: 90, y: 160, width: 210, height: 50)
        tutText2.text = "Add a bank account"
        tutText2.textAlignment = .Left
        tutText2.textColor = UIColor.mediumBlue()
        self.view.addSubview(tutText2)
        tutSubText2.frame = CGRect(x: 90, y: 180, width: 210, height: 50)
        tutSubText2.text = "Direct login or manual entry"
        tutSubText2.textAlignment = .Left
        tutSubText2.textColor = UIColor.lightBlue()
        tutSubText2.font = UIFont(name: "SFUIText-Regular", size: 12)!
        self.view.addSubview(tutSubText2)
        
        tutImage3.frame = CGRect(x: 30, y: 250, width: 50, height: 50)
        tutImage3.image = UIImage(named: "IconCustomIdentity")
        tutImage3.contentMode = .ScaleAspectFit
        self.view.addSubview(tutImage3)
        tutText3.frame = CGRect(x: 90, y: 240, width: 210, height: 50)
        tutText3.text = "Verify your identity"
        tutText3.textAlignment = .Left
        tutText3.textColor = UIColor.mediumBlue()
        self.view.addSubview(tutText3)
        tutSubText3.frame = CGRect(x: 90, y: 260, width: 210, height: 50)
        tutSubText3.text = "One document, Full SSN Optional"
        tutSubText3.textAlignment = .Left
        tutSubText3.textColor = UIColor.lightBlue()
        tutSubText3.font = UIFont(name: "SFUIText-Regular", size: 12)!
        self.view.addSubview(tutSubText3)
        
        tutImage4.frame = CGRect(x: 0, y: 320, width: 300, height: 60)
        tutImage4.image = UIImage(named: "IconCheckFilled")
        tutImage4.contentMode = .ScaleAspectFit
        self.view.addSubview(tutImage4)
        self.view.bringSubviewToFront(tutImage4)
        tutText4.frame = CGRect(x: 30, y: 375, width: 250, height: 80)
        tutText4.numberOfLines = 0
        tutText4.font = UIFont(name: "SFUIText-Regular", size: 13)!
        tutText4.text = "Security is our top priority, all bank account and social security data are securely transmitted with 256-bit encryption and never stored on our servers."
        tutText4.textAlignment = .Center
        tutText4.textColor = UIColor.lightBlue()
        self.view.addSubview(tutText4)
        
        if UIScreen.mainScreen().bounds.size.width > 320 {
            bottomColorView.frame = CGRect(x: 0, y: UIScreen.mainScreen().bounds.height-320, width: 300, height: 320)
            bottomColorView.backgroundColor = UIColor.offWhite()
            self.view.addSubview(bottomColorView)
            self.view.sendSubviewToBack(bottomColorView)
        }
        
        exitButton.frame = CGRect(x: 0, y: UIScreen.mainScreen().bounds.height-190, width: 300, height: 60)
        exitButton.layer.borderColor = UIColor.whiteColor().CGColor
        exitButton.layer.borderWidth = 0
        exitButton.layer.cornerRadius = 0
        exitButton.layer.masksToBounds = true
        var attribs: [String: AnyObject] = [:]
        attribs[NSFontAttributeName] = UIFont(name: "SFUIText-Regular", size: 14)!
        attribs[NSForegroundColorAttributeName] = UIColor.whiteColor()
        let str = NSAttributedString(string: "Exit Tutorial", attributes: attribs)
        exitButton.setBackgroundColor(UIColor.brandGreen(), forState: .Normal)
        exitButton.setBackgroundColor(UIColor.brandGreen().darkerColor(), forState: .Highlighted)
        exitButton.setAttributedTitle(str, forState: .Normal)
        exitButton.addTarget(self, action: #selector(self.close(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(exitButton)
        
        if self.view.layer.frame.height < 667.0 {
            // iphone5 and below
            tutImage4.removeFromSuperview()
            bottomColorView.removeFromSuperview()
            
            tutImage1.frame = CGRect(x: 35, y: 70, width: 50, height: 50)
            tutText1.frame = CGRect(x: 90, y: 60, width: 210, height: 50)
            tutSubText1.frame = CGRect(x: 90, y: 80, width: 210, height: 50)
            
            tutImage2.frame = CGRect(x: 35, y: 130, width: 50, height: 50)
            tutText2.frame = CGRect(x: 90, y: 120, width: 210, height: 50)
            tutSubText2.frame = CGRect(x: 90, y: 140, width: 210, height: 50)
            
            tutImage3.frame = CGRect(x: 35, y: 190, width: 50, height: 50)
            tutText3.frame = CGRect(x: 90, y: 180, width: 210, height: 50)
            tutSubText3.frame = CGRect(x: 90, y: 200, width: 210, height: 50)
            
            tutText4.frame = CGRect(x: 20, y: 270, width: 260, height: 80)
        } else if self.view.layer.frame.height > 667.0 {
            // iphone6+
            tutImage4.frame = CGRect(x: 0, y: 390, width: 300, height: 60)
            tutText4.frame = CGRect(x: 20, y: 440, width: 260, height: 80)
        } else if self.view.layer.frame.height <= 480.0 {
            tutText4.removeFromSuperview()
            tutImage4.removeFromSuperview()
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    func close(sender: AnyObject) -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}