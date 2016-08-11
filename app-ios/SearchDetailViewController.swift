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
import Alamofire
import SwiftyJSON
import XLActionController
import MZFormSheetPresentationController
import TransitionTreasury
import TransitionAnimation
import EasyTipView
import Crashlytics

class SearchDetailViewController: UIViewController, UINavigationBarDelegate {
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var stacks: UIStackView!
    
    private var tipView = EasyTipView(text: "This is an " + APP_NAME + " user's profile page, from here you can make one-time or recurring payments", preferences: EasyTipView.globalPreferences)

    let tutorialButton = UIButton()

    let paymentTextField = STPPaymentCardTextField()
    
    var saveButton: UIButton! = nil;
    
    let companyTitleLabel:UILabel = UILabel()

    var detailUser: User? {
        didSet {
            configureView()
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }
    
    deinit {
        print("deinit.")
    }
    
    func configureView() {
        
        self.view.backgroundColor = UIColor.globalBackground()
        UIStatusBarStyle.Default
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        let imageBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        imageBackground.backgroundColor = UIColor.offWhite()
        imageBackground.contentMode = .ScaleToFill
        addSubviewWithFade(imageBackground, parentView: self, duration: 0.8)
        
        // adds a manual credit card entry textfield
        // addSubviewWithFade(paymentTextField)
        
        if let detailUser = detailUser {
            if let usernameLabel = usernameLabel {
                usernameLabel.text = detailUser.username
            }
            if let emailLabel = emailLabel {
                emailLabel.text = detailUser.email
            }
            
            let cardView: UIView = UIView()
            cardView.backgroundColor = UIColor.whiteColor()
            cardView.frame = CGRectMake(35, 135, screenWidth-70, 270)
            cardView.contentMode = .ScaleToFill
            cardView.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin]
            cardView.layer.masksToBounds = true
            cardView.clipsToBounds = true
            cardView.layer.cornerRadius = 10
            cardView.clipsToBounds = false
            addSubviewWithShadow(UIColor.lightBlue(), radius: 10.0, offsetX: 0.0, offsetY: 5.0, opacity: 0.2, parentView: self, childView: cardView)
            
            let userImageView: UIImageView = UIImageView()
            userImageView.frame = CGRectMake(55, 150, 50, 50)
            userImageView.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin]
//            userImageView.center = CGPointMake(self.view.bounds.size.width / 2, 245)
            userImageView.backgroundColor = UIColor.clearColor()
            userImageView.layer.cornerRadius = userImageView.frame.size.height/2
            userImageView.layer.masksToBounds = true
            userImageView.clipsToBounds = true
            //            userImageView.layer.cornerRadius = userImageView.frame.size.height/2
            userImageView.layer.cornerRadius = 10
            userImageView.layer.borderWidth = 0
            userImageView.layer.borderColor = UIColor.whiteColor().colorWithAlphaComponent(0.5).CGColor
            addSubviewWithFade(userImageView, parentView: self, duration: 0.8)
            self.view.bringSubviewToFront(userImageView)
            
            // Name textfield
            if detailUser.business_name != "" {
                companyTitleLabel.text = detailUser.business_name
            } else if detailUser.first_name != "" && detailUser.last_name != "" {
                companyTitleLabel.text = detailUser.first_name + " " + detailUser.last_name
            } else {
                companyTitleLabel.text = detailUser.username
            }
            companyTitleLabel.frame = CGRectMake(115, 100, 200, 130)
            companyTitleLabel.textAlignment = .Left
            companyTitleLabel.textColor = UIColor.lightBlue()
            companyTitleLabel.font = UIFont(name: "MyriadPro-Regular", size: 18)!
            companyTitleLabel.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin]
            addSubviewWithFade(companyTitleLabel, parentView: self, duration: 0.8)
            self.view.bringSubviewToFront(companyTitleLabel)
            
