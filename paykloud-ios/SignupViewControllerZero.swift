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
        // Clear NSUserDefaults
        let appDomain = NSBundle.mainBundle().bundleIdentifier!
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
        SVProgressHUD.dismiss()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        
        // Close button to return to auth view
        let closeButton = UIBarButtonItem(image: UIImage(named: "IconClose"), style: .Plain, target: self, action: "goToAuth")
        navigationItem.leftBarButtonItem = closeButton
        closeButton.tintColor = UIColor.grayColor()
        title = ""
        
        // Transparent navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        
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