//
//  SearchDetailViewController.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 4/20/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import UIKit
import Foundation
import MessageUI
import Stripe
import JGProgressHUD
import Alamofire
import SwiftyJSON
import XLActionController
import MZFormSheetPresentationController
import AYVibrantButton

class SearchDetailViewController: UIViewController, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UINavigationBarDelegate {
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var stacks: UIStackView!
    
    let paymentTextField = STPPaymentCardTextField()
    
    var saveButton: UIButton! = nil;
    
    let lbl:UILabel = UILabel()

    var detailUser: User? {
        didSet {
            configureView()
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func configureView() {

        let screen = UIScreen.mainScreen().bounds
        let width = screen.size.width
        _ = screen.size.height
        
        // adds a manual credit card entry textfield
        // self.view.addSubview(paymentTextField)
        
        if let detailUser = detailUser {
            if let usernameLabel = usernameLabel {
                usernameLabel.text = detailUser.username
            }
            if let emailLabel = emailLabel {
                emailLabel.text = detailUser.email
            }
            
            // Email textfield
            lbl.text = detailUser.first_name + " " + detailUser.last_name
            lbl.frame = CGRectMake(0, 160, width, 110)
            lbl.textAlignment = .Center
            lbl.textColor = UIColor.whiteColor()
            lbl.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin]
            self.view.addSubview(lbl)

            // User image
            let pic = detailUser.picture
            if pic != "" {
                let img: UIImage = UIImage(data: NSData(contentsOfURL: NSURL(string: detailUser.picture)!)!)!
                let userImageView: UIImageView = UIImageView(frame: CGRectMake(width / 2, 0, 90, 90))
                userImageView.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin]
                userImageView.center = CGPointMake(self.view.bounds.size.width / 2, 135)
                userImageView.backgroundColor = UIColor.groupTableViewBackgroundColor()
                userImageView.layer.cornerRadius = userImageView.frame.size.height/2
                userImageView.layer.masksToBounds = true
                userImageView.clipsToBounds = true
                userImageView.image = img
                userImageView.layer.borderWidth = 3
                userImageView.layer.borderColor = UIColor(rgba: "#fffa").CGColor
                self.view.addSubview(userImageView)
                
                // Blurview
                let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
                visualEffectView.frame = CGRectMake(0, 0, width, 330)
                let blurImageView: UIImageView = UIImageView(frame: CGRectMake(0, 0, width, 330))
                blurImageView.contentMode = .ScaleAspectFill
                blurImageView.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin]
                blurImageView.layer.masksToBounds = true
                blurImageView.clipsToBounds = true
                blurImageView.image = img
                self.view.addSubview(blurImageView)
                blurImageView.addSubview(visualEffectView)
                self.view.sendSubviewToBack(blurImageView)
            } else {
                let img: UIImage = UIImage(named: "LogoRound")!
                let userImageView: UIImageView = UIImageView(frame: CGRectMake(width / 2, 0, 90, 90))
                userImageView.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin]
                userImageView.center = CGPointMake(self.view.bounds.size.width / 2, 135)
                userImageView.backgroundColor = UIColor.groupTableViewBackgroundColor()
                userImageView.layer.cornerRadius = userImageView.frame.size.height/2
                userImageView.layer.masksToBounds = true
                userImageView.clipsToBounds = true
                userImageView.image = img
                userImageView.layer.borderWidth = 1
                userImageView.layer.borderColor = UIColor(rgba: "#fffa").CGColor
                self.view.addSubview(userImageView)
                
                // Blurview
                let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
                visualEffectView.frame = CGRectMake(0, 0, width, 330)
                let blurImageView: UIImageView = UIImageView(frame: CGRectMake(0, 0, width, 330))
                blurImageView.contentMode = .ScaleAspectFill
                blurImageView.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin]
                blurImageView.layer.masksToBounds = true
                blurImageView.clipsToBounds = true
                blurImageView.image = UIImage(named: "BackgroundGradientInverse")
                self.view.addSubview(blurImageView)
                // blurImageView.addSubview(visualEffectView)
                self.view.sendSubviewToBack(blurImageView)
            }
            
            // Title
            self.navigationController?.view.backgroundColor = UIColor.clearColor()
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
            self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
            self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
            self.navigationController?.navigationBar.barStyle = .BlackTranslucent
            let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: width, height: 65))
            navBar.translucent = true
            navBar.tintColor = UIColor.whiteColor()
            navBar.backgroundColor = UIColor.clearColor()
            navBar.shadowImage = UIImage()
            navBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
            navBar.titleTextAttributes = [
                NSForegroundColorAttributeName : UIColor.whiteColor(),
                NSFontAttributeName : UIFont(name: "Avenir-Book", size: 18)!
            ]
            self.view.addSubview(navBar)
            let navItem = UINavigationItem(title: "@"+detailUser.username)
            navItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
            navBar.setItems([navItem], animated: true)

            // Button
            let payButton = AYVibrantButton(frame: CGRect(x: 10, y: 265, width: (width/2)-20, height: 50.0), style: AYVibrantButtonStyleFill)
            payButton.vibrancyEffect = UIVibrancyEffect(forBlurEffect:UIBlurEffect(style: .Dark))
            payButton.text = "Pay " + detailUser.first_name
            payButton.font = UIFont(name: "Avenir-Book", size: 14)
            payButton.addTarget(self, action: #selector(SearchDetailViewController.payMerchantModal(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            view.addSubview(payButton)
            
            // Button
            let subscribeButton = AYVibrantButton(frame: CGRect(x: width*0.5+10, y: 265, width: (width/2)-20, height: 50.0), style: AYVibrantButtonStyleInvert)
            subscribeButton.vibrancyEffect = UIVibrancyEffect(forBlurEffect:UIBlurEffect(style: .Dark))
            subscribeButton.text = "View Plans"
            subscribeButton.font = UIFont(name: "Avenir-Book", size: 14)
            subscribeButton.addTarget(self, action: nil, forControlEvents: UIControlEvents.TouchUpInside)
            view.addSubview(subscribeButton)
            
            let navigationBar = UINavigationBar(frame: CGRectMake(0, 0, self.view.frame.size.width, 65)) // Offset by 20 pixels vertically to take the status bar into account
            navigationBar.backgroundColor = UIColor.clearColor()
            navigationBar.tintColor = UIColor.whiteColor()
            navigationBar.delegate = self
            // Create a navigation item with a title
            let navigationItem = UINavigationItem()
            // Create left and right button for navigation item
            let leftButton = UIBarButtonItem(image: UIImage(named: "ic_close_light"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SearchDetailViewController.returnToMenu(_:)))
            let font = UIFont(name: "Avenir-Book", size: 14)
            leftButton.setTitleTextAttributes([NSFontAttributeName: font!, NSForegroundColorAttributeName:UIColor.mediumBlue()], forState: UIControlState.Normal)
            // Create two buttons for the navigation item
            navigationItem.leftBarButtonItem = leftButton
            let rightButton = UIBarButtonItem(image: UIImage(named: "ic_paper_plane_light_flat")?.alpha(0.5), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SearchDetailViewController.showMessageModal(_:)))
            rightButton.setTitleTextAttributes([NSFontAttributeName: font!, NSForegroundColorAttributeName:UIColor.mediumBlue()], forState: UIControlState.Normal)
            // Create two buttons for the navigation item
            navigationItem.rightBarButtonItem = rightButton
            // Assign the navigation item to the navigation bar
            navigationBar.items = [navigationItem]
            // Make the navigation bar a subview of the current view controller
            self.view.addSubview(navigationBar)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func returnToMenu(sender: AnyObject) {
        self.view.window!.rootViewController!.dismissViewControllerAnimated(true, completion: { _ in })
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
        
        mailComposerVC.setToRecipients([(detailUser?.email)!])
        mailComposerVC.setSubject("Message from Argent User")
        mailComposerVC.setMessageBody("Hello!", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func showMessageModal(sender: AnyObject) {
        let actionController = ArgentActionController()
        actionController.headerData = "Contact Method"
        actionController.addAction(Action("Email", style: .Default, handler: { action in
            Timeout(0.2) {
                self.sendEmailButtonTapped(self)
            }
        }))
        actionController.addAction(Action("SMS", style: .Default, handler: { action in
            Timeout(0.2) {
                self.sendSMSButtonTapped(self)
            }
        }))
        actionController.addSection(ActionSection())
        actionController.addAction(Action("Cancel", style: .Destructive, handler: { action in
        }))
        self.presentViewController(actionController, animated: true, completion: { _ in
        })
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
        composeSMSVC.recipients = ([(detailUser?.email)!])
        composeSMSVC.body = "Hello from Argent!"
        
        return composeSMSVC
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController,
                                      didFinishWithResult result: MessageComposeResult) {
        // Check the result or perform other tasks.
        
        // Dismiss the mail compose view controller.
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: PAYMENT MODAL
    
    func payMerchantModal(sender: AnyObject) {
        let navigationController = self.storyboard!.instantiateViewControllerWithIdentifier("payMerchantFormSheetController") as! UINavigationController
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: navigationController)
        
        // Initialize and style the terms and conditions modal
        formSheetController.presentationController?.shouldApplyBackgroundBlurEffect = true
        formSheetController.presentationController?.contentViewSize = CGSizeMake(300, 300)
        formSheetController.presentationController?.shouldUseMotionEffect = true
        formSheetController.presentationController?.containerView?.backgroundColor = UIColor.blackColor()
        formSheetController.presentationController?.containerView?.sizeToFit()
        formSheetController.presentationController?.blurEffectStyle = UIBlurEffectStyle.Light
        formSheetController.presentationController?.shouldDismissOnBackgroundViewTap = true
        formSheetController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyle.SlideFromBottom
        formSheetController.contentViewCornerRadius = 10
        formSheetController.allowDismissByPanningPresentedView = true
        formSheetController.interactivePanGestureDismissalDirection = .All;
        
        // Blur will be applied to all MZFormSheetPresentationControllers by default
        MZFormSheetPresentationController.appearance().shouldApplyBackgroundBlurEffect = true
        
        let presentedViewController = navigationController.viewControllers.first as! PayMerchantViewController

        // keep passing along user data to modal
        presentedViewController.detailUser = detailUser
        presentedViewController.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
        presentedViewController.navigationItem.leftItemsSupplementBackButton = true
        
        // Be sure to update current module on storyboard
        self.presentViewController(formSheetController, animated: true, completion: nil)
    }

}