            // Send message button
            let sendMessageButton = UIButton()
            sendMessageButton.frame = CGRect(x: 115, y: 165, width: 200, height: 40.0)
            sendMessageButton.setTitleColor(UIColor.oceanBlue(), forState: .Normal)
            sendMessageButton.setTitleColor(UIColor.oceanBlue().lighterColor(), forState: .Highlighted)
            sendMessageButton.setBackgroundColor(UIColor.clearColor(), forState: .Normal)
            sendMessageButton.setBackgroundColor(UIColor.clearColor().lighterColor(), forState: .Highlighted)
            sendMessageButton.titleLabel?.font = UIFont(name: "MyriadPro-Regular", size: 14)!
            sendMessageButton.setTitle("Send Message", forState: .Normal)
            sendMessageButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
            sendMessageButton.addTarget(self, action: #selector(SearchDetailViewController.showMessageView(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            //sendMessageButton.layer.cornerRadius = 10
            sendMessageButton.layer.borderColor = UIColor.oceanBlue().CGColor
            sendMessageButton.layer.borderWidth = 0
            sendMessageButton.addTarget(self, action: nil, forControlEvents: UIControlEvents.TouchUpInside)
            addSubviewWithFade(sendMessageButton, parentView: self, duration: 0.8)
            
            // Share button
            let shareButton = UIButton()
            shareButton.frame = CGRect(x: cardView.frame.width-5, y: 150, width: 20, height: 28)
            shareButton.setTitleColor(UIColor.skyBlue(), forState: .Normal)
            shareButton.setTitleColor(UIColor.skyBlue().lighterColor(), forState: .Highlighted)
            shareButton.setBackgroundColor(UIColor.clearColor(), forState: .Normal)
            shareButton.setBackgroundColor(UIColor.clearColor().lighterColor(), forState: .Highlighted)
            shareButton.setBackgroundImage(UIImage(named: "IconShare"), forState: .Normal)
            shareButton.setBackgroundImage(UIImage(named: "IconShare")?.alpha(0.5), forState: .Highlighted)
            shareButton.contentMode = .ScaleAspectFit
            shareButton.titleLabel?.font = UIFont(name: "MyriadPro-Regular", size: 14)!
            shareButton.setTitle("", forState: .Normal)
            shareButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
            shareButton.addTarget(self, action: #selector(self.shareButtonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            //shareButton.layer.cornerRadius = 10
            shareButton.addTarget(self, action: nil, forControlEvents: UIControlEvents.TouchUpInside)
            addSubviewWithFade(shareButton, parentView: self, duration: 0.8)
            
            tutorialButton.frame = CGRect(x: self.view.frame.width/2-10, y: 480, width: 20, height: 20)
            tutorialButton.setTitleColor(UIColor.skyBlue(), forState: .Normal)
            tutorialButton.setTitleColor(UIColor.skyBlue().lighterColor(), forState: .Highlighted)
            tutorialButton.setBackgroundColor(UIColor.clearColor(), forState: .Normal)
            tutorialButton.setBackgroundColor(UIColor.clearColor().lighterColor(), forState: .Highlighted)
            tutorialButton.setBackgroundImage(UIImage(named: "ic_question"), forState: .Normal)
            tutorialButton.setBackgroundImage(UIImage(named: "ic_question")?.alpha(0.5), forState: .Highlighted)
            tutorialButton.contentMode = .ScaleAspectFit
            tutorialButton.titleLabel?.font = UIFont(name: "MyriadPro-Regular", size: 14)!
            tutorialButton.setTitle("", forState: .Normal)
            tutorialButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
            tutorialButton.addTarget(self, action: #selector(self.tutorialButtonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            tutorialButton.addTarget(self, action: #selector(self.tutorialButtonClicked(_:)), forControlEvents: UIControlEvents.TouchUpOutside)
            //tutorialButton.layer.cornerRadius = 10
            tutorialButton.addTarget(self, action: nil, forControlEvents: UIControlEvents.TouchUpInside)
            addSubviewWithFade(tutorialButton, parentView: self, duration: 0.8)
            
            // User image
            let pic = detailUser.picture
            if pic != "" {
                let img: UIImage = UIImage(data: NSData(contentsOfURL: NSURL(string: detailUser.picture)!)!)!
                userImageView.image = img
            } else {
                let img: UIImage = UIImage(named: "IconAnonymous")!
                userImageView.image = img
            }
            
            // Title
            self.navigationController?.navigationBar.tintColor = UIColor.lightBlue()
            self.navigationController?.navigationBar.topItem!.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
            //self.navigationController?.navigationBar.topItem!.backBarButtonItem?.tintColor = UIColor.lightBlue()
            let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 65))
            navBar.translucent = true
            navBar.tintColor = UIColor.slateBlue()
            navBar.backgroundColor = UIColor.clearColor()
            navBar.shadowImage = UIImage()
            navBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
            navBar.titleTextAttributes = [
                NSForegroundColorAttributeName : UIColor.lightBlue(),
                NSFontAttributeName : UIFont(name: "MyriadPro-Regular", size: 18)!
            ]
            addSubviewWithFade(navBar, parentView: self, duration: 0.8)
            let navItem = UINavigationItem(title: "@"+detailUser.username)
            navItem.leftBarButtonItem?.tintColor = UIColor.mediumBlue()
            navBar.setItems([navItem], animated: true)
            
            // Enable ACH Button
            let enableACHButton = UIButton()
            enableACHButton.frame = CGRect(x: 35, y: cardView.layer.frame.height-40,  width: self.view.layer.frame.width-70, height: 60.0)
            enableACHButton.setTitleColor(UIColor.oceanBlue(), forState: .Normal)
            enableACHButton.setTitleColor(UIColor.oceanBlue().lighterColor(), forState: .Highlighted)
            enableACHButton.setBackgroundColor(UIColor.clearColor(), forState: .Normal)
            enableACHButton.setBackgroundColor(UIColor.whiteColor().lighterColor(), forState: .Highlighted)
            enableACHButton.titleLabel?.font = UIFont(name: "MyriadPro-Regular", size: 14)!
            enableACHButton.setTitle("Enable ACH Transfers", forState: .Normal)
            enableACHButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
            enableACHButton.addTarget(self, action: #selector(SearchDetailViewController.showACHModal(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            //enableACHButton.layer.cornerRadius = 10
            enableACHButton.layer.borderColor = UIColor.oceanBlue().CGColor
            enableACHButton.layer.borderWidth = 0
            enableACHButton.addTarget(self, action: nil, forControlEvents: UIControlEvents.TouchUpInside)
//            self.view.addSubview(enableACHButton)
            
            // View plans Button
            let viewPlansButton = UIButton()
            viewPlansButton.frame = CGRect(x: 35, y: cardView.layer.frame.height+19,  width: self.view.layer.frame.width-70, height: 60.0)
            viewPlansButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            viewPlansButton.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
            viewPlansButton.setBackgroundColor(UIColor.oceanBlue(), forState: .Normal)
            viewPlansButton.setBackgroundColor(UIColor.oceanBlue().lighterColor(), forState: .Highlighted)
            viewPlansButton.titleLabel?.font = UIFont(name: "MyriadPro-Regular", size: 14)!
            viewPlansButton.setTitle("View Plans", forState: .Normal)
            viewPlansButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
            viewPlansButton.addTarget(self, action: #selector(SearchDetailViewController.viewPlansModal(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            //viewPlansButton.layer.cornerRadius = 10
            viewPlansButton.layer.borderColor = UIColor.oceanBlue().CGColor
            viewPlansButton.layer.borderWidth = 0
            viewPlansButton.addTarget(self, action: nil, forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(viewPlansButton)
            
            
            let payButton = UIButton()
            payButton.frame = CGRect(x: 35, y: cardView.layer.frame.height+75,  width: self.view.layer.frame.width-70, height: 60.0)
            payButton.setTitleColor(UIColor.whiteColor().colorWithAlphaComponent(1), forState: .Normal)
            payButton.titleLabel?.font = UIFont(name: "MyriadPro-Regular", size: 14)!
            if detailUser.business_name != "" {
                payButton.setTitle("Pay " + detailUser.business_name, forState: .Normal)
            } else if detailUser.first_name != "" {
                payButton.setTitle("Pay " + detailUser.first_name, forState: .Normal)
            } else {
                payButton.setTitle("Pay User", forState: .Normal)
            }
            //payButton.layer.cornerRadius = 10
            payButton.layer.borderWidth = 0
            payButton.layer.masksToBounds = true
            payButton.setBackgroundColor(UIColor.clearColor(), forState: .Normal)
            payButton.setBackgroundColor(UIColor.seaBlue().lighterColor(), forState: .Highlighted)
            payButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            payButton.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
            payButton.layer.borderColor = UIColor.seaBlue().CGColor
            payButton.layer.borderWidth = 0
            payButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
            payButton.addTarget(self, action: #selector(SearchDetailViewController.payMerchantModal(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(payButton)
            let rectShape = CAShapeLayer()
            rectShape.bounds = payButton.frame
            rectShape.position = payButton.center
            rectShape.path = UIBezierPath(roundedRect: payButton.bounds, byRoundingCorners: [.BottomLeft, .BottomRight], cornerRadii: CGSize(width: 10, height: 10)).CGPath
            
            payButton.layer.backgroundColor = UIColor.seaBlue().CGColor
            //Here I'm masking the textView's layer with rectShape layer
            payButton.layer.mask = rectShape
            
            if(screenHeight < 500) {
                cardView.frame = CGRectMake(35, 90, screenWidth-70, screenHeight*0.6)
                userImageView.frame = CGRect(x: 55, y: 110, width: 50, height: 50)
                userImageView.layer.cornerRadius = 5
                sendMessageButton.frame = CGRect(x: 55, y: 170,  width: self.view.layer.frame.width-70, height: 50.0)
                companyTitleLabel.frame = CGRectMake(55, 110, screenWidth, 130)
                companyTitleLabel.autoresizingMask = [.None, .None]
                shareButton.frame = CGRect(x: cardView.frame.width-5, y: 110, width: 20, height: 28)
                viewPlansButton.frame = CGRect(x: 35, y: cardView.layer.frame.height-10,  width: self.view.layer.frame.width-70, height: 50.0)
                payButton.frame = CGRect(x: 35, y: cardView.layer.frame.height+40,  width: self.view.layer.frame.width-70, height: 50.0)
                tutorialButton.frame = CGRect(x: self.view.frame.width/2-10, y: 400, width: 20, height: 20)
                let rectShape = CAShapeLayer()
                rectShape.bounds = payButton.frame
                rectShape.position = payButton.center
                rectShape.path = UIBezierPath(roundedRect: payButton.bounds, byRoundingCorners: [.BottomLeft, .BottomRight], cornerRadii: CGSize(width: 10, height: 10)).CGPath
                
                payButton.layer.backgroundColor = UIColor.mediumBlue().CGColor
                //Here I'm masking the textView's layer with rectShape layer
                payButton.layer.mask = rectShape
            }
        }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func showMessageView(sender: AnyObject) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SearchMessageViewController") as! SearchMessageViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        vc.username = detailUser?.username
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: VIEW PLANS MODAL
    
    func shouldUseContentViewFrameForPresentationController(presentationController: MZFormSheetPresentationController) -> Bool {
        return true
    }
    
    func contentViewFrameForPresentationController(presentationController: MZFormSheetPresentationController, currentFrame: CGRect) -> CGRect {
        var currentFrame = currentFrame
        currentFrame.size.height = 20
        currentFrame.origin.y = 50
        return currentFrame
    }
    
    func viewPlansModal(sender: AnyObject) {
        
        let screen = UIScreen.mainScreen().bounds
        //let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        let navigationController = self.storyboard!.instantiateViewControllerWithIdentifier("viewPlansFormSheetController") as! UINavigationController
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: navigationController)
        
        // Initialize and style the view plans modal
        formSheetController.presentationController?.contentViewSize = CGSizeMake(310, screenHeight*0.75)
        formSheetController.presentationController?.shouldUseMotionEffect = true
        formSheetController.presentationController?.containerView?.backgroundColor = UIColor.pastelDarkBlue().colorWithAlphaComponent(0.5)
        formSheetController.presentationController?.containerView?.sizeToFit()
        formSheetController.presentationController?.shouldCenterVertically = true
        formSheetController.presentationController?.shouldCenterHorizontally = true
        formSheetController.presentationController?.shouldApplyBackgroundBlurEffect = true
        formSheetController.presentationController?.blurEffectStyle = UIBlurEffectStyle.Dark
        formSheetController.presentationController?.shouldDismissOnBackgroundViewTap = true
        formSheetController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyle.SlideFromBottom
        formSheetController.contentViewCornerRadius = 10
        formSheetController.allowDismissByPanningPresentedView = true
        formSheetController.interactivePanGestureDismissalDirection = .All;
        
        let presentedViewController = navigationController.viewControllers.first as! MerchantPlansViewController
        
//        formSheetController.shouldUseContentViewFrameForPresentationController(MZFormSheetPresentationController())
//        formSheetController.contentViewFrameForPresentationController(MZFormSheetPresentationController(), currentFrame: CGRect(x: 0,y: 0,width: 100,height: 100))
        
        // keep passing along user data to modal
        presentedViewController.detailUser = detailUser
        presentedViewController.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
        presentedViewController.navigationItem.leftItemsSupplementBackButton = true
        
        // Be sure to update current module on storyboard
        self.presentViewController(formSheetController, animated: true, completion: nil)
    }
    
    // MARK: PAYMENT MODAL
    
    func payMerchantModal(sender: AnyObject) {
        let navigationController = self.storyboard!.instantiateViewControllerWithIdentifier("payMerchantFormSheetController") as! UINavigationController
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: navigationController)
        
        // Initialize and style the pay merchant modal
        formSheetController.presentationController?.contentViewSize = CGSizeMake(280, 280)
        formSheetController.presentationController?.shouldUseMotionEffect = true
        formSheetController.presentationController?.containerView?.backgroundColor = UIColor.pastelDarkBlue().colorWithAlphaComponent(0.75)
        formSheetController.presentationController?.containerView?.sizeToFit()
        formSheetController.presentationController?.shouldApplyBackgroundBlurEffect = true
        formSheetController.presentationController?.blurEffectStyle = UIBlurEffectStyle.Dark
        formSheetController.presentationController?.shouldDismissOnBackgroundViewTap = true
        formSheetController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyle.SlideFromBottom
        formSheetController.presentationController?.movementActionWhenKeyboardAppears = MZFormSheetActionWhenKeyboardAppears.AlwaysAboveKeyboard
        formSheetController.contentViewCornerRadius = 10
        formSheetController.allowDismissByPanningPresentedView = true
        formSheetController.interactivePanGestureDismissalDirection = .All;
        
        let presentedViewController = navigationController.viewControllers.first as! PayMerchantViewController

        // keep passing along user data to modal
        presentedViewController.detailUser = detailUser
        presentedViewController.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
        presentedViewController.navigationItem.leftItemsSupplementBackButton = true
        
        // Be sure to update current module on storyboard
        self.presentViewController(formSheetController, animated: true, completion: nil)
    }

}

extension SearchDetailViewController {
    func shareButtonClicked(sender: UIButton) {
        let textToShare = "This is my user profile on the " + APP_NAME + " app, and my username is @" + (detailUser?.username)!
        
        if let myWebsite = NSURL(string: APP_URL) {
            let objectsToShare = [textToShare, myWebsite]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.popoverPresentationController?.sourceView = sender
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
    }
}


extension SearchDetailViewController {
    func tutorialButtonClicked(sender: UIButton) {
        tipView.show(forView: self.tutorialButton, withinSuperview: self.view)
        
        Answers.logCustomEventWithName("Search detail profile tutorial presented",
                                       customAttributes: [:])
    }
}

extension SearchDetailViewController {
    func showACHAgreementModal(sender: UIButton) {

    }
}

extension SearchDetailViewController {
    // MARK: ACH modal
    
    func showACHModal(sender: AnyObject) {
        let navigationController = self.storyboard!.instantiateViewControllerWithIdentifier("bankListModalNavigationController") as! UINavigationController
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: navigationController)
        
        print("showing ach modal")
        // Initialize and style the terms and conditions modal
        formSheetController.presentationController?.contentViewSize = CGSizeMake(280, 400)
        formSheetController.presentationController?.shouldUseMotionEffect = true
        formSheetController.presentationController?.containerView?.backgroundColor = UIColor.pastelDarkBlue().colorWithAlphaComponent(0.5)
        formSheetController.presentationController?.containerView?.sizeToFit()
        formSheetController.presentationController?.shouldApplyBackgroundBlurEffect = true
        formSheetController.presentationController?.blurEffectStyle = UIBlurEffectStyle.Dark
        formSheetController.presentationController?.shouldDismissOnBackgroundViewTap = true
        formSheetController.presentationController?.shouldCenterVertically = true
        formSheetController.presentationController?.shouldCenterHorizontally = true
        formSheetController.presentationController?.movementActionWhenKeyboardAppears = MZFormSheetActionWhenKeyboardAppears.CenterVertically
        formSheetController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyle.SlideFromBottom
        formSheetController.contentViewCornerRadius = 10
        formSheetController.allowDismissByPanningPresentedView = true
        formSheetController.interactivePanGestureDismissalDirection = .All;
        
        // Blur will be applied to all MZFormSheetPresentationControllers by default
        MZFormSheetPresentationController.appearance().shouldApplyBackgroundBlurEffect = true
        
        let presentedViewController = navigationController.viewControllers.first as! BankListModalViewController
        
        // keep passing along user data to modal
        presentedViewController.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
        presentedViewController.navigationItem.leftItemsSupplementBackButton = true
        
        // send detail user information for delegated charge
        presentedViewController.detailUser = detailUser
        
//        var str = ""
//        str.removeAtIndex(str.characters.indices.first!) // remove first letter
        let amount = Float(123.00) //(str as NSString).floatValue
        presentedViewController.detailAmount = amount
        presentedViewController.paymentType = "once"
        presentedViewController.planId = ""
        // send an empty plan id as this is a onetime payment
        
        // Be sure to update current module on storyboard
        self.presentViewController(formSheetController, animated: true, completion: nil)
    }
}
