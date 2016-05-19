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

    weak var modalDelegate: ModalViewControllerDelegate?

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
            
            let chatBubble = UIImageView(image: UIImage(named: "IconChat"), highlightedImage: .None)
            chatBubble.alpha = 0.2
            chatBubble.frame = CGRect(x: width/2-70, y: 320, width: 50, height: 50)
            self.view.addSubview(chatBubble)
            self.view.bringSubviewToFront(chatBubble)
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(sendSMSButtonTapped(_:)))
            chatBubble.addGestureRecognizer(gestureRecognizer)
            chatBubble.userInteractionEnabled = true
            
            let emailIcon = UIImageView(image: UIImage(named: "IconEmail"), highlightedImage: .None)
            emailIcon.alpha = 0.2
            emailIcon.frame = CGRect(x: width/2+20, y: 320, width: 50, height: 50)
            self.view.addSubview(emailIcon)
            self.view.bringSubviewToFront(emailIcon)
            let gestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(sendEmailButtonTapped(_:)))
            emailIcon.addGestureRecognizer(gestureRecognizer2)
            emailIcon.userInteractionEnabled = true
            
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
            let viewPlansButton = UIButton(frame: CGRect(x: 50, y: cardView.layer.frame.height+20,  width: self.view.layer.frame.width-100, height: 50.0))
            viewPlansButton.setTitleColor(UIColor.mediumBlue().colorWithAlphaComponent(0.9), forState: .Normal)
            viewPlansButton.titleLabel?.font = UIFont(name: "Avenir-Light", size: 16)
            viewPlansButton.setTitle("View Plans", forState: .Normal)
            viewPlansButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
            viewPlansButton.addTarget(self, action: #selector(SearchDetailViewController.payMerchantModal(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            viewPlansButton.layer.cornerRadius = 10
            viewPlansButton.layer.borderColor = UIColor.mediumBlue().colorWithAlphaComponent(0.5).CGColor
            viewPlansButton.layer.borderWidth = 0
            viewPlansButton.addTarget(self, action: nil, forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(viewPlansButton)
            
            
            let payButton = UIButton(frame: CGRect(x: 50, y: cardView.layer.frame.height+70,  width: self.view.layer.frame.width-100, height: 50.0))
            payButton.setTitleColor(UIColor.whiteColor().colorWithAlphaComponent(1), forState: .Normal)
            payButton.titleLabel?.font = UIFont(name: "Avenir-Light", size: 16)
            if detailUser.first_name != "" {
                payButton.setTitle("Pay " + detailUser.first_name, forState: .Normal)
            } else {
                payButton.setTitle("Pay User", forState: .Normal)
            }
            payButton.layer.cornerRadius = 10
            payButton.layer.borderColor = UIColor.mediumBlue().CGColor
            payButton.layer.borderWidth = 0
            payButton.backgroundColor = UIColor.lightBlue()
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

        }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.view.addGestureRecognizer(gestureRecognizer)
        configureView()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
    override func viewDidDisappear(animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func returnToMenu(sender: AnyObject) {
        self.view.window!.rootViewController!.dismissViewControllerAnimated(true, completion: { _ in })
    }
    
    
    // MARK: Email Composition
    
    @IBAction func sendEmailButtonTapped(sender: UIGestureRecognizer) {
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
    
    // MARK: SMS Composition
    
    @IBAction func sendSMSButtonTapped(sender: UIGestureRecognizer) {
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

