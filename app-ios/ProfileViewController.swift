//
//  ProfileViewController.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 3/7/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import JGProgressHUD
import FXBlurView

class ProfileViewController: UIViewController {
    
    private var customersArray = [Customer]()
    
    private var plansArray = [Plan]()
    
    private var customersCountLabel = UILabel()

    private var customersTitleLabel = UILabel()

    private var plansCountLabel = UILabel()

    private var plansTitleLabel = UILabel()
    
    private let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 15, width: UIScreen.mainScreen().bounds.size.width, height: 50))

    override func viewDidAppear(animated: Bool) {
        self.navigationController!.navigationBar.backgroundColor = UIColor.clearColor()
        self.navigationController!.navigationBar.barTintColor = UIColor.clearColor()
        UIStatusBarStyle.Default
    }
    
    lazy var gesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(ProfileViewController.swipeTransition(_:)))
        return gesture
    }()

    func swipeTransition(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .Began :
            if sender.translationInView(sender.view).x >= 0 {
                tabBarController?.tr_selected(3, gesture: sender)
            }
        default : break
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.darkGrayColor()]

        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        
        view.addGestureRecognizer(gesture)

        self.view.backgroundColor = UIColor.slateBlue()

        self.view.addSubview(navBar)
        self.view.sendSubviewToBack(navBar)
        let navItem = UINavigationItem(title: "")
        navBar.setItems([navItem], animated: true)
        // Transparent navigation bar
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "Avenir-Light", size: 14.0)!
        ]
        
        User.getProfile({ (item, error) in
            if error != nil
            {
                let alert = UIAlertController(title: "Error", message: "Could not load profile \(error?.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            let navItem = UINavigationItem(title: "@"+(item?.username)!)
            // TODO: do a check for first name, and business name
            let f_name = item?.first_name
            let l_name = item?.last_name
            if f_name != nil && l_name != nil {
                self.navigationItem.title = f_name! + " " + l_name!
            }
            self.navBar.setItems([navItem], animated: false)
            
            let settingsIcon = UIImageView(frame: CGRectMake(0, 0, 32, 32))
            settingsIcon.image = UIImage(named: "IconSettingsWhite")
            settingsIcon.contentMode = .ScaleAspectFit
            settingsIcon.alpha = 0.5
            settingsIcon.center = CGPointMake(self.view.frame.size.width / 2, 130)
            settingsIcon.userInteractionEnabled = true
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.goToEdit(_:)))
            tap.numberOfTapsRequired = 1
            settingsIcon.addGestureRecognizer(tap)
            // self.view.addSubview(settingsIcon)
            // self.view.bringSubviewToFront(settingsIcon)
            
            self.customersCountLabel.frame = CGRectMake(30, 20, 75, 70)
            self.customersCountLabel.textAlignment = NSTextAlignment.Center
            self.customersCountLabel.font = UIFont(name: "Avenir-Book", size: 18)
            self.customersCountLabel.numberOfLines = 0
            self.customersCountLabel.textColor = UIColor(rgba: "#fffa")
            self.customersCountLabel.text = "0"
//            self.view.addSubview(self.customersCountLabel)
            
            self.customersTitleLabel.frame = CGRectMake(30, 40, 75, 70)
            self.customersTitleLabel.textAlignment = NSTextAlignment.Center
            self.customersTitleLabel.font = UIFont(name: "Avenir-Light", size: 10)
            self.customersTitleLabel.numberOfLines = 0
            self.customersTitleLabel.textColor = UIColor(rgba: "#fffc")
            self.customersTitleLabel.text = "Customers"
//            self.view.addSubview(self.customersTitleLabel)
            
            self.plansCountLabel.frame = CGRectMake(screenWidth-110, 20, 75, 70)
            self.plansCountLabel.textAlignment = NSTextAlignment.Center
            self.plansCountLabel.font = UIFont(name: "Avenir-Book", size: 18)
            self.plansCountLabel.numberOfLines = 0
            self.plansCountLabel.text = "0"
            self.plansCountLabel.textColor = UIColor(rgba: "#fffa")
//            self.view.addSubview(self.plansCountLabel)
            
            self.plansTitleLabel.frame = CGRectMake(screenWidth-110, 40, 75, 70)
            self.plansTitleLabel.textAlignment = NSTextAlignment.Center
            self.plansTitleLabel.font = UIFont(name: "Avenir-Light", size: 10)
            self.plansTitleLabel.numberOfLines = 0
            self.plansTitleLabel.textColor = UIColor(rgba: "#fffc")
            self.plansTitleLabel.text = "Plans"
//            self.view.addSubview(self.plansTitleLabel)
            
            self.loadCustomerList { (customers: [Customer]?, NSError) in
                if(customers!.count < 2 && customers!.count > 0) {
                    self.customersCountLabel.text = String(customers!.count)
                } else {
                    self.customersCountLabel.text = String(customers!.count)
                }
            }
            
            self.loadPlanList { (plans: [Plan]?, NSError) in
                if(plans!.count < 2 && plans!.count > 0) {
                    self.plansCountLabel.text = String(plans!.count)
                } else {
                    self.plansCountLabel.text = String(plans!.count)
                }
            }
            
        })
    }
    
    private func loadCustomerList(completionHandler: ([Customer]?, NSError?) -> ()) {
        Customer.getCustomerList({ (customers, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "Could not load customers \(error?.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            self.customersArray = customers!
            completionHandler(customers!, error)
        })
    }
    
    private func loadPlanList(completionHandler: ([Plan]?, NSError?) -> ()) {
        Plan.getPlanList({ (plans, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "Could not load plans \(error?.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            self.plansArray = plans!
            completionHandler(plans!, error)
        })
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goToEdit(sender: AnyObject) {
        self.performSegueWithIdentifier("editProfileView", sender: sender)
    }
    
}