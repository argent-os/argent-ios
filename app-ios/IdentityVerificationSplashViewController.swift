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
        
        pageIcon.image = UIImage(named: "IconCheckFilled")
        pageIcon.contentMode = .ScaleAspectFit
        pageIcon.frame = CGRect(x: screenWidth/2-50, y: 200, width: 100, height: 100)
        self.view.addSubview(pageIcon)
        
        pageHeader.text = "Identity Verification"
        pageHeader.textColor = UIColor.lightBlue()
        pageHeader.font = UIFont(name: "MyriadPro-Regular", size: 24)
        pageHeader.textAlignment = .Center
        pageHeader.frame = CGRect(x: 0, y: 300, width: screenWidth, height: 30)
        self.view.addSubview(pageHeader)
        
        pageDescription.text = "In order to mitigate end-user risk \n we require identity verification information \n with one identity document and SSN"
        pageDescription.numberOfLines = 0
        pageDescription.lineBreakMode = .ByWordWrapping
        pageDescription.textColor = UIColor.lightBlue()
        pageDescription.font = UIFont(name: "MyriadPro-Regular", size: 15)
        pageDescription.textAlignment = .Center
        pageDescription.frame = CGRect(x: 0, y: 335, width: screenWidth, height: 70)
        self.view.addSubview(pageDescription)
        
        goToVerifyButton.layer.cornerRadius = 0
        goToVerifyButton.frame = CGRect(x: 0, y: screenHeight-100, width: screenWidth, height: 50)
        goToVerifyButton.layer.borderColor = UIColor.skyBlue().colorWithAlphaComponent(0.5).CGColor
        goToVerifyButton.layer.borderWidth = 0
        goToVerifyButton.clipsToBounds = true
        goToVerifyButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        goToVerifyButton.setTitleColor(UIColor.offWhite(), forState: .Highlighted)
        goToVerifyButton.setBackgroundColor(UIColor.skyBlue(), forState: .Normal)
        goToVerifyButton.setBackgroundColor(UIColor.skyBlue().lighterColor(), forState: .Highlighted)
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