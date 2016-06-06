//
//  CustomersListDetailViewController.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 6/6/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation

class CustomersListDetailViewController: UIViewController, UINavigationBarDelegate {
    
    let navigationBar = UINavigationBar()
    
    var customerEmail:String?
    
    var customerPlans:String?
    
    var customerEmailTitleLabel = UILabel()
    
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
        
        customerEmailTitleLabel.frame = CGRect(x: 40, y: 20, width: screenWidth-80, height: 100)
        customerEmailTitleLabel.text = customerEmail
        customerEmailTitleLabel.font = UIFont(name: "DINAlternate-Bold", size: 24)
        customerEmailTitleLabel.textAlignment = .Center
        customerEmailTitleLabel.textColor = UIColor.lightBlue()
        addSubviewWithBounce(customerEmailTitleLabel, parentView: self, duration: 0.3)
        
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