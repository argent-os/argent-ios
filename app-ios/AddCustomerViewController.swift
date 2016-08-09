//
//  AddCustomerViewController.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 3/15/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import MessageUI
import DKCircleButton
import Crashlytics

final class AddCustomerViewController: UIViewController, UINavigationBarDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {
    
    // MARK: Public
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setupNav()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: Private
    
    private func setupNav() {
        let navigationBar = UINavigationBar(frame: CGRectMake(0, 0, self.view.frame.size.width, 50)) // Offset by 20 pixels vertically to take the status bar into account
        
        navigationBar.backgroundColor = UIColor.clearColor()
        navigationBar.tintColor = UIColor.whiteColor()
        navigationBar.delegate = self
        
        // Create a navigation item with a title
        let navigationItem = UINavigationItem()
        navigationItem.title = ""

        // Create left and right button for navigation item
        let leftButton = UIBarButtonItem(image: UIImage(named: "IconClose"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AddCustomerViewController.returnToMenu(_:)))
        let font = UIFont.systemFontOfSize(14)
        leftButton.setTitleTextAttributes([NSFontAttributeName: font, NSForegroundColorAttributeName:UIColor.mediumBlue()], forState: UIControlState.Normal)
        // Create two buttons for the navigation item
        navigationItem.leftBarButtonItem = leftButton
        
        // Assign the navigation item to the navigation bar
        navigationBar.titleTextAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName:UIColor.darkGrayColor()]
        navigationBar.items = [navigationItem]
        
        // Make the navigation bar a subview of the current view controller
        self.view.addSubview(navigationBar)
    }
    
    override func viewDidAppear(animated: Bool) {
        // screen width and height:
        // let screen = UIScreen.mainScreen().bounds
        //let screenWidth = screen.size.width
        //let screenHeight = screen.size.height
    }
    
    private func configure() {
        
        // screen width and height:
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
//        self.view.backgroundColor = UIColor.offWhite()
        let backgroundImageView = UIImageView(image: UIImage(named: "BackgroundGradientBlueDark"), highlightedImage: nil)
        backgroundImageView.frame = CGRectMake(0, 0, screenWidth, screenHeight)
        backgroundImageView.contentMode = .ScaleAspectFill
        backgroundImageView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        backgroundImageView.layer.masksToBounds = true
        backgroundImageView.clipsToBounds = true
        // backgroundImageView.addSubview(visualEffectView)
        self.view.sendSubviewToBack(backgroundImageView)
        self.view.addSubview(backgroundImageView)
        
        let imageView = UIImageView()
        let imageName = "LogoOutlineGradient"
        let image = UIImage(named: imageName)
        imageView.image = image
        imageView.layer.masksToBounds = true
        imageView.tag = 7577
        imageView.frame = CGRect(x: 0, y: 0, width: 75, height: 75)
        imageView.frame.origin.y = screenHeight*0.15
        imageView.frame.origin.x = (self.view.bounds.size.width - imageView.frame.size.width) / 2.0 // centered left to right.
        addSubviewWithFade(imageView, parentView: self, duration: 0.3)

        let lbl = UILabel()
        // Set range of string length to exactly 8, the number of characters
        lbl.frame = CGRect(x: 0, y: screenHeight*0.33, width: screenWidth, height: 40)
        lbl.font = UIFont(name: "MyriadPro-Regular", size: 23)
        lbl.tag = 7578
        lbl.textAlignment = NSTextAlignment.Center
        lbl.textColor = UIColor.whiteColor()
        lbl.adjustAttributedString("ARGENT", spacing: 4, fontName: "MyriadPro-Regular", fontSize: 23, fontColor: UIColor.whiteColor())
        addSubviewWithFade(lbl, parentView: self, duration: 0.3)

        let dividerView = UIImageView()
        dividerView.image = UIImage(named: "DividerWhite")?.alpha(0.5)
        dividerView.frame = CGRect(x: 100, y: screenHeight*0.39, width: screenWidth-200, height: 1)
        addSubviewWithFade(dividerView, parentView: self, duration: 0.3)
        
        let lblDetail = UILabel()
        // Set range of string length to exactly 8, the number of characters
        lblDetail.frame = CGRect(x: 0, y: screenHeight*0.39, width: screenWidth, height: 40)
        lblDetail.tag = 7579
        lblDetail.textAlignment = NSTextAlignment.Center
        lblDetail.textColor = UIColor.whiteColor()
        lblDetail.adjustAttributedString("INVITATION", spacing: 4, fontName: "MyriadPro-Regular", fontSize: 13, fontColor: UIColor.whiteColor())
        addSubviewWithFade(lblDetail, parentView: self, duration: 0.3)

        let lblBody = UILabel()
        // Set range of string length to exactly 8, the number of characters
        lblBody.frame = CGRect(x: 50, y: screenHeight*0.40, width: screenWidth-100, height: 200)
        lblBody.numberOfLines = 0
        lblBody.alpha = 0.9
        lblBody.adjustAttributedString("Spread the joy. Invite new users, customers, or friends to " + APP_NAME + " today.", spacing: 2, fontName: "HelveticaNeue-Light", fontSize: 14, fontColor: UIColor.whiteColor())
        lblBody.tag = 7579
        lblBody.textAlignment = NSTextAlignment.Center
        lblBody.textColor = UIColor.whiteColor()
        addSubviewWithFade(lblBody, parentView: self, duration: 0.3)
        
        let emailButton: DKCircleButton = DKCircleButton(frame: CGRectMake(45, screenHeight-180, 90, 90))
        emailButton.center = CGPointMake(self.view.layer.frame.width*0.3, screenHeight-130)
        emailButton.titleLabel!.font = UIFont.systemFontOfSize(22)
        emailButton.borderColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        emailButton.borderSize = 1
        emailButton.tintColor = UIColor.whiteColor()
        emailButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        let str0 = NSAttributedString(string: "Mail", attributes:
            [
                NSFontAttributeName: UIFont(name: "MyriadPro-Regular", size: 12)!,
                NSForegroundColorAttributeName:UIColor.whiteColor()
            ])
        emailButton.setAttributedTitle(str0, forState: .Normal)
        emailButton.addTarget(self, action: #selector(AddCustomerViewController.sendEmailButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        let _ = Timeout(0.4) {
            addSubviewWithFade(emailButton, parentView: self, duration: 0.3)
        }
        
        let smsButton: DKCircleButton = DKCircleButton(frame: CGRectMake(screenWidth/2+45, screenHeight-180, 90, 90))
        smsButton.center = CGPointMake(self.view.layer.frame.width*0.7, screenHeight-130)
        smsButton.titleLabel!.font = UIFont.systemFontOfSize(22)
        smsButton.borderColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        smsButton.borderSize = 1
        smsButton.tintColor = UIColor.whiteColor()
        smsButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        let str1 = NSAttributedString(string: "SMS", attributes:
            [
                NSFontAttributeName: UIFont(name: "MyriadPro-Regular", size: 12)!,
                NSForegroundColorAttributeName:UIColor.whiteColor()
            ])
        smsButton.setAttributedTitle(str1, forState: .Normal)
        smsButton.addTarget(self, action: #selector(AddCustomerViewController.sendSMSButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        let _ = Timeout(0.4) {
            addSubviewWithFade(smsButton, parentView: self, duration: 0.3)
        }
        
        self.navigationItem.title = ""
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
    }

    func returnToMenu(sender: AnyObject) {
        self.view.window!.rootViewController!.dismissViewControllerAnimated(true, completion: { _ in })
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        dismissKeyboard()
        super.viewWillDisappear(animated)
    }
    
    
}

