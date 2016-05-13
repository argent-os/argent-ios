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

    private var customersLabel:UILabel = UILabel()
    
    private var plansLabel:UILabel = UILabel()
    
    private var customersArray = [Customer]()
    
    private var plansArray = [Plan]()
        
    override func viewDidAppear(animated: Bool) {
        self.navigationController!.navigationBar.backgroundColor = UIColor.clearColor()
        self.navigationController!.navigationBar.barTintColor = UIColor.clearColor()
        UIStatusBarStyle.Default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.darkGrayColor()]
        self.view.backgroundColor = UIColor.whiteColor()
        
        // Style user avatar
//        avatarImageView.image = UIImage(named: "avatar")
//        avatarImageView.layer.cornerRadius = 1.0
//        avatarImageView.layer.borderColor = UIColor.blackColor().CGColor
//        avatarImageView.clipsToBounds = true
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 15, width: screenWidth, height: 50))
        navBar.barTintColor = UIColor.clearColor()
        navBar.translucent = true
        navBar.tintColor = UIColor.whiteColor()
        navBar.backgroundColor = UIColor.clearColor()
        navBar.shadowImage = UIImage()
        navBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "Avenir-Black", size: 18)!
        ]
        self.view.addSubview(navBar)
        self.view.bringSubviewToFront(navBar)
        
        
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
            navBar.setItems([navItem], animated: false)
            
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
            
            let customersLabel = UILabel(frame: CGRectMake(25, 110, 75, 70))
            customersLabel.textAlignment = NSTextAlignment.Center
            customersLabel.font = UIFont(name: "ArialRoundedMTBold", size: 14)
            customersLabel.numberOfLines = 0
            customersLabel.textColor = UIColor(rgba: "#fff5")
            customersLabel.text = "0\ncustomers"
            self.view.addSubview(customersLabel)
            self.view.bringSubviewToFront(customersLabel)
            
            let plansLabel = UILabel(frame: CGRectMake(screenWidth-100, 110, 75, 70))
            plansLabel.textAlignment = NSTextAlignment.Center
            plansLabel.font = UIFont(name: "ArialRoundedMTBold", size: 14)
            plansLabel.numberOfLines = 0
            plansLabel.text = "0\nplans"
            plansLabel.textColor = UIColor(rgba: "#fff5")
            plansLabel.text = "0\nplans"
            self.view.addSubview(plansLabel)
            self.view.bringSubviewToFront(plansLabel)
            
            self.loadCustomerList { (customers: [Customer]?, NSError) in
                if(customers!.count < 2 && customers!.count > 0) {
                    customersLabel.text = String(customers!.count) + "\ncustomers"
                } else {
                    customersLabel.text = String(customers!.count) + "\ncustomers"
                }
            }
            
            self.loadPlanList { (plans: [Plan]?, NSError) in
                if(plans!.count < 2 && plans!.count > 0) {
                    plansLabel.text = String(plans!.count) + "\nplan"
                } else {
                    plansLabel.text = String(plans!.count) + "\nplans"
                }
            }
            
        })
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.darkGrayColor(),
            NSFontAttributeName : UIFont(name: "Avenir-Light", size: 18.0)!
        ]
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