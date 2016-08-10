//
//  ProfileViewController.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 3/7/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import Armchair

class ProfileViewController: UIViewController {
    
    override func viewDidAppear(animated: Bool) {
        self.childViewControllerForStatusBarStyle()?.setNeedsStatusBarAppearanceUpdate()
        self.navigationController!.navigationBar.backgroundColor = UIColor.clearColor()
        self.navigationController!.navigationBar.barTintColor = UIColor.clearColor()
        UIStatusBarStyle.LightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let app: UIApplication = UIApplication.sharedApplication()
        let statusBarHeight: CGFloat = app.statusBarFrame.size.height
        let statusBarView: UIView = UIView(frame: CGRectMake(0, -statusBarHeight, UIScreen.mainScreen().bounds.size.width, statusBarHeight))
        statusBarView.backgroundColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.addSubview(statusBarView)
        
        // THIS SETS STATUS BAR COLOR
        self.navigationController?.navigationBar.barStyle = .Default
        // Transparent navigation bar
        self.navigationController?.navigationBar.barTintColor = UIColor.lightBlue()
        self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.lightBlue(),
            NSFontAttributeName : UIFont.systemFontOfSize(14, weight: UIFontWeightLight)
        ]
        
        loadUserAccount()
    }
    
    private func loadUserAccount() {
        User.getProfile({ (user, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "Could not load profile \(error?.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        })
    }
    
    //Changing Status Bar
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    //Changing Status Bar
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goToEdit(sender: AnyObject) {
        self.performSegueWithIdentifier("editProfileView", sender: sender)
    }
    
}