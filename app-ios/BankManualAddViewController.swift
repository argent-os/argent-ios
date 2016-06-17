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

class BankManualAddViewController: UIViewController, UIScrollViewDelegate {
    
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

        addToolbarButton()
        
        self.navigationItem.title = "Manual Entry"
        self.navigationController?.navigationBar.tintColor = UIColor.lightBlue()
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont.systemFontOfSize(14),
            NSForegroundColorAttributeName: UIColor.lightBlue()
        ]
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        
        let scrollView:UIScrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: -40, width: screenWidth, height: screenHeight)
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollEnabled = true
        scrollView.userInteractionEnabled = true
        scrollView.contentSize = CGSizeMake(screenWidth, screenHeight*1.2)
        self.view!.addSubview(scrollView)
        
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
        
        scrollView.addSubview(infoLabel)
        scrollView.addSubview(infoTypeLabel)
        scrollView.addSubview(infoCountryLabel)
        scrollView.addSubview(flagImg)
        
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
        
        scrollView.addSubview(routingTextLabel)
        scrollView.bringSubviewToFront(routingTextLabel)
        scrollView.addSubview(routingTextField)
        scrollView.sendSubviewToBack(routingTextField)
        
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
        
        scrollView.addSubview(accountTextLabel)
        scrollView.bringSubviewToFront(accountTextLabel)
        scrollView.addSubview(accountTextField)
        scrollView.sendSubviewToBack(accountTextField)

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
        scrollView.addSubview(addBankButton)
        scrollView.bringSubviewToFront(addBankButton)

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
    
    
    // Add send toolbar
    func addToolbarButton()
    {
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let sendToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, screenWidth, 50))
        // sendToolbar.barStyle = UIBarStyle.Default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: #selector(self.dismissKeyboard(_:)))
        
        UIToolbar.appearance().barTintColor = UIColor.whiteColor()
        
        done.setTitleTextAttributes([
            NSFontAttributeName : UIFont.systemFontOfSize(15, weight: UIFontWeightLight),
            NSForegroundColorAttributeName : UIColor.mediumBlue()
            ], forState: .Normal)
        
        var items: [UIBarButtonItem]? = [UIBarButtonItem]()
        items?.append(flexSpace)
        items?.append(done)
        items?.append(flexSpace)
        
        sendToolbar.items = items
        sendToolbar.sizeToFit()
        accountTextField.inputAccessoryView=sendToolbar
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard(sender: AnyObject) {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}