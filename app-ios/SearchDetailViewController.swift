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
import TransitionTreasury
import TransitionAnimation

class SearchDetailViewController: UIViewController, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UINavigationBarDelegate, NavgationTransitionable {
    
    var tr_pushTransition: TRNavgationTransitionDelegate?

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
    
    deinit {
        print("deinit.")
    }
    
    func configureView() {

        if let transitionAnimation = tr_pushTransition?.transition as? IBanTangTransitionAnimation {
            print(transitionAnimation.keyView)
            print(transitionAnimation.keyViewCopy)
        }
        
        let screen = UIScreen.mainScreen().bounds
        let width = screen.size.width
        let height = screen.size.height
        
        let imageBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageBackground.backgroundColor = UIColor.offWhite()
        imageBackground.contentMode = .ScaleToFill
        self.view.addSubview(imageBackground)
        
        // adds a manual credit card entry textfield
        // self.view.addSubview(paymentTextField)
        
        if let detailUser = detailUser {
            if let usernameLabel = usernameLabel {
                usernameLabel.text = detailUser.username
            }
            if let emailLabel = emailLabel {
                emailLabel.text = detailUser.email
            }
            
            let cardView: UIImageView = UIImageView(frame: CGRectMake(35, 90, width-70, height*0.6))
            // Blurview
            let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
            visualEffectView.frame = CGRectMake(0, 0, width, 500)
            cardView.contentMode = .ScaleToFill
            cardView.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin]
            cardView.layer.masksToBounds = true
            cardView.clipsToBounds = true
            cardView.layer.cornerRadius = 10
            cardView.layer.shadowColor = UIColor.purpleColor().CGColor
            cardView.layer.shadowOffset = CGSizeMake(0, 1)
            cardView.layer.shadowOpacity = 1
            cardView.layer.shadowRadius = 1.0
            cardView.clipsToBounds = false
            self.view.addSubview(cardView)
            cardView.backgroundColor = UIColor.whiteColor()
            cardView.center = self.view.center
            let containerLayer: CALayer = CALayer()
            containerLayer.shadowColor = UIColor.lightBlue().CGColor
            containerLayer.shadowRadius = 10.0
            containerLayer.shadowOffset = CGSizeMake(0.0, 5.0)
            containerLayer.shadowOpacity = 0.2
            cardView.layer.masksToBounds = true
            containerLayer.addSublayer(cardView.layer)
            self.view.layer.addSublayer(containerLayer)
            
            let userImageView: UIImageView = UIImageView(frame: CGRectMake(width / 2, 0, 75, 75))
            userImageView.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin]
            userImageView.center = CGPointMake(self.view.bounds.size.width / 2, 205)
            userImageView.backgroundColor = UIColor.groupTableViewBackgroundColor()
            userImageView.layer.cornerRadius = userImageView.frame.size.height/2
            userImageView.layer.masksToBounds = true
            userImageView.clipsToBounds = true
            userImageView.layer.borderWidth = 3
            userImageView.layer.borderColor = UIColor(rgba: "#fffa").CGColor
            self.view.addSubview(userImageView)
            self.view.bringSubviewToFront(userImageView)
            
            // User image
            let pic = detailUser.picture
            if pic != "" {
                let img: UIImage = UIImage(data: NSData(contentsOfURL: NSURL(string: detailUser.picture)!)!)!
                userImageView.image = img
            } else {
                let img: UIImage = UIImage(named: "LogoRound")!
                userImageView.image = img

            }
            
            // Title
            self.navigationController?.view.backgroundColor = UIColor.clearColor()
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
            self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
            self.navigationController?.navigationBar.tintColor = UIColor.mediumBlue()
            self.navigationController?.navigationBar.barStyle = .BlackTranslucent
            let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: width, height: 65))
            navBar.translucent = true
            navBar.tintColor = UIColor.mediumBlue()
            navBar.backgroundColor = UIColor.clearColor()
            navBar.shadowImage = UIImage()
            navBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
            navBar.titleTextAttributes = [
                NSForegroundColorAttributeName : UIColor.mediumBlue(),
                NSFontAttributeName : UIFont(name: "Avenir-Book", size: 18)!
            ]
            self.view.addSubview(navBar)
            let navItem = UINavigationItem(title: "@"+detailUser.username)
            navItem.leftBarButtonItem?.tintColor = UIColor.mediumBlue()
            navBar.setItems([navItem], animated: true)
            
            // Button
            let viewPlansButton = UIButton(frame: CGRect(x: 50, y: cardView.layer.frame.height+10,  width: self.view.layer.frame.width-100, height: 50.0))
            viewPlansButton.setTitleColor(UIColor.mediumBlue().colorWithAlphaComponent(0.9), forState: .Normal)
            viewPlansButton.titleLabel?.font = UIFont(name: "Avenir-Light", size: 16)
            viewPlansButton.setTitle("View Plans", forState: .Normal)
            viewPlansButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
            viewPlansButton.addTarget(self, action: #selector(SearchDetailViewController.payMerchantModal(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            viewPlansButton.layer.cornerRadius = 10
            viewPlansButton.layer.borderColor = UIColor.mediumBlue().colorWithAlphaComponent(0.5).CGColor
            viewPlansButton.layer.borderWidth = 1
            viewPlansButton.addTarget(self, action: nil, forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(viewPlansButton)
            
            
            let payButton = UIButton(frame: CGRect(x: 50, y: cardView.layer.frame.height+70, width: self.view.layer.frame.width-100, height: 50.0))
            payButton.setTitleColor(UIColor.whiteColor().colorWithAlphaComponent(0.9), forState: .Normal)
            payButton.titleLabel?.font = UIFont(name: "Avenir-Light", size: 16)
            if detailUser.first_name != "" {
                payButton.setTitle("Pay " + detailUser.first_name, forState: .Normal)
            } else {
                payButton.setTitle("Pay User", forState: .Normal)
            }
            payButton.layer.cornerRadius = 10
            payButton.layer.borderColor = UIColor.mediumBlue().CGColor
            payButton.layer.borderWidth = 1
            payButton.backgroundColor = UIColor.mediumBlue()
            payButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
            payButton.addTarget(self, action: #selector(SearchDetailViewController.payMerchantModal(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(payButton)
            
            // Name textfield
            lbl.text = detailUser.first_name + " " + detailUser.last_name
            lbl.frame = CGRectMake(0, 220, width, 130)
            lbl.textAlignment = .Center
            lbl.textColor = UIColor.mediumBlue()
            lbl.font = UIFont(name: "Avenir-Light", size: 18)
            lbl.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin]
            self.view.addSubview(lbl)
            self.view.bringSubviewToFront(lbl)
            
            let navigationBar = UINavigationBar(frame: CGRectMake(0, 0, self.view.frame.size.width, 65)) // Offset by 20 pixels vertically to take the status bar into account
            navigationBar.backgroundColor = UIColor.clearColor()
            navigationBar.tintColor = UIColor.mediumBlue()
            navigationBar.delegate = self
            // Create a navigation item with a title
            let navigationItem = UINavigationItem()
            // Create left and right button for navigation item
            let font = UIFont(name: "Avenir-Book", size: 14)
            // Create two buttons for the navigation item
            let rightButton = UIBarButtonItem(image: UIImage(named: "ic_paper_plane_light_flat")?.alpha(0.7), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SearchDetailViewController.showMessageModal(_:)))
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
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
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
        let sendMailErrorAlert = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .Alert)
            sendMailErrorAlert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(sendMailErrorAlert, animated: true, completion: nil)
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

