//
//  AddBankViewController.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 3/19/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import JSSAlertView
import Alamofire
import SwiftyJSON
import plaid_ios_link
import Crashlytics

class AddBankViewController: UIViewController, PLDLinkNavigationControllerDelegate {
    
//    @IBOutlet weak var addBankButton: UIButton!
    @IBOutlet weak var manualConnectBankButton: UIButton!
    
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
        
        manualConnectBankButton.layer.cornerRadius = 10
        manualConnectBankButton.layer.borderColor = UIColor.lightBlue().colorWithAlphaComponent(0.5).CGColor
        manualConnectBankButton.layer.borderWidth = 1
        manualConnectBankButton.clipsToBounds = true
        manualConnectBankButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        manualConnectBankButton.setTitleColor(UIColor.offWhite(), forState: .Highlighted)
        manualConnectBankButton.setBackgroundColor(UIColor.lightBlue(), forState: .Normal)
        manualConnectBankButton.setBackgroundColor(UIColor.mediumBlue(), forState: .Highlighted)
        manualConnectBankButton.setTitle("Manually Connect", forState: .Normal)

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
                                self.showAlert("Success", msg: "Bank Connected", color: UIColor.brandGreen(), image: UIImage(named: "ic_check_light")!)
                                Answers.logCustomEventWithName("Bank account link success",
                                    customAttributes: [:])
                            } else {
                                self.showAlert("Error", msg: "Could not link bank account, please contact support for help", color: UIColor.brandRed(), image: UIImage(named: "ic_close_light")!)
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
    
    private func showAlert(title: String, msg: String, color: UIColor, image: UIImage) {
        let customIcon:UIImage = image // your custom icon UIImage
        let customColor:UIColor = color // base color for the alert
        self.view.endEditing(true)
        let alertView = JSSAlertView().show(
            self,
            title: title,
            text: msg,
            buttonText: "Ok",
            noButtons: false,
            color: customColor,
            iconImage: customIcon)
        alertView.setTextTheme(.Light) // can be .Light or .Dark
    }
}