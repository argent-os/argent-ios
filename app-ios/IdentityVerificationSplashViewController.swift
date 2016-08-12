//
//  IdentityVerificationSplashViewController.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 7/21/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import Alamofire
import CWStatusBarNotification
import SwiftyJSON
import KeychainSwift

class IdentityVerificationSplashViewController: UIViewController {
    
    //@IBOutlet weak var enableRiskProfileButton: UIButton!
    
    @IBOutlet weak var goToVerifyButton: UIButton!
    
    private var pageIcon = UIImageView()
    
    private var pageHeader = UILabel()
    
    private var pageDescription = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBar.tintColor = UIColor.darkBlue()
    }
    
    func configure() {
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        pageIcon.image = UIImage(named: "IconCustomIdentity")
        pageIcon.contentMode = .ScaleAspectFit
        pageIcon.frame = CGRect(x: screenWidth/2-60, y: 125, width: 120, height: 120)
        self.view.addSubview(pageIcon)
        
        let headerAttributedString = adjustAttributedString("Identity Verification", spacing: 0, fontName: "MyriadPro-Regular", fontSize: 24, fontColor: UIColor.lightBlue(), lineSpacing: 0.0, alignment: .Center)
        pageHeader.attributedText = headerAttributedString
        pageHeader.textAlignment = .Center
        pageHeader.frame = CGRect(x: 0, y: 260, width: screenWidth, height: 30)
        self.view.addSubview(pageHeader)
    
        let descriptionAttributedString = adjustAttributedString("In order to mitigate end-user risk, \nwe require one identity document\n and social security information. \nWe do not store this information\n on our servers.", spacing: 0, fontName: "MyriadPro-Regular", fontSize: 15, fontColor: UIColor.lightBlue(), lineSpacing: 0.0, alignment: .Center)
        pageDescription.attributedText = descriptionAttributedString
        pageDescription.numberOfLines = 0
        pageDescription.lineBreakMode = .ByWordWrapping
        pageDescription.textAlignment = .Center
        pageDescription.frame = CGRect(x: 0, y: 265, width: screenWidth, height: 160)
        self.view.addSubview(pageDescription)
        
        goToVerifyButton.layer.cornerRadius = 0
        goToVerifyButton.frame = CGRect(x: 0, y: screenHeight-100, width: screenWidth, height: 50)
        goToVerifyButton.layer.borderColor = UIColor.oceanBlue().colorWithAlphaComponent(0.5).CGColor
        goToVerifyButton.layer.borderWidth = 0
        goToVerifyButton.clipsToBounds = true
        goToVerifyButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        goToVerifyButton.setTitleColor(UIColor.offWhite(), forState: .Highlighted)
        goToVerifyButton.setBackgroundColor(UIColor.oceanBlue(), forState: .Normal)
        goToVerifyButton.setBackgroundColor(UIColor.oceanBlue().lighterColor(), forState: .Highlighted)
        var attribs: [String: AnyObject] = [:]
        attribs[NSFontAttributeName] = UIFont(name: "MyriadPro-Regular", size: 14)!
        attribs[NSForegroundColorAttributeName] = UIColor.whiteColor()
        let str = NSAttributedString(string: "Verify Identity", attributes: attribs)
        goToVerifyButton.setAttributedTitle(str, forState: .Normal)
        
        self.navigationItem.title = "Identity Verification"
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "MyriadPro-Regular", size: 17)!,
            NSForegroundColorAttributeName: UIColor.darkBlue()
        ]
        
        if(screenHeight < 500) {
            pageIcon.frame = CGRect(x: screenWidth/2-50, y: 100, width: 100, height: 100)
            pageHeader.frame = CGRect(x: 0, y: 185, width: screenWidth, height: 30)
            pageDescription.frame = CGRect(x: 0, y: 210, width: screenWidth, height: 50)
        }
    }
}