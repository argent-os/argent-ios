//
//  AddBankViewController.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 3/19/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import plaid_ios_link
import Crashlytics

class AddBankViewController: UIViewController, PLDLinkNavigationControllerDelegate {
    
    private var manualConnectBankButton = UIButton()
    
    private var directLoginButton = UIButton()

    private var viewAccountsButton = UIButton()

    private var pageIcon = UIImageView()
    
    private var pageHeader = UILabel()
    
    private var pageDescription = UILabel()
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidAppear(animated: Bool) {
//        addBankButton.addTarget(self, action: #selector(AddBankViewController.displayBanks(_:)), forControlEvents: .TouchUpInside)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configure() {
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        viewAccountsButton.frame = CGRect(x: 0, y: screenHeight-230, width: screenWidth, height: 60)
        viewAccountsButton.layer.cornerRadius = 0
        viewAccountsButton.layer.borderColor = UIColor.skyBlue().colorWithAlphaComponent(0.5).CGColor
        viewAccountsButton.layer.borderWidth = 0
        viewAccountsButton.clipsToBounds = true
        viewAccountsButton.setTitleColor(UIColor.darkBlue(), forState: .Normal)
        viewAccountsButton.setTitleColor(UIColor.mediumBlue(), forState: .Highlighted)
        viewAccountsButton.setBackgroundColor(UIColor.clearColor(), forState: .Normal)
        viewAccountsButton.setBackgroundColor(UIColor.whiteColor().darkerColor(), forState: .Highlighted)
        var attribs: [String: AnyObject] = [:]
        attribs[NSFontAttributeName] = UIFont.systemFontOfSize(14)
        attribs[NSForegroundColorAttributeName] = UIColor.lightBlue()
        let str = NSAttributedString(string: "View Accounts", attributes: attribs)
        viewAccountsButton.setAttributedTitle(str, forState: .Normal)
        self.view.addSubview(viewAccountsButton)
        viewAccountsButton.addTarget(self, action: #selector(self.goToConnectedBanks(_:)), forControlEvents: .TouchUpInside)

        manualConnectBankButton.frame = CGRect(x: 0, y: screenHeight-170, width: screenWidth, height: 60)
        manualConnectBankButton.layer.cornerRadius = 0
        manualConnectBankButton.layer.borderColor = UIColor.skyBlue().colorWithAlphaComponent(0.5).CGColor
        manualConnectBankButton.layer.borderWidth = 0
        manualConnectBankButton.clipsToBounds = true
        manualConnectBankButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        manualConnectBankButton.setTitleColor(UIColor.offWhite(), forState: .Highlighted)
        manualConnectBankButton.setBackgroundColor(UIColor.skyBlue(), forState: .Normal)
        manualConnectBankButton.setBackgroundColor(UIColor.skyBlue().darkerColor(), forState: .Highlighted)
        var attribs3: [String: AnyObject] = [:]
        attribs3[NSFontAttributeName] = UIFont.systemFontOfSize(14)
        attribs3[NSForegroundColorAttributeName] = UIColor.whiteColor()
        let str3 = NSAttributedString(string: "Manually Connect", attributes: attribs3)
        manualConnectBankButton.setAttributedTitle(str3, forState: .Normal)
        self.view.addSubview(manualConnectBankButton)
        manualConnectBankButton.addTarget(self, action: #selector(self.goToManualBank(_:)), forControlEvents: .TouchUpInside)

        directLoginButton.frame = CGRect(x: 0, y: screenHeight-110, width: screenWidth, height: 60)
        directLoginButton.layer.cornerRadius = 0
        directLoginButton.layer.borderColor = UIColor.darkBlue().colorWithAlphaComponent(0.5).CGColor
        directLoginButton.layer.borderWidth = 0
        directLoginButton.clipsToBounds = true
        directLoginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        directLoginButton.setTitleColor(UIColor.offWhite(), forState: .Highlighted)
        directLoginButton.setBackgroundColor(UIColor.mediumBlue(), forState: .Normal)
        directLoginButton.setBackgroundColor(UIColor.mediumBlue().darkerColor(), forState: .Highlighted)
        directLoginButton.addTarget(self, action: #selector(self.goToLoginBank(_:)), forControlEvents: .TouchUpInside)
        var attribs2: [String: AnyObject] = [:]
        attribs2[NSFontAttributeName] = UIFont.systemFontOfSize(14)
        attribs2[NSForegroundColorAttributeName] = UIColor.whiteColor()
        let str2 = NSAttributedString(string: "Login to Bank", attributes: attribs2)
        directLoginButton.setAttributedTitle(str2, forState: .Normal)
        self.view.addSubview(directLoginButton)

        pageIcon.image = UIImage(named: "IconBankBlue")
        pageIcon.contentMode = .ScaleAspectFit
        pageIcon.frame = CGRect(x: screenWidth/2-50, y: 150, width: 100, height: 100)
        self.view.addSubview(pageIcon)
        
        pageHeader.text = "Bank Linking"
        pageHeader.textColor = UIColor.lightBlue()
        pageHeader.font = UIFont(name: "MyriadPro-Regular", size: 24)
        pageHeader.textAlignment = .Center
        pageHeader.frame = CGRect(x: 0, y: 250, width: screenWidth, height: 30)
        self.view.addSubview(pageHeader)
        
        pageDescription.text = "Link to any US bank account \nusing one of the methods below"
        pageDescription.numberOfLines = 0
        pageDescription.lineBreakMode = .ByWordWrapping
        pageDescription.textColor = UIColor.lightBlue()
        pageDescription.font = UIFont(name: "MyriadPro-Regular", size: 15)
        pageDescription.textAlignment = .Center
        pageDescription.frame = CGRect(x: 0, y: 285, width: screenWidth, height: 50)
        self.view.addSubview(pageDescription)
        
//        self.navigationItem.title = "Bank Account"
//        self.navigationController?.navigationBar.tintColor = UIColor.lightBlue()
//        self.navigationController?.navigationBar.titleTextAttributes = [
//            NSFontAttributeName: UIFont.systemFontOfSize(14),
//            NSForegroundColorAttributeName: UIColor.lightBlue()
//        ]
        title = "Bank Account"
        if(screenHeight < 500) {
            pageIcon.frame = CGRect(x: screenWidth/2-50, y: 100, width: 100, height: 100)
            pageHeader.frame = CGRect(x: 0, y: 185, width: screenWidth, height: 30)
            pageDescription.frame = CGRect(x: 0, y: 210, width: screenWidth, height: 50)
        }
    }
    
    func goToConnectedBanks(sender: AnyObject) {
        self.performSegueWithIdentifier("bankConnectedView", sender: self)
    }
    
    func goToManualBank(sender: AnyObject) {
        self.performSegueWithIdentifier("bankManualView", sender: self)
    }
    
    func goToLoginBank(sender: AnyObject) {
        // self.performSegueWithIdentifier("bankLoginView", sender: self)
        displayBanks(sender)
    }
    
    func displayBanks(sender: AnyObject) {
        // Option .Connect | .Auth
        var plaidLink:PLDLinkNavigationViewController?
        if ENVIRONMENT == "DEV" {
            plaidLink = PLDLinkNavigationViewController(environment: .Tartan, product: .Auth)
        } else if ENVIRONMENT == "PROD" {
            plaidLink = PLDLinkNavigationViewController(environment: .Production, product: .Auth)
        }

        plaidLink!.linkDelegate = self
        plaidLink!.providesPresentationContextTransitionStyle = true
        plaidLink!.definesPresentationContext = true
        plaidLink!.modalPresentationStyle = .Custom
        
        self.presentViewController(plaidLink!, animated: true, completion: nil)
    }
    
    func linkNavigationContoller(navigationController: PLDLinkNavigationViewController!, didFinishWithAccessToken accessToken: String!) {
        print("success \(accessToken)")
        print("the public token is", accessToken)
        let publicToken = accessToken
        linkPlaidBankAccount(publicToken, completionHandler: { (stripeBankToken, accessToken) in
            //print("stripe bank token is", stripeBankToken)
            self.linkBankToStripe(stripeBankToken)
            self.updateUserPlaidToken(accessToken)
            //print("updating user plaid token ", accessToken)
        }, accessToken: accessToken)
    }
    
    func linkPlaidBankAccount(publicToken: String, completionHandler: (String, String) -> Void, accessToken: String) {
        // ** NOTE: this access_token is actually the public_token sent to the API
        // take this access token and connect bank account to stripe
        // save access token to user database
        // http://localhost:8080/v1/plaid/:uid/exchange_token
        if(userAccessToken != nil) {
            User.getProfile { (user, NSError) in
                
                let endpoint = API_URL + "/plaid/" + user!.id + "/exchange_token/" + publicToken //+ accountId
                
                let headers = [
                    "Authorization": "Bearer " + (userAccessToken as! String),
                    "Content-Type": "application/json"
                ]
                
                let parameters = ["public_token": accessToken]
                
                print(parameters)
                
                Alamofire.request(.POST, endpoint, parameters: parameters, encoding: .JSON, headers: headers).responseJSON {
                    response in
                    switch response.result {
                    case .Success:
                        if let value = response.result.value {
                            let data = JSON(value)
                            self.dismissViewControllerAnimated(true) {
                                print(data)
                                let access_token = data["response"]["access_token"]
                                let stripe_bank_token = data["response"]["stripe_bank_account_token"]
                                completionHandler(stripe_bank_token.stringValue, access_token.stringValue)
                            }
                        }
                    case .Failure(let error):
                        print(error)
                        showAlert(.Error, title: "Error", msg: "Failed to link bank account.")
                        Answers.logCustomEventWithName("Bank account link failed",
                            customAttributes: [
                                "error": error.localizedDescription
                            ])
                    }
                }
            }
        }
    }
    
    func updateUserPlaidToken(accessToken: String) {
        if(userAccessToken != nil) {
            User.getProfile { (user, NSError) in
                
                let endpoint = API_URL + "/profile/" + (user?.id)!
                
                let headers = [
                    "Authorization": "Bearer " + (userAccessToken as! String),
                    "Content-Type": "application/json"
                ]
                
                let plaidObj = [ "access_token" : accessToken ]
                let plaidNSDict = plaidObj as NSDictionary //no error message
                
                let parameters : [String : AnyObject] = [
                    "plaid" : plaidNSDict
                ]
                
                print("updating plaid user token")
                print(parameters)
                
                Alamofire.request(.PUT, endpoint, parameters: parameters, encoding: .JSON, headers: headers).responseJSON {
                    response in
                    switch response.result {
                    case .Success:
                        print("success")
                        if let value = response.result.value {
                            let data = JSON(value)
                            Answers.logCustomEventWithName("Plaid token update success",
                                customAttributes: [:])
                        }
                    case .Failure(let error):
                        print(error)
                        Answers.logCustomEventWithName("Plaid token update failed",
                            customAttributes: [
                                "error": error.localizedDescription
                            ])
                    }
                }
            }
        }
    }
    
    func linkBankToStripe(bankToken: String) {
        if(userAccessToken != nil) {
            User.getProfile { (user, NSError) in
                
                let endpoint = API_URL + "/stripe/" + user!.id + "/external_account"
                
                let headers = [
                    "Authorization": "Bearer " + (userAccessToken as! String),
                    "Content-Type": "application/json"
                ]
                
                let parameters = ["external_account": bankToken]
                
                print(parameters)
                
                Alamofire.request(.POST, endpoint, parameters: parameters, encoding: .JSON, headers: headers).responseJSON {
                    response in
                    switch response.result {
                    case .Success:
                        if let value = response.result.value {
                            let data = JSON(value)
                            Answers.logCustomEventWithName("Link bank to Stripe success",
                                customAttributes: [:])
                            if response.response?.statusCode == 200 {
                                showAlert(.Success, title: "Success", msg: "Your bank account is now linked!")

                                Answers.logCustomEventWithName("Bank account link success",
                                    customAttributes: [:])
                            } else {
                                showAlert(.Error, title: "Error", msg: "Error linking bank account")
                                
                                Answers.logCustomEventWithName("Bank account link failure",
                                    customAttributes: [:])
                            }
                        }
                    case .Failure(let error):
                        print(error)
                        Answers.logCustomEventWithName("Link bank to Stripe failed",
                            customAttributes: [
                                "error": error.localizedDescription
                            ])
                    }
                }
            }
        }
    }
    
    func linkNavigationControllerDidFinishWithBankNotListed(navigationController: PLDLinkNavigationViewController!) {
        print("Manually enter bank info?")
    }
    func linkNavigationControllerDidCancel(navigationController: PLDLinkNavigationViewController!) {
        dismissViewControllerAnimated(true) {
        }
    }
}