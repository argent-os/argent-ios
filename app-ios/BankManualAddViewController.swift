//
//  BankManualAddViewController.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 6/16/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import JSSAlertView
import Alamofire
import SwiftyJSON
import Crashlytics

class BankManualAddViewController: UIViewController {
    
    let flagImg:UIImageView = UIImageView()

    let infoLabel = UILabel()
    
    let infoTypeLabel = UILabel()
    
    let infoCountryLabel = UILabel()
    
    let routingTextLabel = UILabel()
    
    let routingTextField = SKTextField()
    
    let accountTextLabel = UILabel()
    
    let accountTextField = SKTextField()
    
    let addBankButton = UIButton()
    
    var bankDic: NSDictionary?
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidAppear(animated: Bool) {

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configure() {
        
        self.view.backgroundColor = UIColor.offWhite()

        self.navigationItem.title = "Manual Entry"
        self.navigationController?.navigationBar.tintColor = UIColor.lightBlue()
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont.systemFontOfSize(14),
            NSForegroundColorAttributeName: UIColor.lightBlue()
        ]
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        
        // country and bank type | checking & savings
        infoLabel.frame = CGRect(x: 20, y: 80, width: screenWidth-40, height: 70)
        infoLabel.backgroundColor = UIColor.whiteColor()
        infoLabel.textColor = UIColor.lightBlue()
        infoLabel.layer.borderColor = UIColor.lightBlue().colorWithAlphaComponent(0.5).CGColor
        infoLabel.layer.borderWidth = 1
        infoLabel.layer.cornerRadius = 10
        infoLabel.layer.masksToBounds = true
        
        infoTypeLabel.frame = CGRect(x: 40, y: 80, width: 200, height: 70)
        infoTypeLabel.textColor = UIColor.lightBlue()
        infoTypeLabel.text = "Checking"
        infoTypeLabel.font = UIFont.systemFontOfSize(UIFont.systemFontSize(), weight: UIFontWeightLight)
        
        let countryCode = NSLocale.currentLocale().objectForKey(NSLocaleCountryCode) as! String
        NSUserDefaults.standardUserDefaults().setValue(countryCode, forKey: "userCountry")
        let countryName: String = NSLocale.systemLocale().displayNameForKey(NSLocaleCountryCode, value: countryCode)!
        infoCountryLabel.text = countryName
        infoCountryLabel.font = UIFont.systemFontOfSize(UIFont.systemFontSize(), weight: UIFontWeightLight)
        infoCountryLabel.frame = CGRect(x: screenWidth-275, y: 80, width: 200, height: 70)
        infoCountryLabel.textColor = UIColor.lightBlue()
        infoCountryLabel.textAlignment = .Right
        
        flagImg.image = UIImage(flagImageWithCountryCode: NSLocale.autoupdatingCurrentLocale().objectForKey(NSLocaleCountryCode) as! String)
        flagImg.layer.cornerRadius = 10
        flagImg.layer.masksToBounds = true
        flagImg.contentMode = .ScaleAspectFit
        flagImg.frame = CGRect(x: screenWidth-65, y: 102, width: 25, height: 25)
        
        addSubviewWithFade(infoLabel, parentView: self, duration: 0.3)
        addSubviewWithFade(infoTypeLabel, parentView: self, duration: 0.3)
        addSubviewWithFade(infoCountryLabel, parentView: self, duration: 0.3)
        addSubviewWithFade(flagImg, parentView: self, duration: 0.3)
        
        // routing number label and textfield
        routingTextField.frame = CGRect(x: 20, y: 170, width: screenWidth-40, height: 70)
        routingTextField.backgroundColor = UIColor.whiteColor()
        routingTextField.textColor = UIColor.lightBlue()
        routingTextField.layer.borderColor = UIColor.lightBlue().colorWithAlphaComponent(0.5).CGColor
        routingTextField.layer.borderWidth = 1
        routingTextField.layer.cornerRadius = 10
        routingTextField.layer.masksToBounds = true
        routingTextField.textAlignment = .Right
        routingTextField.keyboardType = .NumberPad

        routingTextLabel.text = "ACH Routing #"
        routingTextLabel.frame = CGRect(x: 40, y: 170, width: screenWidth-40, height: 70)
        routingTextLabel.textColor = UIColor.lightBlue()
        routingTextLabel.font = UIFont.systemFontOfSize(UIFont.systemFontSize(), weight: UIFontWeightLight)
        
        addSubviewWithFade(routingTextLabel, parentView: self, duration: 0.3)
        self.view.bringSubviewToFront(routingTextLabel)
        addSubviewWithFade(routingTextField, parentView: self, duration: 0.3)
        self.view.sendSubviewToBack(routingTextField)
        
        // account number textfield and label
        accountTextField.frame = CGRect(x: 20, y: 260, width: screenWidth-40, height: 70)
        accountTextField.backgroundColor = UIColor.whiteColor()
        accountTextField.textColor = UIColor.lightBlue()
        accountTextField.layer.borderColor = UIColor.lightBlue().colorWithAlphaComponent(0.5).CGColor
        accountTextField.layer.borderWidth = 1
        accountTextField.layer.cornerRadius = 10
        accountTextField.layer.masksToBounds = true
        accountTextField.textAlignment = .Right
        accountTextField.keyboardType = .NumberPad
        
        accountTextLabel.frame = CGRect(x: 40, y: 260, width: screenWidth-40, height: 70)
        accountTextLabel.text = "Account #"
        accountTextLabel.textColor = UIColor.lightBlue()
        accountTextLabel.font = UIFont.systemFontOfSize(UIFont.systemFontSize(), weight: UIFontWeightLight)
        
        addSubviewWithFade(accountTextLabel, parentView: self, duration: 0.3)
        self.view.bringSubviewToFront(accountTextLabel)
        addSubviewWithFade(accountTextField, parentView: self, duration: 0.3)
        self.view.sendSubviewToBack(accountTextField)

        addBankButton.frame = CGRect(x: 20, y: screenHeight-130, width: screenWidth-40, height: 60)
        addBankButton.setTitle("Add Bank", forState: .Normal)
        addBankButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        addBankButton.setBackgroundColor(UIColor.lightBlue(), forState: .Normal)
        addBankButton.setBackgroundColor(UIColor.mediumBlue(), forState: .Highlighted)
        addBankButton.backgroundColor = UIColor.lightBlue()
        addBankButton.layer.borderColor = UIColor.lightBlue().CGColor
        addBankButton.layer.borderWidth = 1
        addBankButton.layer.cornerRadius = 10
        addBankButton.layer.masksToBounds = true
        addBankButton.addTarget(self, action: #selector(linkBankToStripe(_:)), forControlEvents: .TouchUpInside)
        addSubviewWithFade(addBankButton, parentView: self, duration: 0.3)
        self.view.bringSubviewToFront(addBankButton)

    }
    
    func linkBankToStripe(sender: AnyObject) {
        if(userAccessToken != nil) {
            User.getProfile { (user, NSError) in
                
                let endpoint = API_URL + "/stripe/" + user!.id + "/external_account?type=bank"
                
                let headers = [
                    "Authorization": "Bearer " + (userAccessToken as! String),
                    "Content-Type": "application/json"
                ]
                
                let parameters = ["external_account": [
                        "object": "bank_account",
                        "currency": "usd",
                        "country": "US",
                        "account_number": self.accountTextField.text ?? "",
                        "routing_number": self.routingTextField.text ?? ""
                    ]
                ]
                
                print(parameters)
                
                Alamofire.request(.POST, endpoint, parameters: parameters, encoding: .JSON, headers: headers).responseJSON {
                    response in
                    switch response.result {
                    case .Success:
                        if let value = response.result.value {
                            let data = JSON(value)
                            if response.response?.statusCode == 200 {
                                Answers.logCustomEventWithName("Manual link bank to Stripe success",
                                    customAttributes: [:])
                            } else {
                                self.showAlert("Error", msg: "Could not link bank account, please contact support for help", color: UIColor.brandRed(), image: UIImage(named: "ic_close_light")!)
                                Answers.logCustomEventWithName("Manual link bank account link failure",
                                    customAttributes: [:])
                            }
                        }
                    case .Failure(let error):
                        print(error)
                        Answers.logCustomEventWithName("Manual link bank to Stripe failed",
                            customAttributes: [
                                "error": error.localizedDescription
                            ])
                    }
                }
            }
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

class SKTextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20);
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}