//
//  SubscriptionsListDetailViewController.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 6/6/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import CWStatusBarNotification

class SubscriptionsListDetailViewController: UIViewController, UINavigationBarDelegate {
    
    let navigationBar = UINavigationBar()

    var subscriptionId:String?

    var subscriptionName:String?

    var subscriptionAmount:String?
    
    var subscriptionInterval:String?

    var subscriptionStatus:String?

    var subscriptionTitleLabel = UILabel()
    
    var subscriptionStatusLabel = UILabel()
    
    var subscriptionAmountLabel = UILabel()
    
    var subscriptionIntervalLabel = UILabel()

    var cancelSubscriptionButton = UIButton()

    var deleteSubscriptionButton = UIButton()
    
    var circleView = UIView()
    
    private let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutViews()
        setupNav()
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func layoutViews() {
        
        self.navigationController?.navigationBar.tintColor = UIColor.darkBlue()
        self.navigationController?.navigationBar.topItem!.backBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        let pinstripeImageView = UIImageView()
        pinstripeImageView.image = UIImage(named: "IconPinstripe")
        pinstripeImageView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 10)
        self.view.addSubview(pinstripeImageView)
        self.view.bringSubviewToFront(pinstripeImageView)
        
        subscriptionTitleLabel.frame = CGRect(x: 0, y: 40, width: screenWidth, height: 100)
        subscriptionTitleLabel.attributedText = adjustAttributedString(subscriptionName!.uppercaseString, spacing: 2, fontName: "MyriadPro-Regular", fontSize: 19, fontColor: UIColor.darkBlue(), lineSpacing: 0.0, alignment: .Center)
        subscriptionTitleLabel.font = UIFont(name: "MyriadPro-Regular", size: 24)
        subscriptionTitleLabel.textAlignment = .Center
        let _ = Timeout(0.3) {
            addSubviewWithBounce(self.subscriptionTitleLabel, parentView: self, duration: 0.3)
        }
        self.view.bringSubviewToFront(subscriptionTitleLabel)

        
        circleView.frame = CGRect(x: screenWidth/2-60, y: 140, width: 120, height: 120)
        circleView.backgroundColor = UIColor.brandGreen()
        circleView.layer.cornerRadius = circleView.frame.height/2
        circleView.layer.borderColor = UIColor.brandGreen().darkerColor().CGColor
        circleView.layer.borderWidth = 1
        let _ = Timeout(0.5) {
            addSubviewWithBounce(self.circleView, parentView: self, duration: 0.6)
        }
        self.view.bringSubviewToFront(circleView)
        
        subscriptionAmountLabel.frame = CGRect(x: 40, y: 115, width: screenWidth-80, height: 150)
        subscriptionAmountLabel.attributedText = formatCurrency(subscriptionAmount!, fontName: "MyriadPro-Regular", superSize: 16, fontSize: 24, offsetSymbol: 5, offsetCents: 5)
        subscriptionAmountLabel.textAlignment = .Center
        subscriptionAmountLabel.textColor = UIColor.whiteColor()
        let _ = Timeout(0.5) {
            addSubviewWithBounce(self.subscriptionAmountLabel, parentView: self, duration: 0.3)
        }
        self.view.bringSubviewToFront(subscriptionAmountLabel)
        if Int(subscriptionAmount!)! > 1000000 {
            subscriptionAmountLabel.attributedText = formatCurrency(subscriptionAmount!, fontName: "MyriadPro-Regular", superSize: 12, fontSize: 18, offsetSymbol: 3, offsetCents: 3)
        }
        
        subscriptionIntervalLabel.frame = CGRect(x: 40, y: 170, width: screenWidth-80, height: 100)
        subscriptionIntervalLabel.attributedText = adjustAttributedString("PER " + subscriptionInterval!.uppercaseString, spacing: 2, fontName: "MyriadPro-Regular", fontSize: 12, fontColor: UIColor.whiteColor(), lineSpacing: 0.0, alignment: .Center)
        let _ = Timeout(0.5) {
            addSubviewWithBounce(self.subscriptionIntervalLabel, parentView: self, duration: 0.3)
        }
        
        subscriptionStatusLabel.frame = CGRect(x: 40, y: 215, width: screenWidth-80, height: 200)
        subscriptionStatusLabel.numberOfLines = 8
        subscriptionStatusLabel.font = UIFont(name: "MyriadPro-Regular", size: 12)
        subscriptionStatusLabel.textAlignment = .Center
        subscriptionStatusLabel.textColor = UIColor.darkBlue().colorWithAlphaComponent(0.7)
        let _ = Timeout(0.7) {
            addSubviewWithBounce(self.subscriptionStatusLabel, parentView: self, duration: 0.3)
        }
        self.view.bringSubviewToFront(self.subscriptionStatusLabel)
        subscriptionStatusLabel.text = "Subscription status " + subscriptionStatus!
        
