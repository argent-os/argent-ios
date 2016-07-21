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
    
//    @IBOutlet weak var addBankButton: UIButton!
    @IBOutlet weak var manualConnectBankButton: UIButton!
    
    private var pageIcon = UIImageView()
    
    private var pageHeader = UILabel()
    
    private var pageDescription = UILabel()
    
    override func prefersStatusBarHidden() -> Bool {
        return true
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
        
        manualConnectBankButton.layer.cornerRadius = 0
        manualConnectBankButton.frame = CGRect(x: 0, y: screenHeight-100, width: screenWidth, height: 50)
        manualConnectBankButton.layer.borderColor = UIColor.skyBlue().colorWithAlphaComponent(0.5).CGColor
        manualConnectBankButton.layer.borderWidth = 0
        manualConnectBankButton.clipsToBounds = true
        manualConnectBankButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        manualConnectBankButton.setTitleColor(UIColor.offWhite(), forState: .Highlighted)
        manualConnectBankButton.setBackgroundColor(UIColor.skyBlue(), forState: .Normal)
        manualConnectBankButton.setBackgroundColor(UIColor.skyBlue().darkerColor(), forState: .Highlighted)
        var attribs: [String: AnyObject] = [:]
        attribs[NSFontAttributeName] = UIFont.systemFontOfSize(14)
        attribs[NSForegroundColorAttributeName] = UIColor.whiteColor()
        let str = NSAttributedString(string: "Manually Connect", attributes: attribs)
        manualConnectBankButton.setAttributedTitle(str, forState: .Normal)

        pageIcon.image = UIImage(named: "IconBankBlue")
        pageIcon.contentMode = .ScaleAspectFit
        pageIcon.frame = CGRect(x: screenWidth/2-50, y: 200, width: 100, height: 100)
        self.view.addSubview(pageIcon)
        
        pageHeader.text = "Bank Linking"
        pageHeader.textColor = UIColor.lightBlue()
        pageHeader.font = UIFont.systemFontOfSize(24, weight: UIFontWeightMedium)
        pageHeader.textAlignment = .Center
        pageHeader.frame = CGRect(x: 0, y: 300, width: screenWidth, height: 30)
        self.view.addSubview(pageHeader)
        
        pageDescription.text = "Link to any US bank account \nusing direct login or manual entry"
        pageDescription.numberOfLines = 0
        pageDescription.lineBreakMode = .ByWordWrapping
        pageDescription.textColor = UIColor.lightBlue()
        pageDescription.font = UIFont.systemFontOfSize(15, weight: UIFontWeightLight)
        pageDescription.textAlignment = .Center
        pageDescription.frame = CGRect(x: 0, y: 335, width: screenWidth, height: 50)
        self.view.addSubview(pageDescription)
        
//        addBankButton.layer.cornerRadius = 10
//        addBankButton.clipsToBounds = true
//        addBankButton.backgroundColor = UIColor.lightBlue()
//        addBankButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
//        addBankButton.setTitleColor(UIColor.offWhite(), forState: .Highlighted)
//        addBankButton.setBackgroundColor(UIColor.lightBlue(), forState: .Normal)
//        addBankButton.setBackgroundColor(UIColor.mediumBlue(), forState: .Highlighted)
//        addBankButton.setTitle("Login to Bank", forState: .Normal)
        
        self.navigationItem.title = "Bank Account"
        self.navigationController?.navigationBar.tintColor = UIColor.lightBlue()
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont.systemFontOfSize(14),
            NSForegroundColorAttributeName: UIColor.lightBlue()
        ]
        title = "Bank Account"
        
    }
    
    func displayBanks(sender: AnyObject) {
        // Option .Connect | .Auth
        var plaidLink:PLDLinkNavigationViewController?
        if ENVIRONMENT == "DEV" {
            plaidLink = PLDLinkNavigationViewController(environment: .Tartan, product: .Connect)
        } else if ENVIRONMENT == "PROD" {
            plaidLink = PLDLinkNavigationViewController(environment: .Production, product: .Connect)
        }

        plaidLink!.linkDelegate = self
        plaidLink!.providesPresentationContextTransitionStyle = true
        plaidLink!.definesPresentationContext = true
        plaidLink!.modalPresentationStyle = .Custom
        
        self.presentViewController(plaidLink!, animated: true, completion: nil)
    }
    
    func linkNavigationContoller(navigationController: PLDLinkNavigationViewController!, didFinishWithAccessToken accessToken: String!) {
        print("success \(accessToken)")
        print("the access token is", accessToken)
//        linkPlaidBankAccount({ (stripeBankToken, accessToken) in
//            print("stripe bank token is", stripeBankToken)
//            self.linkBankToStripe(stripeBankToken)
//            self.updateUserPlaidToken(accessToken)
//            print("updating user plaid token ", accessToken)
//        }, accessToken: accessToken)
    }
    
    func linkPlaidBankAccount(completionHandler: (String, String) -> Void, accessToken: String) {
        // ** NOTE: this access_token is actually the public_token sent to the API
        // take this access token and connect bank account to stripe
        // save access token to user database
        // http://localhost:8080/v1/plaid/:uid/exchange_token
        if(userAccessToken != nil) {
            User.getProfile { (user, NSError) in
                
                let endpoint = API_URL + "/plaid/" + user!.id + "/exchange_token/" // + accountId
                
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
                                showAlert(.Success, title: "Success", msg: "Your bank account is now linked")

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