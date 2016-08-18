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
    
    //@IBOutlet weak var enableRiskProfileButton: UIButton!
    
    @IBOutlet weak var previewButton: UIButton!
    
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

//        let score = KeychainSwift().get("riskScore")
//        print(score)
//        if score == nil || score == "" {
//            self.enableRiskProfileButton.setTitle("Enable Risk Profile", forState: .Normal)
//            self.enableRiskProfileButton.addTarget(self, action: #selector(RiskProfileViewController.enableRiskProfiling(_:)), forControlEvents: .TouchUpInside)
//        } else {
//            self.enableRiskProfileButton.setTitle("Disable Risk Profile", forState: .Normal)
//            self.enableRiskProfileButton.addTarget(self, action: #selector(RiskProfileViewController.disableRiskProfiling(_:)), forControlEvents: .TouchUpInside)
//        }
    }
    
    func configure() {
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
    
        pageIcon.image = UIImage(named: "IconRisk")
        pageIcon.contentMode = .ScaleAspectFit
        pageIcon.frame = CGRect(x: screenWidth/2-50, y: 200, width: 100, height: 100)
        self.view.addSubview(pageIcon)
        
        pageHeader.text = "Risk Profile"
        pageHeader.textColor = UIColor.lightBlue()
        pageHeader.font = UIFont(name: "SFUIText-Regular", size: 24)
        pageHeader.textAlignment = .Center
        pageHeader.frame = CGRect(x: 0, y: 300, width: screenWidth, height: 30)
        self.view.addSubview(pageHeader)
        
        pageDescription.text = "This feature is currently under development \n we will send out notifications once it's live!"
        pageDescription.numberOfLines = 0
        pageDescription.lineBreakMode = .ByWordWrapping
        pageDescription.textColor = UIColor.lightBlue()
        pageDescription.font = UIFont(name: "SFUIText-Regular", size: 15)
        pageDescription.textAlignment = .Center
        pageDescription.frame = CGRect(x: 0, y: 335, width: screenWidth, height: 50)
        self.view.addSubview(pageDescription)
        
        previewButton.layer.cornerRadius = 0
        previewButton.frame = CGRect(x: 0, y: screenHeight-100, width: screenWidth, height: 50)
        previewButton.layer.borderColor = UIColor.skyBlue().colorWithAlphaComponent(0.5).CGColor
        previewButton.layer.borderWidth = 0
        previewButton.clipsToBounds = true
        previewButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        previewButton.setTitleColor(UIColor.offWhite(), forState: .Highlighted)
        previewButton.setBackgroundColor(UIColor.skyBlue(), forState: .Normal)
        previewButton.setBackgroundColor(UIColor.skyBlue().lighterColor(), forState: .Highlighted)
        var attribs: [String: AnyObject] = [:]
        attribs[NSFontAttributeName] = UIFont(name: "SFUIText-Regular", size: 14)!
        attribs[NSForegroundColorAttributeName] = UIColor.whiteColor()
        let str = NSAttributedString(string: "See Preview", attributes: attribs)
        previewButton.setAttributedTitle(str, forState: .Normal)
        
        if(screenHeight < 500) {
            pageIcon.frame = CGRect(x: screenWidth/2-50, y: 100, width: 100, height: 100)
            pageHeader.frame = CGRect(x: 0, y: 185, width: screenWidth, height: 30)
            pageDescription.frame = CGRect(x: 0, y: 210, width: screenWidth, height: 50)
        }
        
        self.navigationItem.title = "Risk Profile"
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "SFUIText-Regular", size: 17)!,
            NSForegroundColorAttributeName: UIColor.darkBlue()
        ]
    }
    
    func enableRiskProfiling(sender: AnyObject) {
        // ** NOTE: this access_token is actually the public_token sent to the API
        // take this access token and connect bank account to stripe
        // save access token to user database
        // http://localhost:8080/v1/plaid/:uid/exchange_token
        if(userAccessToken != nil) {
            User.getProfile { (user, NSError) in
                
//                let endpoint = API_URL + "/plaid/" + user!.id + "/upgrade"
//                
//                let headers = [
//                    "Authorization": "Bearer " + (userAccessToken as! String),
//                    "Content-Type": "application/json"
//                ]
//                
//                let parameters = ["upgrade_to": "risk"]
//                
//                Alamofire.request(.POST, endpoint, parameters: parameters, encoding: .JSON, headers: headers).responseJSON {
//                    response in
//                    switch response.result {
//                    case .Success:
//                        if let value = response.result.value {
//                            let data = JSON(value)
//                            let calculatedRiskScore = data["score"]
//                            showGlobalNotification("Risk profiling enabled", duration: 3.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.NavigationBarNotification, color: UIColor.brandGreen())
//                            self.enableRiskProfileButton.setTitle("Disable Risk Profile", forState: .Normal)
//                            self.enableRiskProfileButton.addTarget(self, action: #selector(RiskProfileViewController.disableRiskProfiling(_:)), forControlEvents: .TouchUpInside)
//                            self.enableRiskProfileButton.removeTarget(self, action: #selector(RiskProfileViewController.enableRiskProfiling(_:)), forControlEvents: .TouchUpInside)
//                            
//                            KeychainSwift().set(calculatedRiskScore.stringValue, forKey: "riskScore")
//                            
//                            // set completion handler to post this risk score to our api user profile
//                            
//                        }
//                    case .Failure(let error):
//                        print(error)
//                    }
//                }
            }
        }
    }
    
//    func disableRiskProfiling(sender: AnyObject) {
//        KeychainSwift().set("", forKey: "riskScore")
//        showGlobalNotification("Risk profiling disabled", duration: 3.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.NavigationBarNotification, color: UIColor.neonOrange())
//    }

}