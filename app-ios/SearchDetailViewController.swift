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

class SearchDetailViewController: UIViewController, UINavigationBarDelegate {
    
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
            cardView.frame = CGRectMake(35, 135, screenWidth-70, screenHeight*0.6)
            cardView.contentMode = .ScaleToFill
            cardView.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin]
            cardView.layer.masksToBounds = true
            cardView.clipsToBounds = true
            cardView.layer.cornerRadius = 10
            cardView.clipsToBounds = false
            addSubviewWithShadow(UIColor.lightBlue(), radius: 10.0, offsetX: 0.0, offsetY: 5.0, opacity: 0.2, parentView: self, childView: cardView)
            
            let userImageView: UIImageView = UIImageView()
            userImageView.frame = CGRectMake(screenWidth / 2, 0, 50, 50)
            userImageView.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin]
            userImageView.center = CGPointMake(self.view.bounds.size.width / 2, 245)
            userImageView.backgroundColor = UIColor.clearColor()
            userImageView.layer.cornerRadius = userImageView.frame.size.height/2
            userImageView.layer.masksToBounds = true
            userImageView.clipsToBounds = true
            //            userImageView.layer.cornerRadius = userImageView.frame.size.height/2
            userImageView.layer.cornerRadius = 10
            userImageView.layer.borderWidth = 0
            userImageView.layer.borderColor = UIColor(rgba: "#fffa").CGColor
            addSubviewWithFade(userImageView, parentView: self, duration: 0.8)
            self.view.bringSubviewToFront(userImageView)
            
            // Name textfield
            if detailUser.business_name != "" {
                lbl.text = detailUser.business_name
            } else if detailUser.first_name != "" && detailUser.last_name != "" {
                lbl.text = detailUser.first_name + " " + detailUser.last_name
            } else {
                lbl.text = detailUser.username
            }
            lbl.frame = CGRectMake(0, 230, screenWidth, 130)
            lbl.textAlignment = .Center
            lbl.textColor = UIColor.lightBlue()
            lbl.font = UIFont(name: "MyriadPro-Regular", size: 18)!
            lbl.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin]
            addSubviewWithFade(lbl, parentView: self, duration: 0.8)
            self.view.bringSubviewToFront(lbl)
            
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
            
            // Send message button
            let sendMessageButton = UIButton()
            sendMessageButton.frame = CGRect(x: 35, y: cardView.layer.frame.height-40,  width: self.view.layer.frame.width-70, height: 60.0)
            sendMessageButton.setTitleColor(UIColor.skyBlue(), forState: .Normal)
            sendMessageButton.setTitleColor(UIColor.skyBlue().lighterColor(), forState: .Highlighted)
            sendMessageButton.setBackgroundColor(UIColor.whiteColor(), forState: .Normal)
            sendMessageButton.setBackgroundColor(UIColor.offWhite().lighterColor(), forState: .Highlighted)
            sendMessageButton.titleLabel?.font = UIFont(name: "MyriadPro-Regular", size: 16)!
            sendMessageButton.setTitle("Send Message", forState: .Normal)
            sendMessageButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
            sendMessageButton.addTarget(self, action: #selector(SearchDetailViewController.showMessageView(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            sendMessageButton.addTarget(self, action: #selector(SearchDetailViewController.showMessageView(_:)), forControlEvents: UIControlEvents.TouchUpOutside)
            //sendMessageButton.layer.cornerRadius = 10
            sendMessageButton.layer.borderColor = UIColor.skyBlue().CGColor
            sendMessageButton.layer.borderWidth = 0
            sendMessageButton.addTarget(self, action: nil, forControlEvents: UIControlEvents.TouchUpInside)
            addSubviewWithBounce(sendMessageButton, parentView: self, duration: 0.8)
            
            // View plans Button
            let viewPlansButton = UIButton()
            viewPlansButton.frame = CGRect(x: 35, y: cardView.layer.frame.height+20,  width: self.view.layer.frame.width-70, height: 60.0)
            viewPlansButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            viewPlansButton.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
            viewPlansButton.setBackgroundColor(UIColor.skyBlue(), forState: .Normal)
            viewPlansButton.setBackgroundColor(UIColor.skyBlue().lighterColor(), forState: .Highlighted)
            viewPlansButton.titleLabel?.font = UIFont(name: "MyriadPro-Regular", size: 16)!
            viewPlansButton.setTitle("View Plans", forState: .Normal)
            viewPlansButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
            viewPlansButton.addTarget(self, action: #selector(SearchDetailViewController.viewPlansModal(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            viewPlansButton.addTarget(self, action: #selector(SearchDetailViewController.viewPlansModal(_:)), forControlEvents: UIControlEvents.TouchUpOutside)
            //viewPlansButton.layer.cornerRadius = 10
            viewPlansButton.layer.borderColor = UIColor.skyBlue().CGColor
            viewPlansButton.layer.borderWidth = 0
            viewPlansButton.addTarget(self, action: nil, forControlEvents: UIControlEvents.TouchUpInside)
            addSubviewWithBounce(viewPlansButton, parentView: self, duration: 0.8)
            
            
            let payButton = UIButton()
            payButton.frame = CGRect(x: 35, y: cardView.layer.frame.height+75,  width: self.view.layer.frame.width-70, height: 60.0)
            payButton.setTitleColor(UIColor.whiteColor().colorWithAlphaComponent(1), forState: .Normal)
            payButton.titleLabel?.font = UIFont(name: "MyriadPro-Regular", size: 16)!
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
            payButton.setBackgroundColor(UIColor.mediumBlue().lighterColor(), forState: .Highlighted)
            payButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            payButton.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
            payButton.layer.borderColor = UIColor.mediumBlue().CGColor
            payButton.layer.borderWidth = 1.5
            payButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
            payButton.addTarget(self, action: #selector(SearchDetailViewController.payMerchantModal(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            addSubviewWithBounce(payButton, parentView: self, duration: 0.8)
            let rectShape = CAShapeLayer()
            rectShape.bounds = payButton.frame
            rectShape.position = payButton.center
            rectShape.path = UIBezierPath(roundedRect: payButton.bounds, byRoundingCorners: [.BottomLeft, .BottomRight], cornerRadii: CGSize(width: 10, height: 10)).CGPath
            
            payButton.layer.backgroundColor = UIColor.mediumBlue().CGColor
            //Here I'm masking the textView's layer with rectShape layer
            payButton.layer.mask = rectShape
            
            if(screenHeight < 500) {
                cardView.frame = CGRectMake(35, 90, screenWidth-70, screenHeight*0.6)
                userImageView.frame = CGRect(x: screenWidth/2-25, y: 80, width: 50, height: 50)
                userImageView.layer.cornerRadius = 5
                sendMessageButton.frame = CGRect(x: 35, y: cardView.layer.frame.height-60,  width: self.view.layer.frame.width-70, height: 50.0)
                lbl.frame = CGRectMake(0, 90, screenWidth, 130)
                viewPlansButton.frame = CGRect(x: 35, y: cardView.layer.frame.height-10,  width: self.view.layer.frame.width-70, height: 50.0)
                payButton.frame = CGRect(x: 35, y: cardView.layer.frame.height+40,  width: self.view.layer.frame.width-70, height: 50.0)
                
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
    
    func viewPlansModal(sender: AnyObject) {
        
        let screen = UIScreen.mainScreen().bounds
        //let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        let navigationController = self.storyboard!.instantiateViewControllerWithIdentifier("viewPlansFormSheetController") as! UINavigationController
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: navigationController)
        
        // Initialize and style the terms and conditions modal
        formSheetController.presentationController?.shouldApplyBackgroundBlurEffect = true
        formSheetController.presentationController?.contentViewSize = CGSizeMake(280, screenHeight*0.6)
        formSheetController.presentationController?.shouldUseMotionEffect = true
        formSheetController.presentationController?.containerView?.backgroundColor = UIColor.blackColor()
        formSheetController.presentationController?.containerView?.sizeToFit()
        formSheetController.presentationController?.shouldCenterVertically = true
        formSheetController.presentationController?.shouldCenterHorizontally = true
        formSheetController.presentationController?.blurEffectStyle = UIBlurEffectStyle.Dark
        formSheetController.presentationController?.shouldDismissOnBackgroundViewTap = true
        formSheetController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyle.SlideFromBottom
        formSheetController.contentViewCornerRadius = 10
        formSheetController.allowDismissByPanningPresentedView = true
        formSheetController.interactivePanGestureDismissalDirection = .All;
        
        // Blur will be applied to all MZFormSheetPresentationControllers by default
        MZFormSheetPresentationController.appearance().shouldApplyBackgroundBlurEffect = true
        
        let presentedViewController = navigationController.viewControllers.first as! MerchantPlansViewController
        
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
        formSheetController.presentationController?.shouldApplyBackgroundBlurEffect = true
        formSheetController.presentationController?.contentViewSize = CGSizeMake(280, 280)
        formSheetController.presentationController?.shouldUseMotionEffect = true
        formSheetController.presentationController?.containerView?.backgroundColor = UIColor.blackColor()
        formSheetController.presentationController?.containerView?.sizeToFit()
        formSheetController.presentationController?.blurEffectStyle = UIBlurEffectStyle.Dark
        formSheetController.presentationController?.shouldDismissOnBackgroundViewTap = true
        formSheetController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyle.SlideFromBottom
        formSheetController.presentationController?.movementActionWhenKeyboardAppears = MZFormSheetActionWhenKeyboardAppears.CenterVertically
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

