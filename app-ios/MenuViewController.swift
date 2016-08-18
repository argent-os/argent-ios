//
//  MenuViewController.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 3/7/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import TransitionTreasury
import TransitionAnimation
import Shimmer
import KeychainSwift
import XLPagerTabStrip
import Crashlytics
import MessageUI

class MenuViewController: ButtonBarPagerTabStripViewController, MFMailComposeViewControllerDelegate {

    private let viewTerminalImageView = UIView()

    private let addPlanImageView = UIView()
    
    @IBOutlet weak var barButtonView: ButtonBarView!
    
    let blueInstagramColor = UIColor.oceanBlue()
    
    let appVersionString: String = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String

    override func viewDidLoad() {
        super.viewDidLoad()
        configureMainMenu()
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    func configureMainMenu() {
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        barButtonView.backgroundColor = UIColor.whiteColor()
        
        // THIS SETS STATUS BAR COLOR
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        
        // change selected bar color
        settings.style.buttonBarBackgroundColor = UIColor.whiteColor()
        settings.style.buttonBarItemBackgroundColor = UIColor.whiteColor()
        settings.style.selectedBarBackgroundColor = UIColor.whiteColor()
        settings.style.buttonBarItemTitleColor = UIColor.skyBlue()
        settings.style.buttonBarItemFont = UIFont(name: "SFUIText-Regular", size: 14)!
        settings.style.selectedBarHeight = 20
        settings.style.buttonBarMinimumLineSpacing = 5
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 40
        settings.style.buttonBarRightContentInset = 40
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .blackColor()
            newCell?.label.textColor = self?.blueInstagramColor
        }

        setupNav()
        
        let versionLabel = UILabel()
        versionLabel.frame = CGRect(x: 0, y: screenHeight-185, width: screenWidth, height: 40)
        versionLabel.textAlignment = .Center
        versionLabel.font = UIFont(name: "SFUIText-Regular", size: 13)!
        versionLabel.textColor = UIColor.lightBlue().lighterColor()
        versionLabel.text = "Version " + appVersionString
        self.view.addSubview(versionLabel)
        
        let feedbackButton = UIButton()
        feedbackButton.frame = CGRect(x: 0, y: screenHeight-160, width: screenWidth, height: 40)
        let str = NSAttributedString(string: "Send Feedback", attributes: [
            NSForegroundColorAttributeName : UIColor.lightBlue().lighterColor(),
            NSFontAttributeName : UIFont(name: "SFUIText-Regular", size: 13)!
        ])
        let str2 = NSAttributedString(string: "Send Feedback", attributes: [
            NSForegroundColorAttributeName : UIColor.lightBlue().darkerColor(),
            NSFontAttributeName : UIFont(name: "SFUIText-Regular", size: 13)!
        ])
        feedbackButton.backgroundColor = UIColor.clearColor()
        feedbackButton.layer.borderColor = UIColor.clearColor().CGColor
        feedbackButton.setAttributedTitle(str, forState: .Normal)
        feedbackButton.setAttributedTitle(str2, forState: .Highlighted)
        feedbackButton.addTarget(self, action: #selector(sendEmailButtonTapped(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(feedbackButton)
        
        let verificationLabel = UILabel()
        verificationLabel.frame = CGRect(x: 15, y: screenHeight-235, width: screenWidth-30, height: 40)
        verificationLabel.textAlignment = .Center
        verificationLabel.font = UIFont(name: "SFUIText-Regular", size: 13)!
        verificationLabel.layer.borderColor = UIColor.oceanBlue().CGColor
        verificationLabel.layer.borderWidth = 1
        verificationLabel.layer.cornerRadius = 3
        verificationLabel.textColor = UIColor.oceanBlue()
        self.checkIfVerified({ (bool, err) in
            if bool == true {
                verificationLabel.text = "Account Status: Verified"
                addSubviewWithFade(verificationLabel, parentView: self, duration: 0.5)
                verificationLabel.textColor = UIColor.brandGreen()
                verificationLabel.layer.borderColor = UIColor.brandGreen().CGColor
            } else {
                verificationLabel.text = "Account Status: Pending Verification"
                addSubviewWithFade(verificationLabel, parentView: self, duration: 0.5)
            }
            
            // iphone4 check
            if self.view.layer.frame.height <= 480.0 {
                verificationLabel.frame = CGRect(x: 15, y: screenHeight-205, width: screenWidth-30, height: 40)
                verificationLabel.layer.borderWidth = 0
            }
        })
    }
    
    func setupNav() {
        
        // NAV
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        //let screenHeight = screen.size.height
        
        self.navigationItem.title = "Menu"
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.oceanBlue()
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "SFUIText-Regular", size: 17)!
        ]
        
    }
    
    func checkIfVerified(completionHandler: (Bool, NSError?) -> ()){
        Account.getStripeAccount { (acct, err) in
            let fields = acct?.verification_fields_needed
            let disabled = acct?.verification_disabled_reason
            let _ = fields.map { (unwrappedOptionalArray) -> Void in
                // if array has values
                if !unwrappedOptionalArray.isEmpty || disabled != "" {
                    // print("checking if empty... false")
                    completionHandler(false, nil)
                } else {
                    // print("checking if empty... true")
                    completionHandler(true, nil)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Delegate Methods
    
    //Changing Status Bar
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    //Changing Status Bar
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "menuView") {
            let rootViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("RootViewController"))! as UIViewController
            self.presentViewController(rootViewController, animated: true, completion: nil)
        }
    }

    // MARK: - PagerTabStripDataSource
    
    override func viewControllersForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = MenuChildViewControllerOne(itemInfo: "MAIN")
        let child_2 = MenuChildViewControllerTwo(itemInfo: "OVERVIEW")
        return [child_1, child_2]
    }
}

extension MenuViewController {
    
    // MARK: Email Composition
    
    @IBAction func sendEmailButtonTapped(sender: AnyObject) {
        Answers.logInviteWithMethod("Email feedback",
                                    customAttributes: nil)
        
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["support@argent-tech.com"])
        mailComposerVC.setSubject("Re: Feedback for " + APP_NAME + " | Version " + self.appVersionString)
        mailComposerVC.setMessageBody("", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .Alert)
        sendMailErrorAlert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
