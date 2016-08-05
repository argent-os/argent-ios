//
//  BankManualAddViewController.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 6/16/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import Crashlytics
import MZFormSheetPresentationController
import EasyTipView

class BankManualAddViewController: UIViewController, UIScrollViewDelegate, UINavigationBarDelegate, UITextFieldDelegate {
    
    let navigationBar = UINavigationBar()
    
    let scrollView:UIScrollView = UIScrollView()

    let flagImg:UIImageView = UIImageView()

    let infoLabel = UILabel()
    
    let infoTypeLabel = UILabel()
    
    let infoCountryLabel = UILabel()
    
    let routingTextLabel = UILabel()
    
    let routingTextField = SKTextField()
    
    let accountTextLabel = UILabel()
    
    let accountTextField = SKTextField()
    
    let addBankButton = UIButton()
    
    let helpButton = UIButton()
    
    var bankDic: NSDictionary?
    
    var rightButton = UIBarButtonItem()
    
    let tipView = EasyTipView(text: "All information processed is SHA-256 Bit encrypted with end-to-end SSL. We do not store bank account information on our servers.", preferences: EasyTipView.globalPreferences)
    
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

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configure() {
        
        self.view.backgroundColor = UIColor.offWhite()

        addToolbarButton()
        addHelpButton()
        
//        self.navigationItem.title = "Manual Entry"
//        self.navigationController?.navigationBar.tintColor = UIColor.lightBlue()
//        self.navigationController?.navigationBar.titleTextAttributes = [
//            NSFontAttributeName: UIFont.systemFontOfSize(14),
//            NSForegroundColorAttributeName: UIColor.lightBlue()
//        ]
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        scrollView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollEnabled = true
        scrollView.userInteractionEnabled = true
        scrollView.bounces = true
        scrollView.alwaysBounceVertical = true
        scrollView.decelerationRate = 0.3
        scrollView.contentSize = CGSizeMake(screenWidth, screenHeight*1.2)
        self.view!.addSubview(scrollView)
        
        // country and bank type | checking & savings
        infoLabel.frame = CGRect(x: 20, y: 80, width: screenWidth-40, height: 70)
        infoLabel.backgroundColor = UIColor.whiteColor()
        infoLabel.textColor = UIColor.lightBlue()
        infoLabel.layer.borderColor = UIColor.lightBlue().colorWithAlphaComponent(0.2).CGColor
        infoLabel.layer.borderWidth = 1
        infoLabel.layer.cornerRadius = 5
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
        routingTextField.layer.borderColor = UIColor.lightBlue().colorWithAlphaComponent(0.2).CGColor
        routingTextField.layer.borderWidth = 1
        routingTextField.layer.cornerRadius = 5
        routingTextField.layer.masksToBounds = true
        routingTextField.textAlignment = .Right
        routingTextField.keyboardType = .NumberPad
        routingTextField.delegate = self
        routingTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), forControlEvents: .ValueChanged)

        routingTextLabel.text = "ACH Routing #"
        routingTextLabel.frame = CGRect(x: 40, y: 170, width: screenWidth-40, height: 70)
        routingTextLabel.textColor = UIColor.mediumBlue()
        routingTextLabel.font = UIFont.systemFontOfSize(UIFont.systemFontSize(), weight: UIFontWeightLight)
        
        scrollView.addSubview(routingTextLabel)
        scrollView.bringSubviewToFront(routingTextLabel)
        scrollView.addSubview(routingTextField)
        scrollView.sendSubviewToBack(routingTextField)
        
        // account number textfield and label
        accountTextField.frame = CGRect(x: 20, y: 260, width: screenWidth-40, height: 70)
        accountTextField.backgroundColor = UIColor.whiteColor()
        accountTextField.textColor = UIColor.lightBlue()
        accountTextField.layer.borderColor = UIColor.lightBlue().colorWithAlphaComponent(0.2).CGColor
        accountTextField.layer.borderWidth = 1
        accountTextField.layer.cornerRadius = 5
        accountTextField.layer.masksToBounds = true
        accountTextField.textAlignment = .Right
        accountTextField.keyboardType = .NumberPad
        
        accountTextLabel.frame = CGRect(x: 40, y: 260, width: screenWidth-40, height: 70)
        accountTextLabel.text = "Account #"
        accountTextLabel.textColor = UIColor.mediumBlue()
        accountTextLabel.font = UIFont.systemFontOfSize(UIFont.systemFontSize(), weight: UIFontWeightLight)
        
        scrollView.addSubview(accountTextLabel)
        scrollView.bringSubviewToFront(accountTextLabel)
        scrollView.addSubview(accountTextField)
        scrollView.sendSubviewToBack(accountTextField)

        helpButton.frame = CGRect(x: 20, y: screenHeight-180, width: screenWidth-40, height: 60)
        helpButton.setTitleColor(UIColor.lightBlue(), forState: .Normal)
        helpButton.setBackgroundColor(UIColor.clearColor(), forState: .Normal)
        helpButton.setBackgroundColor(UIColor.offWhite(), forState: .Highlighted)
        helpButton.backgroundColor = UIColor.clearColor()
        helpButton.layer.borderColor = UIColor.clearColor().CGColor
        helpButton.layer.borderWidth = 1
        helpButton.layer.cornerRadius = 10
        helpButton.layer.masksToBounds = true
        helpButton.addTarget(self, action: #selector(self.showTutorialModal(_:)), forControlEvents: .TouchUpInside)
        var attribs2: [String: AnyObject] = [:]
        attribs2[NSFontAttributeName] = UIFont.systemFontOfSize(14)
        attribs2[NSForegroundColorAttributeName] = UIColor.lightBlue()
        let str2 = NSAttributedString(string: "Example Check", attributes: attribs2)
        helpButton.setAttributedTitle(str2, forState: .Normal)
        scrollView.addSubview(helpButton)
        scrollView.bringSubviewToFront(helpButton)
        
        addBankButton.frame = CGRect(x: 0, y: screenHeight-110, width: screenWidth, height: 60)
        addBankButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        addBankButton.setBackgroundColor(UIColor.skyBlue(), forState: .Normal)
        addBankButton.setBackgroundColor(UIColor.skyBlue().darkerColor(), forState: .Highlighted)
        addBankButton.layer.borderColor = UIColor.skyBlue().CGColor
        addBankButton.layer.borderWidth = 0
        addBankButton.layer.cornerRadius = 0
        addBankButton.layer.masksToBounds = true
        addBankButton.addTarget(self, action: #selector(linkBankToStripe(_:)), forControlEvents: .TouchUpInside)
        var attribs: [String: AnyObject] = [:]
        attribs[NSFontAttributeName] = UIFont.systemFontOfSize(14)
        attribs[NSForegroundColorAttributeName] = UIColor.whiteColor()
        let str = NSAttributedString(string: "Link Bank", attributes: attribs)
        addBankButton.setAttributedTitle(str, forState: .Normal)
        scrollView.addSubview(addBankButton)
        scrollView.bringSubviewToFront(addBankButton)

    }
    
    func textFieldDidChange(textField: UITextField) {
        print("changed")
        if textField.text?.characters.count > 8 {
            print("greater than 9")
            textField.textColor = UIColor.brandRed()
        }
    }
    
    func linkBankToStripe(sender: AnyObject) {
        
        if accountTextField.text == "" || routingTextField.text == "" {
            showAlert(.Error, title: "Error", msg: "Fields cannot be empty")
            return
        } else if routingTextField.text?.characters.count !== 9 {
            showAlert(.Error, title: "Error", msg: "Routing number must be 9 digits long")
            return
        }
        
        if userAccessToken != nil {
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
                
                Alamofire.request(.POST, endpoint, parameters: parameters, encoding: .JSON, headers: headers).responseJSON {
                    response in
                    switch response.result {
                    case .Success:
                        if let value = response.result.value {
                            let data = JSON(value)
                            if response.response?.statusCode == 200 {
                                Answers.logCustomEventWithName("Manual link bank to Stripe success",
                                    customAttributes: [:])
                                showAlert(.Success, title: "Success", msg: "Your bank account is now linked")

                            } else {
                                showAlert(.Error, title: "Error", msg: "Error linking bank account")

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
    
    // Add send toolbar
    func addToolbarButton()
    {
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let sendToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, screenWidth, 50))
        // sendToolbar.barStyle = UIBarStyle.Default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: #selector(self.dismissKeyboard(_:)))
        
        UIToolbar.appearance().barTintColor = UIColor.brandGreen()
        UIToolbar.appearance().backgroundColor = UIColor.brandGreen()

        done.setTitleTextAttributes([
            NSFontAttributeName : UIFont(name: "MyriadPro-Regular", size: 15)!,
            NSForegroundColorAttributeName : UIColor.whiteColor()
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
        scrollView.endEditing(true)
    }
}

extension BankManualAddViewController {
    // MARK: Tutorial modal
    
    func showTutorialModal(sender: AnyObject) {
        let navigationController = self.storyboard!.instantiateViewControllerWithIdentifier("bankManualModalNavigationController") as! UINavigationController
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: navigationController)
        
        print("showing tut")
        // Initialize and style the terms and conditions modal
        formSheetController.presentationController?.shouldApplyBackgroundBlurEffect = true
        formSheetController.presentationController?.contentViewSize = CGSizeMake(280, 230)
        formSheetController.presentationController?.shouldUseMotionEffect = true
        formSheetController.presentationController?.containerView?.backgroundColor = UIColor.blackColor()
        formSheetController.presentationController?.containerView?.sizeToFit()
        formSheetController.presentationController?.blurEffectStyle = UIBlurEffectStyle.Dark
        formSheetController.presentationController?.shouldDismissOnBackgroundViewTap = true
        formSheetController.presentationController?.movementActionWhenKeyboardAppears = MZFormSheetActionWhenKeyboardAppears.CenterVertically
        formSheetController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyle.SlideFromBottom
        formSheetController.contentViewCornerRadius = 10
        formSheetController.allowDismissByPanningPresentedView = true
        formSheetController.interactivePanGestureDismissalDirection = .All;
        
        // Blur will be applied to all MZFormSheetPresentationControllers by default
        MZFormSheetPresentationController.appearance().shouldApplyBackgroundBlurEffect = true
        
        let presentedViewController = navigationController.viewControllers.first as! BankManualTutorialViewController
        
        // keep passing along user data to modal
        presentedViewController.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
        presentedViewController.navigationItem.leftItemsSupplementBackButton = true
        
        // Be sure to update current module on storyboard
        self.presentViewController(formSheetController, animated: true, completion: nil)
    }
}

extension BankManualAddViewController {
    func addHelpButton() {
        // Offset by 20 pixels vertically to take the status bar into account
        navigationBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 50)
        navigationBar.backgroundColor = UIColor.clearColor()
        navigationBar.tintColor = UIColor.lightBlue()
        navigationBar.delegate = self
        
        // Assign the navigation item to the navigation bar
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.lightBlue()]
        
        // Create left and right button for navigation item
        rightButton = UIBarButtonItem(title: "Encryption", style: .Plain, target: self, action: #selector(self.presentTutorial(_:)))
        rightButton.setTitleTextAttributes([
            NSForegroundColorAttributeName:UIColor.darkBlue(),
            NSFontAttributeName: UIFont(name: "MyriadPro-Regular", size: 17)!
        ], forState: UIControlState.Normal)
        // Create two buttons for the navigation item
        navigationItem.rightBarButtonItem = rightButton
        
        // Assign the navigation item to the navigation bar
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.lightBlue()]
        navigationBar.items = [navigationItem]
        
        self.view.addSubview(navigationBar)
    }
    
    func presentTutorial(sender: AnyObject) {
        var preferences = EasyTipView.Preferences()
        preferences.drawing.font = UIFont(name: "MyriadPro-Regular", size: 13)!
        preferences.drawing.foregroundColor = UIColor.whiteColor()
        preferences.drawing.backgroundColor = UIColor.skyBlue()
        preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.Top
        tipView.show(forView: self.infoLabel, withinSuperview: self.view)
        
        Answers.logCustomEventWithName("Bank Security Tutorial Presented",
                                       customAttributes: [:])
        
        // TODO: Remove Gecco and AnimatedSwitch
    }
}