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
    
    var planStatementDescriptorLabel = UILabel()
    
    var subscriptionAmountLabel = UILabel()
    
    var subscriptionIntervalLabel = UILabel()
    
    var circleView = UIView()
    
    private let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutViews()
        setupNav()
    }
    
    func layoutViews() {
        
        self.navigationController?.navigationBar.tintColor = UIColor.lightBlue()
        self.navigationController?.navigationBar.topItem!.backBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        subscriptionTitleLabel.frame = CGRect(x: 40, y: 20, width: screenWidth-80, height: 100)
        subscriptionTitleLabel.text = subscriptionName
        subscriptionTitleLabel.font = UIFont(name: "DINAlternate-Bold", size: 24)
        subscriptionTitleLabel.textAlignment = .Center
        subscriptionTitleLabel.textColor = UIColor.lightBlue()
        addSubviewWithBounce(subscriptionTitleLabel, parentView: self, duration: 0.3)
        
        circleView.frame = CGRect(x: screenWidth/2-60, y: 130, width: 120, height: 120)
        circleView.backgroundColor = UIColor.clearColor()
        circleView.layer.cornerRadius = circleView.frame.height/2
        circleView.layer.borderColor = UIColor.lightBlue().colorWithAlphaComponent(0.5).CGColor
        circleView.layer.borderWidth = 1
        addSubviewWithBounce(circleView, parentView: self, duration: 0.8)
        
        subscriptionAmountLabel.frame = CGRect(x: 40, y: 105, width: screenWidth-80, height: 150)
        subscriptionAmountLabel.attributedText = formatCurrency(subscriptionAmount!, fontName: "DINAlternate-Bold", superSize: 16, fontSize: 24, offsetSymbol: 5, offsetCents: 5)
        subscriptionAmountLabel.textAlignment = .Center
        subscriptionAmountLabel.textColor = UIColor.lightBlue().colorWithAlphaComponent(0.5)
        addSubviewWithBounce(subscriptionAmountLabel, parentView: self, duration: 0.3)
        if Int(subscriptionAmount!)! > 1000000 {
            subscriptionAmountLabel.attributedText = formatCurrency(subscriptionAmount!, fontName: "DINAlternate-Bold", superSize: 12, fontSize: 18, offsetSymbol: 3, offsetCents: 3)
        }
        
        subscriptionIntervalLabel.frame = CGRect(x: 40, y: 160, width: screenWidth-80, height: 100)
        subscriptionIntervalLabel.text = "per " + subscriptionInterval!
        subscriptionIntervalLabel.font = UIFont(name: "DINAlternate-Bold", size: 12)
        subscriptionIntervalLabel.textAlignment = .Center
        subscriptionIntervalLabel.textColor = UIColor.lightBlue().colorWithAlphaComponent(0.5)
        addSubviewWithBounce(subscriptionIntervalLabel, parentView: self, duration: 0.3)
        
        planStatementDescriptorLabel.frame = CGRect(x: 40, y: 210, width: screenWidth-80, height: 200)
        planStatementDescriptorLabel.numberOfLines = 8
        planStatementDescriptorLabel.font = UIFont(name: "DINAlternate-Bold", size: 12)
        planStatementDescriptorLabel.textAlignment = .Center
        planStatementDescriptorLabel.textColor = UIColor.lightBlue().colorWithAlphaComponent(0.7)
        addSubviewWithBounce(planStatementDescriptorLabel, parentView: self, duration: 0.3)
        planStatementDescriptorLabel.text = "Subscription status " + subscriptionStatus!
        
    }
    
    private func setupNav() {
        // Offset by 20 pixels vertically to take the status bar into account
        navigationBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 60)
        navigationBar.backgroundColor = UIColor.clearColor()
        navigationBar.tintColor = UIColor.lightBlue()
        navigationBar.delegate = self
        
        // Create a navigation item with a title
        let navigationItem = UINavigationItem()
        
        // Create left and right button for navigation item
        let leftButton = UIBarButtonItem(image: UIImage(named: "IconClose"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ChargeViewController.returnToMenu(_:)))
        let font = UIFont(name: "DINAlternate-Bold", size: 14)
        leftButton.setTitleTextAttributes([NSFontAttributeName: font!, NSForegroundColorAttributeName:UIColor.mediumBlue()], forState: UIControlState.Normal)
        // Create two buttons for the navigation item
        navigationItem.leftBarButtonItem = leftButton
        
        // Assign the navigation item to the navigation bar
        navigationBar.titleTextAttributes = [NSFontAttributeName: font!, NSForegroundColorAttributeName:UIColor.lightBlue()]
        navigationBar.items = [navigationItem]
        
        // Make the navigation bar a subview of the current view controller
        self.view.addSubview(navigationBar)
    }
    
    func returnToMenu(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
}