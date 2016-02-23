//
//  SignupViewControllerZero.swift
//  paykloud-ios
//
//  Created by Sinan Ulkuatam on 2/19/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

class SignupViewControllerZero: UIViewController {
    
    // WHEN NAVIGATING TO A NAVIGATION CONTROLLER USE SEGUE SHOW NOT MODAL!
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidAppear(animated: Bool) {
        SVProgressHUD.dismiss()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        
        // Close button to return to login
        let closeButton = UIBarButtonItem(image: UIImage(named: "IconClose"), style: .Plain, target: self, action: "returnToLogin")
        navigationItem.leftBarButtonItem = closeButton
        closeButton.tintColor = UIColor.grayColor()
        title = ""
        
        // Transparent navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    // Return to login func
    func returnToLogin() {
        self.performSegueWithIdentifier("loginView", sender: self);
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