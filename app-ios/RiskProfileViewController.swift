//
//  RiskProfileViewController.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 5/4/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import Alamofire
import CWStatusBarNotification
import SwiftyJSON
import KeychainSwift

class RiskProfileViewController: UIViewController {
    
    private var enableRiskProfileButton = UIButton()
    
    private var viewRiskProfileButton = UIButton()
    
    private var viewAccountsButton = UIButton()
    
    private var pageIcon = UIImageView()
    
    private var pageHeader = UILabel()
    
    private var pageDescription = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        KeychainSwift().set("", forKey: "riskScore")
        let score = KeychainSwift().get("riskScore")

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

        let score = KeychainSwift().get("riskScore")
        print(score)
        if score == nil || score == "" {
            self.enableRiskProfileButton.setTitle("Enable Risk Profile", forState: .Normal)
            self.enableRiskProfileButton.addTarget(self, action: #selector(RiskProfileViewController.enableRiskProfiling(_:)), forControlEvents: .TouchUpInside)
        } else {
            self.enableRiskProfileButton.setTitle("Disable Risk Profile", forState: .Normal)
            self.enableRiskProfileButton.addTarget(self, action: #selector(RiskProfileViewController.disableRiskProfiling(_:)), forControlEvents: .TouchUpInside)
        }
    }
    
    func configure() {
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        enableRiskProfileButton.frame = CGRect(x: 0, y: screenHeight-170, width: screenWidth, height: 60)
        enableRiskProfileButton.layer.cornerRadius = 0
        enableRiskProfileButton.layer.borderColor = UIColor.oceanBlue().colorWithAlphaComponent(0.5).CGColor
        enableRiskProfileButton.layer.borderWidth = 0
        enableRiskProfileButton.clipsToBounds = true
        enableRiskProfileButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        enableRiskProfileButton.setTitleColor(UIColor.offWhite(), forState: .Highlighted)
        enableRiskProfileButton.setBackgroundColor(UIColor.oceanBlue(), forState: .Normal)
        enableRiskProfileButton.setBackgroundColor(UIColor.oceanBlue().lighterColor(), forState: .Highlighted)
        var attribs3: [String: AnyObject] = [:]
        attribs3[NSFontAttributeName] = UIFont(name: "SFUIText-Regular", size: 14)!
        attribs3[NSForegroundColorAttributeName] = UIColor.whiteColor()
        let str3 = NSAttributedString(string: "Enable Risk Profile", attributes: attribs3)
        enableRiskProfileButton.setAttributedTitle(str3, forState: .Normal)
        self.view.addSubview(enableRiskProfileButton)
        enableRiskProfileButton.addTarget(self, action: #selector(self.enableRiskProfiling(_:)), forControlEvents: .TouchUpInside)
        
        viewRiskProfileButton.frame = CGRect(x: 0, y: screenHeight-110, width: screenWidth, height: 60)
        viewRiskProfileButton.layer.cornerRadius = 0
        viewRiskProfileButton.layer.borderColor = UIColor.darkBlue().colorWithAlphaComponent(0.5).CGColor
        viewRiskProfileButton.layer.borderWidth = 0
        viewRiskProfileButton.clipsToBounds = true
        viewRiskProfileButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        viewRiskProfileButton.setTitleColor(UIColor.offWhite(), forState: .Highlighted)
        viewRiskProfileButton.setBackgroundColor(UIColor.seaBlue(), forState: .Normal)
        viewRiskProfileButton.setBackgroundColor(UIColor.seaBlue().lighterColor(), forState: .Highlighted)
        viewRiskProfileButton.addTarget(self, action: #selector(self.goToRiskProfile(_:)), forControlEvents: .TouchUpInside)
        var attribs2: [String: AnyObject] = [:]
        attribs2[NSFontAttributeName] = UIFont(name: "SFUIText-Regular", size: 14)!
        attribs2[NSForegroundColorAttributeName] = UIColor.whiteColor()
        let str2 = NSAttributedString(string: "View Risk Profile", attributes: attribs2)
        viewRiskProfileButton.setAttributedTitle(str2, forState: .Normal)
        self.view.addSubview(viewRiskProfileButton)
        
        pageIcon.image = UIImage(named: "IconCustomRisk")
        pageIcon.contentMode = .ScaleAspectFit
        pageIcon.frame = CGRect(x: screenWidth/2-60, y: 125, width: 120, height: 120)
        self.view.addSubview(pageIcon)
        
        let headerAttributedString = adjustAttributedString("Risk Profile", spacing: 0, fontName: "SFUIText-Regular", fontSize: 24, fontColor: UIColor.lightBlue(), lineSpacing: 0.0, alignment: .Center)
        pageHeader.attributedText = headerAttributedString
        pageHeader.textAlignment = .Center
        pageHeader.frame = CGRect(x: 0, y: 260, width: screenWidth, height: 30)
        self.view.addSubview(pageHeader)
        
        let descriptionAttributedString = adjustAttributedString("Welcome to risk-profiling. \n From here you will be able \nto see a comprehensive \nrisk-profile analysis on your\ncurrent financial standing.", spacing: 0, fontName: "SFUIText-Regular", fontSize: 15, fontColor: UIColor.lightBlue(), lineSpacing: 0.0, alignment: .Center)
        pageDescription.attributedText = descriptionAttributedString
        pageDescription.numberOfLines = 0
        pageDescription.lineBreakMode = .ByWordWrapping
        pageDescription.textAlignment = .Center
        pageDescription.frame = CGRect(x: 0, y: 280, width: screenWidth, height: 120)
        self.view.addSubview(pageDescription)
        
        self.navigationItem.title = "Risk Profile"
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "SFUIText-Regular", size: 17)!,
            NSForegroundColorAttributeName: UIColor.darkBlue()
        ]
        
        title = "Risk Profile"
        if(screenHeight < 500) {
            pageIcon.frame = CGRect(x: screenWidth/2-50, y: 100, width: 100, height: 100)
            pageHeader.frame = CGRect(x: 0, y: 185, width: screenWidth, height: 30)
            pageDescription.frame = CGRect(x: 0, y: 210, width: screenWidth, height: 50)
        }

    }
    
    func goToRiskProfile(sender: AnyObject) {
        self.performSegueWithIdentifier("riskProfileView", sender: self)
    }
    
    func enableRiskProfiling(sender: AnyObject) {
        // ** NOTE: this access_token is actually the public_token sent to the API
        // take this access token and connect bank account to stripe
        // save access token to user database
        // http://localhost:8080/v1/plaid/:uid/exchange_token
        if(userAccessToken != nil) {
            User.getProfile { (user, NSError) in
                
                let endpoint = API_URL + "/plaid/" + user!.id + "/upgrade"
                
                let headers = [
                    "Authorization": "Bearer " + (userAccessToken as! String),
                    "Content-Type": "application/json"
                ]
                
                let parameters = ["upgrade_to": "risk"]
                
                Alamofire.request(.POST, endpoint, parameters: parameters, encoding: .JSON, headers: headers).responseJSON {
                    response in
                    switch response.result {
                    case .Success:
                        if let value = response.result.value {
                            let data = JSON(value)
                            let calculatedRiskScore = data["score"]
                            showGlobalNotification("Risk profiling enabled", duration: 3.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.NavigationBarNotification, color: UIColor.brandGreen())
                            self.enableRiskProfileButton.setTitle("Disable Risk Profile", forState: .Normal)
                            self.enableRiskProfileButton.addTarget(self, action: #selector(RiskProfileViewController.disableRiskProfiling(_:)), forControlEvents: .TouchUpInside)
                            self.enableRiskProfileButton.removeTarget(self, action: #selector(RiskProfileViewController.enableRiskProfiling(_:)), forControlEvents: .TouchUpInside)
                            
                            KeychainSwift().set(calculatedRiskScore.stringValue, forKey: "riskScore")
                            
                            // set completion handler to post this risk score to our api user profile
                            
                        }
                    case .Failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
    
    func disableRiskProfiling(sender: AnyObject) {
        KeychainSwift().set("", forKey: "riskScore")
        showGlobalNotification("Risk profiling disabled", duration: 3.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.NavigationBarNotification, color: UIColor.neonOrange())
    }

}