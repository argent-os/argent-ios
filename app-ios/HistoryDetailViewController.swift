//
//  HistoryDetailViewController.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 5/14/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import UIKit
import Foundation

class HistoryDetailViewController: UIViewController, UINavigationBarDelegate {
    
    var amountLabel = UILabel()
    
    var dateLabel = UILabel()
    
    var detailHistory: History? {
        didSet {
            configureView()
        }
    }
    
    func configureView() {
        
        let screen = UIScreen.mainScreen().bounds
        let width = screen.size.width
        _ = screen.size.height
        
        // adds a manual credit card entry textfield
        // self.view.addSubview(paymentTextField)
        
        if let detailHistory = detailHistory {

            amountLabel.text = detailHistory.amount
            dateLabel.text = "test"
            
            // Email textfield
            amountLabel.frame = CGRectMake(0, 160, width, 110)
            amountLabel.textAlignment = .Center
            amountLabel.textColor = UIColor.darkGrayColor()
            amountLabel.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin]
            self.view.addSubview(amountLabel)
            
            // Email textfield
            dateLabel.frame = CGRectMake(0, 240, width, 110)
            dateLabel.textAlignment = .Center
            dateLabel.textColor = UIColor.darkGrayColor()
            dateLabel.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            self.view.addSubview(dateLabel)
            
            // Title
            self.navigationController?.view.backgroundColor = UIColor.slateBlue()
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
            self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
            self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
            self.navigationController?.navigationBar.barStyle = .BlackTranslucent
            let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: width, height: 65))
            navBar.translucent = true
            navBar.tintColor = UIColor.slateBlue()
            navBar.backgroundColor = UIColor.slateBlue()
            navBar.shadowImage = UIImage()
            navBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
            navBar.titleTextAttributes = [
                NSForegroundColorAttributeName : UIColor.whiteColor(),
                NSFontAttributeName : UIFont(name: "Avenir-Book", size: 18)!
            ]
            self.view.addSubview(navBar)
            let navItem = UINavigationItem(title: "")
            navItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
            navBar.setItems([navItem], animated: true)
            
            // Navigation Bar
            let navigationBar = UINavigationBar(frame: CGRectMake(0, 0, self.view.frame.size.width, 65)) // Offset by 20 pixels vertically to take the status bar into account
            navigationBar.backgroundColor = UIColor.slateBlue()
            navigationBar.tintColor = UIColor.slateBlue()
            navigationBar.delegate = self
            // Create a navigation item with a title
            let navigationItem = UINavigationItem()
            // Create left and right button for navigation item
            let leftButton = UIBarButtonItem(image: UIImage(named: "IconClose"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(HistoryDetailViewController.returnToMenu(_:)))
            let font = UIFont(name: "Avenir-Book", size: 14)
            leftButton.setTitleTextAttributes([NSFontAttributeName: font!, NSForegroundColorAttributeName:UIColor.mediumBlue()], forState: UIControlState.Normal)
            // Create two buttons for the navigation item
            navigationItem.leftBarButtonItem = leftButton
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
    
}