        // TO CANCEL SUBSCRIPTION
        cancelSubscriptionButton.setBackgroundColor(UIColor.pastelBlue(), forState: .Normal)
        cancelSubscriptionButton.setBackgroundColor(UIColor.pastelBlue().darkerColor(), forState: .Highlighted)
        cancelSubscriptionButton.frame = CGRect(x: 15, y: screenHeight-125, width: screenWidth-30, height: 50)
        cancelSubscriptionButton.setAttributedTitle(adjustAttributedStringNoLineSpacing("CANCEL SUBSCRIPTION", spacing: 1, fontName: "MyriadPro-Regular", fontSize: 14, fontColor: UIColor.whiteColor()), forState: .Normal)
        cancelSubscriptionButton.addTarget(self, action: #selector(self.cancelSubscription(_:)), forControlEvents: .TouchUpInside)
        cancelSubscriptionButton.layer.cornerRadius = 3
        cancelSubscriptionButton.layer.masksToBounds = true
        self.view.addSubview(cancelSubscriptionButton)
        
        if subscriptionStatus == "canceled" {
            cancelSubscriptionButton.setAttributedTitle(adjustAttributedStringNoLineSpacing("REOPEN SUBSCRIPTION", spacing: 1, fontName: "MyriadPro-Regular", fontSize: 14, fontColor: UIColor.whiteColor()), forState: .Normal)
            cancelSubscriptionButton.removeTarget(self, action: #selector(self.cancelSubscription(_:)), forControlEvents: .TouchUpInside)
            cancelSubscriptionButton.addTarget(self, action: #selector(self.reopenSubscription(_:)), forControlEvents: .TouchUpInside)
        }
        
        // TO DELETE SUBSCRIPTION
        deleteSubscriptionButton.setBackgroundColor(UIColor.clearColor(), forState: .Normal)
        deleteSubscriptionButton.setBackgroundColor(UIColor.brandRed(), forState: .Highlighted)
        deleteSubscriptionButton.frame = CGRect(x: 15, y: screenHeight-65, width: screenWidth-30, height: 50)
        deleteSubscriptionButton.setAttributedTitle(adjustAttributedStringNoLineSpacing("DELETE SUBSCRIPTION", spacing: 1, fontName: "MyriadPro-Regular", fontSize: 14, fontColor: UIColor.brandRed()), forState: .Normal)
        deleteSubscriptionButton.setAttributedTitle(adjustAttributedStringNoLineSpacing("DELETE SUBSCRIPTION", spacing: 1, fontName: "MyriadPro-Regular", fontSize: 14, fontColor: UIColor.whiteColor()), forState: .Highlighted)
        deleteSubscriptionButton.layer.borderColor = UIColor.brandRed().CGColor
        deleteSubscriptionButton.layer.borderWidth = 1
        deleteSubscriptionButton.addTarget(self, action: #selector(self.deleteSubscription(_:)), forControlEvents: .TouchUpInside)
        deleteSubscriptionButton.layer.cornerRadius = 3
        deleteSubscriptionButton.layer.masksToBounds = true
        self.view.addSubview(deleteSubscriptionButton)
        
    }
    
    func alertControllerBackgroundTapped() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func reopenSubscription(sender: AnyObject) {
        // send request to cancel
        let alertController = UIAlertController(title: "Re-opening Subscription", message: "We do not currently support re-opening subscriptions.  However, you can find this account on our search page and re-subscribe.", preferredStyle: UIAlertControllerStyle.Alert)

        self.presentViewController(alertController, animated: true, completion: {
            alertController.view.superview?.userInteractionEnabled = true
            alertController.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
        })
    }
    
    func cancelSubscription(sender: AnyObject) {
        // send request to cancel
        let alertController = UIAlertController(title: "Confirm subscription cancellation", message: "You will have to pay a new charge if you decide to subscribe again.", preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Continue", style: .Default) { (action) in
            Subscription.cancelSubscription(self.subscriptionId!) { (bool, err) in
                if bool == true {
                    self.dismissViewControllerAnimated(true, completion: {
                        showGlobalNotification("Subscription Canceled! Pull down to refresh.", duration: 7.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.StatusBarNotification, color: UIColor.brandGreen())
                    })
                } else {
                    showGlobalNotification("Error canceling subscription", duration: 3.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.StatusBarNotification, color: UIColor.brandRed())
                }
            }
        }
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func deleteSubscription(sender: AnyObject) {
        // send request to delete, on completion reload table data!
        let alertController = UIAlertController(title: "Confirm subscription deletion", message: "Are you sure?  This action cannot be undone.", preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Continue", style: .Default) { (action) in
            Subscription.deleteSubscription(self.subscriptionId!) { (bool, err) in
                if bool == true {
                    self.dismissViewControllerAnimated(true, completion: {
                        showGlobalNotification("Subscription deleted! Pull down to refresh.", duration: 7.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.StatusBarNotification, color: UIColor.brandGreen())
                    })
                } else {
                    showGlobalNotification("Error deleting subscription", duration: 3.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.StatusBarNotification, color: UIColor.brandRed())
                }
            }
        }
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    private func setupNav() {
        // Offset by 20 pixels vertically to take the status bar into account
        navigationBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 60)
        navigationBar.backgroundColor = UIColor.clearColor()
        // this changes color of close button
        navigationBar.tintColor = UIColor.darkBlue()
        navigationBar.delegate = self
        
        // Create a navigation item with a title
        let navigationItem = UINavigationItem()
        
        // Create left and right button for navigation item
        let leftButton = UIBarButtonItem(image: UIImage(named: "IconCloseLight"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.returnToMenu(_:)))
        let font = UIFont(name: "MyriadPro-Regular", size: 14)
        leftButton.setTitleTextAttributes([NSFontAttributeName: font!, NSForegroundColorAttributeName:UIColor.mediumBlue()], forState: UIControlState.Normal)
        // Create two buttons for the navigation item
        navigationItem.leftBarButtonItem = leftButton
        
        // Assign the navigation item to the navigation bar
        navigationBar.titleTextAttributes = [NSFontAttributeName: font!, NSForegroundColorAttributeName:UIColor.darkBlue()]
        navigationBar.items = [navigationItem]
        
        // Make the navigation bar a subview of the current view controller
        self.view.addSubview(navigationBar)
    }
    
    func returnToMenu(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { }
    }
    
}