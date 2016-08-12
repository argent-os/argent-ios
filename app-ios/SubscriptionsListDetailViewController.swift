//
//  SubscriptionsListDetailViewController.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 6/6/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation

class SubscriptionsListDetailViewController: UIViewController, UINavigationBarDelegate {
    
    let navigationBar = UINavigationBar()

    var subscriptionName:String?
    
    var subscriptionAmount:String?
    
    var subscriptionInterval:String?

    var subscriptionStatus:String?

    var subscriptionTitleLabel = UILabel()
    
    var subscriptionStatusLabel = UILabel()
    
    var subscriptionAmountLabel = UILabel()
    
    var subscriptionIntervalLabel = UILabel()

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
        pinstripeImageView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 15)
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
        
        deleteSubscriptionButton.setBackgroundColor(UIColor.brandRed(), forState: .Normal)
        deleteSubscriptionButton.setBackgroundColor(UIColor.brandRed().darkerColor(), forState: .Highlighted)
        deleteSubscriptionButton.frame = CGRect(x: 15, y: screenHeight-65, width: screenWidth-30, height: 50)
        deleteSubscriptionButton.setAttributedTitle(adjustAttributedStringNoLineSpacing("DELETE SUBSCRIPTION", spacing: 1, fontName: "MyriadPro-Regular", fontSize: 14, fontColor: UIColor.whiteColor()), forState: .Normal)
        deleteSubscriptionButton.layer.cornerRadius = 3
        deleteSubscriptionButton.layer.masksToBounds = true
        self.view.addSubview(deleteSubscriptionButton)
        
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