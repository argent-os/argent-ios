//
//  AddCustomerViewController.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 3/15/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import JSSAlertView
import MessageUI
import DKCircleButton

final class AddCustomerViewController: UIViewController, UINavigationBarDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {
    
    // MARK: Public
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setupNav()
    }
    
    // MARK: Private
    
    private func setupNav() {
        let navigationBar = UINavigationBar(frame: CGRectMake(0, 0, self.view.frame.size.width, 50)) // Offset by 20 pixels vertically to take the status bar into account
        
        navigationBar.backgroundColor = UIColor.whiteColor()
        navigationBar.tintColor = UIColor.mediumBlue()
        navigationBar.delegate = self
        
        // Create a navigation item with a title
        let navigationItem = UINavigationItem()
        navigationItem.title = "Invite Customer"

        // Create left and right button for navigation item
        let leftButton = UIBarButtonItem(image: UIImage(named: "IconClose"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AddCustomerViewController.returnToMenu(_:)))
        let font = UIFont(name: "Avenir-Book", size: 14)
        leftButton.setTitleTextAttributes([NSFontAttributeName: font!, NSForegroundColorAttributeName:UIColor.mediumBlue()], forState: UIControlState.Normal)
        // Create two buttons for the navigation item
        navigationItem.leftBarButtonItem = leftButton
        
        // Assign the navigation item to the navigation bar
        navigationBar.titleTextAttributes = [NSFontAttributeName: font!, NSForegroundColorAttributeName:UIColor.darkGrayColor()]
        navigationBar.items = [navigationItem]
        
        // Make the navigation bar a subview of the current view controller
        self.view.addSubview(navigationBar)
    }
    
    override func viewDidAppear(animated: Bool) {
        // screen width and height:
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
    }
    
    private func configure() {
        
        // screen width and height:
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        title = "Invite Customer"
        
        let emailButton: DKCircleButton = DKCircleButton(frame: CGRectMake(0, 0, 90, 90))
        emailButton.center = CGPointMake(self.view.layer.frame.width/2, screenHeight*0.3)
        emailButton.titleLabel!.font = UIFont.systemFontOfSize(22)
        emailButton.borderColor = UIColor.slateBlue()
        emailButton.tintColor = UIColor.slateBlue()
        emailButton.setTitle("Email", forState: .Normal)
        emailButton.setTitleColor(UIColor.slateBlue(), forState: .Normal)
        let str0 = NSAttributedString(string: "Email", attributes:
            [
                NSFontAttributeName: UIFont.systemFontOfSize(12),
                NSForegroundColorAttributeName:UIColor.slateBlue()
            ])
        emailButton.setAttributedTitle(str0, forState: .Normal)
        emailButton.addTarget(self, action: #selector(AddCustomerViewController.sendEmailButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(emailButton)
        
        
        let smsButton: DKCircleButton = DKCircleButton(frame: CGRectMake(0, 0, 90, 90))
        smsButton.center = CGPointMake(self.view.layer.frame.width/2, screenHeight*0.6)
        smsButton.titleLabel!.font = UIFont.systemFontOfSize(22)
        smsButton.borderColor = UIColor.slateBlue()
        smsButton.tintColor = UIColor.slateBlue()
        smsButton.setTitle("SMS", forState: .Normal)
        smsButton.setTitleColor(UIColor.slateBlue(), forState: .Normal)
        let str1 = NSAttributedString(string: "SMS", attributes:
            [
                NSFontAttributeName: UIFont.systemFontOfSize(12),
                NSForegroundColorAttributeName:UIColor.slateBlue()
            ])
        smsButton.setAttributedTitle(str1, forState: .Normal)
        smsButton.addTarget(self, action: #selector(AddCustomerViewController.sendSMSButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(smsButton)
        
        self.navigationItem.title = "Invite Customer"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.darkGrayColor()]
        
    }
    
    func addCustomerButtonTapped(sender: AnyObject) {
        
        showSuccessAlert()
    }
    
    func showSuccessAlert() {
        let customIcon:UIImage = UIImage(named: "ic_check_light")! // your custom icon UIImage
        let customColor:UIColor = UIColor(rgba: "#1EBC61") // base color for the alert
        let alertView = JSSAlertView().show(
            self,
            title: "",
            text: "Invite sent!",
            buttonText: "",
            noButtons: true,
            color: customColor,
            iconImage: customIcon)
        alertView.setTextTheme(.Light) // can be .Light or .Dark
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
    
    
    // MARK: Email Composition
    
    @IBAction func sendEmailButtonTapped(sender: AnyObject) {
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
        mailComposerVC.setSubject("Message from Argent User")
        mailComposerVC.setMessageBody("Hello!", isHTML: false)
        
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
    
    // MARK: SMS Composition
    
    @IBAction func sendSMSButtonTapped(sender: AnyObject) {
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
        composeSMSVC.body = "Hello from Argent!"
        
        return composeSMSVC
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController,
                                      didFinishWithResult result: MessageComposeResult) {
        // Check the result or perform other tasks.
        
        // Dismiss the mail compose view controller.
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
}