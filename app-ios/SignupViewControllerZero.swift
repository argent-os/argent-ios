//
//  SignupViewControllerZero.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 2/19/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit

class SignupViewControllerZero: UIViewController {
    
    // WHEN NAVIGATING TO A NAVIGATION CONTROLLER USE SEGUE SHOW NOT MODAL!
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidAppear(animated: Bool) {
        // Clear NSUserDefaults
        let appDomain = NSBundle.mainBundle().bundleIdentifier!
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
    }
    
    //Changing Status Bar
    override internal func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Globally set toolbar
        UIToolbar.appearance().barTintColor = UIColor.whiteColor()
        UIToolbar.appearance().backgroundColor = UIColor.whiteColor()
        UIToolbar.appearance().layer.borderColor = UIColor.mediumBlue().CGColor
        UIToolbar.appearance().layer.borderWidth = 1
        
        if let font = UIFont(name: "Avenir-Light", size: 15) {
            UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: font,NSForegroundColorAttributeName:UIColor.mediumBlue()], forState: UIControlState.Normal)
        }
        
        UITextField.appearance().keyboardAppearance = .Light

        let screen = UIScreen.mainScreen().bounds
        _ = screen.size.width
        _ = screen.size.height
        
        // Close button to return to auth view
        let backBtn: UIButton = UIButton(type: .Custom)
        let backBtnImage: UIImage = UIImage(named: "IconCloseColor")!
        let backBtnImagePressed: UIImage = UIImage(named: "IconClose")!
        backBtn.setBackgroundImage(backBtnImage, forState: .Normal)
        backBtn.setBackgroundImage(backBtnImagePressed, forState: .Highlighted)
        backBtn.addTarget(self, action: #selector(SignupViewControllerZero.goToAuth), forControlEvents: .TouchUpInside)
        backBtn.frame = CGRectMake(0, 0, 33, 33)
        let backButtonView: UIView = UIView(frame: CGRectMake(0, 0, 33, 33))
        backButtonView.bounds = CGRectOffset(backButtonView.bounds, 7, -7)
        backButtonView.addSubview(backBtn)
        let backButton: UIBarButtonItem = UIBarButtonItem(customView: backButtonView)
        self.navigationItem.leftBarButtonItem = backButton

        // Transparent navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // Return to auth view func
    func goToAuth() {
        // Normally identifiers are started with capital letters, exception being authViewController, make sure UIStoryboard name is Auth, not Main
        let viewController:AuthViewController = UIStoryboard(name: "Auth", bundle: nil).instantiateViewControllerWithIdentifier("authViewController") as! AuthViewController
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    // VALIDATION
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "individualSegue") {
            NSUserDefaults.standardUserDefaults().setValue("individual", forKey: "userLegalEntityType")
            NSUserDefaults.standardUserDefaults().synchronize();
        } else if(segue.identifier == "companySegue") {
            NSUserDefaults.standardUserDefaults().setValue("company", forKey: "userLegalEntityType")
            NSUserDefaults.standardUserDefaults().synchronize();
        }
    }
}