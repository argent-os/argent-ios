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
        var screenWidth = screen.size.width
        var screenHeight = screen.size.height
        
        // Individual Section
        
        let backgroundIndividualImageView = UIView()
        backgroundIndividualImageView.backgroundColor = UIColor.offWhite()
        backgroundIndividualImageView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight/2)
        self.view.addSubview(backgroundIndividualImageView)
        
        let individualImageView = UIImageView()
        individualImageView.image = UIImage(named: "IconIndividual")
        individualImageView.frame = CGRect(x: backgroundIndividualImageView.frame.width/2-40, y: backgroundIndividualImageView.frame.height/2-40, width: 80, height: 80)
        backgroundIndividualImageView.addSubview(individualImageView)
        let gestureRecognizerIndividual = UITapGestureRecognizer(target: self, action: #selector(individualSegue(_:)))
        individualImageView.addGestureRecognizer(gestureRecognizerIndividual)
        individualImageView.userInteractionEnabled = true
        
        let individualTitle = UILabel()
        individualTitle.textColor = UIColor.slateBlue()
        individualTitle.textAlignment = .Center
        individualTitle.font = UIFont.systemFontOfSize(18)
        individualTitle.frame = CGRect(x: 0, y: backgroundIndividualImageView.frame.height/2+40, width: screenWidth, height: 40)
        individualTitle.text = "Individual"
        self.view.addSubview(individualTitle)
        
        let individualSubtitle = UILabel()
        individualSubtitle.textColor = UIColor.slateBlue().colorWithAlphaComponent(0.5)
        individualSubtitle.textAlignment = .Center
        individualSubtitle.font = UIFont.systemFontOfSize(12)
        individualSubtitle.frame = CGRect(x: 0, y: backgroundIndividualImageView.frame.height/2+70, width: screenWidth, height: 40)
        individualSubtitle.text = "Start sending and receiving payments"
        self.view.addSubview(individualSubtitle)

        
        //// Company Section
        
        
        let backgroundCompanyImageView = UIView()
        backgroundCompanyImageView.backgroundColor = UIColor.mediumBlue()
        backgroundCompanyImageView.frame = CGRect(x: 0, y: screenHeight/2, width: screenWidth, height: screenHeight/2)
        self.view.addSubview(backgroundCompanyImageView)
        
        let companyImageView = UIImageView()
        companyImageView.image = UIImage(named: "IconBusinessBuilding")
        companyImageView.center = backgroundCompanyImageView.center
        companyImageView.frame = CGRect(x: backgroundCompanyImageView.frame.width/2-40, y: backgroundCompanyImageView.frame.height/2-40, width: 80, height: 80)
        backgroundCompanyImageView.addSubview(companyImageView)
        let gestureRecognizerCompany = UITapGestureRecognizer(target: self, action: #selector(companySegue(_:)))
        companyImageView.addGestureRecognizer(gestureRecognizerCompany)
        companyImageView.userInteractionEnabled = true
        
        let companyTitle = UILabel()
        companyTitle.textColor = UIColor.whiteColor()
        companyTitle.textAlignment = .Center
        companyTitle.font = UIFont.systemFontOfSize(18)
        companyTitle.frame = CGRect(x: 0, y: backgroundCompanyImageView.frame.height/2+40, width: screenWidth, height: 40)
        companyTitle.text = "Company"
        backgroundCompanyImageView.addSubview(companyTitle)
        
        let companySubtitle = UILabel()
        companySubtitle.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        companySubtitle.textAlignment = .Center
        companySubtitle.font = UIFont.systemFontOfSize(12)
        companySubtitle.frame = CGRect(x: 0, y: backgroundCompanyImageView.frame.height/2+70, width: screenWidth, height: 40)
        companySubtitle.text = "Higher volume limits enabled"
        backgroundCompanyImageView.addSubview(companySubtitle)
        
        
        // Page title
        
        let pageTitle = UILabel()
        pageTitle.frame = CGRect(x: 0, y: 30, width: screenWidth, height: 40)
        pageTitle.textAlignment = .Center
        pageTitle.text = "Let's get started"
        pageTitle.textColor = UIColor.mediumBlue()
        pageTitle.font = UIFont.systemFontOfSize(18)
//        self.view.addSubview(pageTitle)
//        self.view.bringSubviewToFront(pageTitle)
        
        let pageSubtitle = UILabel()
        pageSubtitle.frame = CGRect(x: 0, y: 30, width: screenWidth, height: 40)
        pageSubtitle.textAlignment = .Center
        pageSubtitle.text = "Welcome, are you an individual or company?"
        pageSubtitle.textColor = UIColor.mediumBlue().colorWithAlphaComponent(0.5)
        pageSubtitle.font = UIFont.systemFontOfSize(14)
        self.view.addSubview(pageSubtitle)
        self.view.bringSubviewToFront(pageSubtitle)
        
        // Close button to return to auth view
        let backBtn: UIButton = UIButton(type: .Custom)
        let backBtnImage: UIImage = UIImage(named: "IconCloseColor")!
        let backBtnImagePressed: UIImage = UIImage(named: "IconClose")!
        backBtn.setBackgroundImage(backBtnImage, forState: .Normal)
        backBtn.setBackgroundImage(backBtnImagePressed, forState: .Highlighted)
        backBtn.addTarget(self, action: #selector(SignupViewControllerZero.goToAuth(_:)), forControlEvents: .TouchUpInside)
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
    
    func individualSegue(sender: AnyObject) {
        self.performSegueWithIdentifier("individualSegue", sender: sender)
    }
    
    func companySegue(sender: AnyObject) {
        self.performSegueWithIdentifier("companySegue", sender: sender)
    }
    
    // Return to auth view func
    func goToAuth(sender: AnyObject) {
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