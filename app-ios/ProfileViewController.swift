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

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!

    private var customersCountLabel:UILabel = UILabel()
    
    private var plansCountLabel:UILabel = UILabel()
    
    private var customersArray = [Customer]()
    
    private var plansArray = [Plan]()
    
    private let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 15, width: UIScreen.mainScreen().bounds.size.width, height: 50))

    override func viewDidAppear(animated: Bool) {
        self.navigationController!.navigationBar.backgroundColor = UIColor.clearColor()
        self.navigationController!.navigationBar.barTintColor = UIColor.clearColor()
        UIStatusBarStyle.Default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.darkGrayColor()]
        
        // Style user avatar
//        avatarImageView.image = UIImage(named: "avatar")
//        avatarImageView.layer.cornerRadius = 1.0
//        avatarImageView.layer.borderColor = UIColor.blackColor().CGColor
//        avatarImageView.clipsToBounds = true
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        
        navBar.translucent = true
        navBar.tintColor = UIColor.whiteColor()
        navBar.shadowImage = UIImage()
        navBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "Avenir-Light", size: 18)!
        ]
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
            NSFontAttributeName : UIFont(name: "Avenir-Light", size: 12.0)!
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
            
            let customersCountLabel = UILabel(frame: CGRectMake(30, 20, 75, 70))
            customersCountLabel.textAlignment = NSTextAlignment.Center
            customersCountLabel.font = UIFont(name: "Avenir-Book", size: 18)
            customersCountLabel.numberOfLines = 0
            customersCountLabel.textColor = UIColor(rgba: "#fffa")
            customersCountLabel.text = "0"
            self.view.addSubview(customersCountLabel)
            self.view.bringSubviewToFront(customersCountLabel)
            
            let customersTitleLabel = UILabel(frame: CGRectMake(30, 40, 75, 70))
            customersTitleLabel.textAlignment = NSTextAlignment.Center
            customersTitleLabel.font = UIFont(name: "Avenir-Light", size: 10)
            customersTitleLabel.numberOfLines = 0
            customersTitleLabel.textColor = UIColor(rgba: "#fffc")
            customersTitleLabel.text = "Customers"
            self.view.addSubview(customersTitleLabel)
            self.view.bringSubviewToFront(customersTitleLabel)
            
            let plansCountLabel = UILabel(frame: CGRectMake(screenWidth-110, 20, 75, 70))
            plansCountLabel.textAlignment = NSTextAlignment.Center
            plansCountLabel.font = UIFont(name: "Avenir-Book", size: 18)
            plansCountLabel.numberOfLines = 0
            plansCountLabel.text = "0"
            plansCountLabel.textColor = UIColor(rgba: "#fffa")
            self.view.addSubview(plansCountLabel)
            self.view.bringSubviewToFront(plansCountLabel)
            
            let plansTitleLabel = UILabel(frame: CGRectMake(screenWidth-110, 40, 75, 70))
            plansTitleLabel.textAlignment = NSTextAlignment.Center
            plansTitleLabel.font = UIFont(name: "Avenir-Light", size: 10)
            plansTitleLabel.numberOfLines = 0
            plansTitleLabel.textColor = UIColor(rgba: "#fffc")
            plansTitleLabel.text = "Plans"
            self.view.addSubview(plansTitleLabel)
            self.view.bringSubviewToFront(plansTitleLabel)
            
            self.loadCustomerList { (customers: [Customer]?, NSError) in
                if(customers!.count < 2 && customers!.count > 0) {
                    customersCountLabel.text = String(customers!.count)
                } else {
                    customersCountLabel.text = String(customers!.count)
                }
            }
            
            self.loadPlanList { (plans: [Plan]?, NSError) in
                if(plans!.count < 2 && plans!.count > 0) {
                    plansCountLabel.text = String(plans!.count)
                } else {
                    plansCountLabel.text = String(plans!.count)
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