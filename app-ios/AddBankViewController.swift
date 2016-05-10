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

class AddBankViewController: UIViewController, PLDLinkNavigationControllerDelegate {
    
    @IBOutlet weak var addBankButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBankButton.layer.cornerRadius = 5
        addBankButton.clipsToBounds = true
        addBankButton.backgroundColor = UIColor.mediumBlue()
    }
    
    override func viewDidAppear(animated: Bool) {
        addBankButton.addTarget(self, action: #selector(AddBankViewController.displayBanks(_:)), forControlEvents: .TouchUpInside)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayBanks(sender: AnyObject) {
        let plaidLink = PLDLinkNavigationViewController(environment: .Tartan, product: .Connect)
        plaidLink.linkDelegate = self
        plaidLink.providesPresentationContextTransitionStyle = true
        plaidLink.definesPresentationContext = true
        plaidLink.modalPresentationStyle = .Custom
        
        self.presentViewController(plaidLink, animated: true, completion: nil)
    }
    
    func linkNavigationContoller(navigationController: PLDLinkNavigationViewController!, didFinishWithAccessToken accessToken: String!) {
        print("success \(accessToken)")
        linkPlaidBankAccount({ (token) in
                self.linkBankToStripe(token)
            }, accessToken: accessToken)
    }
    
    func linkPlaidBankAccount(completionHandler: (String) -> Void, accessToken: String) {
        // ** NOTE: this access_token is actually the public_token sent to the API
        // take this access token and connect bank account to stripe
        // save access token to user database
        // http://localhost:8080/v1/plaid/:uid/exchange_token
        if(userAccessToken != nil) {
            User.getProfile { (user, NSError) in
                
                let endpoint = apiUrl + "/v1/plaid/" + user!.id + "/exchange_token"
                
                let headers = [
                    "Authorization": "Bearer " + (userAccessToken as! String),
                    "Content-Type": "application/json"
                ]
                
                let parameters = ["public_token": accessToken]
                
                Alamofire.request(.POST, endpoint, parameters: parameters, encoding: .JSON, headers: headers).responseJSON { response in
                    switch response.result {
                    case .Success:
                        if let value = response.result.value {
                            let data = JSON(value)
                            self.dismissViewControllerAnimated(true) {
                                let token = data["response"]["stripe_bank_account_token"]
                                self.showSuccessAlert()
                                completionHandler(token.stringValue)
                            }
                        }
                    case .Failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
    
    func linkBankToStripe(bankToken: String) {
        if(userAccessToken != nil) {
            User.getProfile { (user, NSError) in
                
                let endpoint = apiUrl + "/v1/stripe/" + user!.id + "/external_account"
                
                let headers = [
                    "Authorization": "Bearer " + (userAccessToken as! String),
                    "Content-Type": "application/json"
                ]
                
                let parameters = ["external_account": bankToken]
                
                Alamofire.request(.POST, endpoint, parameters: parameters, encoding: .JSON, headers: headers).responseJSON { response in
                    switch response.result {
                    case .Success:
                        if let value = response.result.value {
                            let data = JSON(value)
                            // print(data)
                        }
                    case .Failure(let error):
                        print(error)
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
    
    func showSuccessAlert() {
        let customIcon:UIImage = UIImage(named: "ic_check_light")! // your custom icon UIImage
        let customColor:UIColor = UIColor(rgba: "#1EBC61") // base color for the alert
        let alertView = JSSAlertView().show(
            self,
            title: "",
            text: "Bank connected!",
            buttonText: "",
            noButtons: true,
            color: customColor,
            iconImage: customIcon)
        alertView.setTextTheme(.Light) // can be .Light or .Dark
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}