extension AddCustomerViewController {
    
    // MARK: Email Composition
    
    @IBAction func sendEmailButtonTapped(sender: AnyObject) {
        Answers.logInviteWithMethod("Email",
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

        mailComposerVC.setToRecipients([])
        User.getProfile { (user, err) in
            //
            if let first_name = user?.first_name where first_name != "" {
                mailComposerVC.setSubject("Re: Message from " + first_name)
                mailComposerVC.setMessageBody("Hey it's " + first_name + ". Have you tried " + APP_NAME + "? It's a great app I've been using lately! Sending you the link " + APP_URL, isHTML: false)
            } else {
                mailComposerVC.setSubject("Re: Message from " + APP_NAME)
                mailComposerVC.setMessageBody("Hello from Argent! Check out our app: " + APP_URL, isHTML: false)
            }
        }
        
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

extension AddCustomerViewController {
    // MARK: SMS Composition
    
    @IBAction func sendSMSButtonTapped(sender: AnyObject) {
        Answers.logInviteWithMethod("SMS",
                                    customAttributes: nil)
        
        let smsComposeViewController = configuredSMSViewController()
        if !MFMessageComposeViewController.canSendText() {
            print("SMS services are not available")
        } else {
            self.presentViewController(smsComposeViewController, animated: true, completion: nil)
        }
    }
    
    func configuredSMSViewController() -> MFMessageComposeViewController {
        let composeSMSVC = MFMessageComposeViewController()
        composeSMSVC.messageComposeDelegate = self
        
        // Configure the fields of the interface.
        composeSMSVC.recipients = ([])
        User.getProfile { (user, err) in
            //
            if let first_name = user?.first_name where first_name != "" {
                composeSMSVC.body = "Hey it's " + first_name + ". Have you tried " + APP_NAME + "? It's a great app I've been using lately! Sending you the link " + APP_URL
            } else {
                composeSMSVC.body = "Hello from " + APP_NAME + "!" + " Check out our app: " + APP_URL
            }
        }
        
        return composeSMSVC
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController,
                                      didFinishWithResult result: MessageComposeResult) {
        // Check the result or perform other tasks.
        
        // Dismiss the mail compose view controller.
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}