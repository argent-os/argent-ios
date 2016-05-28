//
//  RiskProfileViewController.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 5/4/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import Alamofire
import JSSAlertView
import SwiftyJSON
import KeychainSwift

class RiskProfileViewController: UIViewController {
    
    @IBOutlet weak var enableRiskProfileButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()
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
        
        enableRiskProfileButton.layer.cornerRadius = 10
        enableRiskProfileButton.clipsToBounds = true
        enableRiskProfileButton.backgroundColor = UIColor.lightBlue()
        
        self.navigationItem.title = "Risk Profile"
        self.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont.systemFontOfSize(14),
            NSForegroundColorAttributeName: UIColor.darkGrayColor()
        ]
        
    }
    
    func enableRiskProfiling(sender: AnyObject) {
        // ** NOTE: this access_token is actually the public_token sent to the API
        // take this access token and connect bank account to stripe
        // save access token to user database
        // http://localhost:8080/v1/plaid/:uid/exchange_token
        if(userAccessToken != nil) {
            User.getProfile { (user, NSError) in
                
                let endpoint = API_URL + "/v1/plaid/" + user!.id + "/upgrade"
                
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
                            self.showSuccessAlert("Risk Profile Enabled", color: UIColor(rgba: "#1EBC61"))
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
        showDisabledAlert("Risk Profile Disabled", color: UIColor.mediumBlue())
    }
    
    func showSuccessAlert(str: String, color: UIColor) {
        let customIcon:UIImage = UIImage(named: "ic_check_light")! // your custom icon UIImage
        self.view.endEditing(true)
        let alertView = JSSAlertView().show(
            self,
            title: "",
            text: str,
            buttonText: "Ok",
            noButtons: false,
            color: color,
            iconImage: customIcon)
        alertView.setTextTheme(.Light) // can be .Light or .Dark
    }
    
    func showDisabledAlert(str: String, color: UIColor) {
        let customIcon:UIImage = UIImage(named: "ic_check_light")! // your custom icon UIImage
        self.view.endEditing(true)
        let alertView = JSSAlertView().show(
            self,
            title: "",
            text: str,
            buttonText: "Ok",
            noButtons: false,
            color: color,
            iconImage: customIcon)
        alertView.setTextTheme(.Light) // can be .Light or .Dark
    }
    

}