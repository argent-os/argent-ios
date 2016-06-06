//
//  SignupViewControllerZero.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 2/19/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import M13Checkbox

class SignupViewControllerZero: UIViewController {
    
    // WHEN NAVIGATING TO A NAVIGATION CONTROLLER USE SEGUE SHOW NOT MODAL!
    @IBOutlet weak var continueButton: UIButton!
    
    let backgroundIndividualImageView = UIView()
    
    let individualImageView = UIImageView()
    
    let individualTitle = UILabel()

    let individualSubtitle = UILabel()

    let individualCheckbox = M13Checkbox()

    let backgroundCompanyImageView = UIView()

    let companyImageView = UIImageView()

    let companyCheckbox = M13Checkbox()

    let companyTitle = UILabel()

    let companySubtitle = UILabel()

    let pageTitle = UILabel()

    let pageSubtitle = UILabel()

    let backBtn: UIButton = UIButton(type: .Custom)

    override func viewDidAppear(animated: Bool) {
        // Clear NSUserDefaults
        let appDomain = NSBundle.mainBundle().bundleIdentifier!
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
        
        configureViews()
        
        companyCheckbox.userInteractionEnabled = true
        individualCheckbox.userInteractionEnabled = true
        companyCheckbox.setCheckState(M13Checkbox.CheckState.Unchecked, animated: true)
        individualCheckbox.setCheckState(M13Checkbox.CheckState.Unchecked, animated: true)
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        individualImageView.removeFromSuperview()
        individualTitle.removeFromSuperview()
        individualSubtitle.removeFromSuperview()
        companyImageView.removeFromSuperview()
        companyTitle.removeFromSuperview()
        companySubtitle.removeFromSuperview()
    }
    
    //Changing Status Bar
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }
    
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return UIStatusBarAnimation.Slide
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureCheckboxes()
        
        layoutSubviews()
        
    }
    
    func layoutSubviews() {
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
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        // Individual Section
        
        backgroundIndividualImageView.backgroundColor = UIColor.offWhite()
        backgroundIndividualImageView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight/2)
        self.view.addSubview(backgroundIndividualImageView)
        
        individualImageView.image = UIImage(named: "IconIndividual")
        individualImageView.center = backgroundIndividualImageView.center
        individualImageView.frame = CGRect(x: backgroundIndividualImageView.frame.width/2-40, y: backgroundIndividualImageView.frame.height/2-60, width: 80, height: 80)
        
        individualCheckbox.frame = CGRect(x: backgroundIndividualImageView.frame.width/2-40, y: backgroundIndividualImageView.frame.height/2-60, width: 80, height: 80)
        individualCheckbox.markType = .Checkmark
        individualCheckbox.stateChangeAnimation = .Spiral
        individualCheckbox.animationDuration = 0.5
        individualCheckbox.addTarget(self, action: #selector(checkState(_:)), forControlEvents: .ValueChanged)
        individualCheckbox.tintColor = UIColor.lightBlue()
        individualCheckbox.secondaryTintColor = UIColor.lightBlue().colorWithAlphaComponent(0.5)
        
        individualTitle.textColor = UIColor.slateBlue()
        individualTitle.textAlignment = .Center
        individualTitle.font = UIFont.systemFontOfSize(18)
        individualTitle.frame = CGRect(x: 0, y: backgroundIndividualImageView.frame.height/2+20, width: screenWidth, height: 40)
        individualTitle.text = "Individual"
        
        individualSubtitle.textColor = UIColor.slateBlue().colorWithAlphaComponent(0.5)
        individualSubtitle.textAlignment = .Center
        individualSubtitle.font = UIFont.systemFontOfSize(12)
        individualSubtitle.frame = CGRect(x: 0, y: backgroundIndividualImageView.frame.height/2+50, width: screenWidth, height: 40)
        individualSubtitle.text = "Start sending and receiving payments"
        
        
        //// Company Section
        
        
        backgroundCompanyImageView.backgroundColor = UIColor.mediumBlue()
        backgroundCompanyImageView.frame = CGRect(x: 0, y: screenHeight/2, width: screenWidth, height: screenHeight/2)
        self.view.addSubview(backgroundCompanyImageView)
        
        companyImageView.image = UIImage(named: "IconBusinessBuilding")
        companyImageView.center = backgroundCompanyImageView.center
        companyImageView.frame = CGRect(x: backgroundCompanyImageView.frame.width/2-40, y: backgroundCompanyImageView.frame.height/2-60, width: 80, height: 80)
        
        companyCheckbox.frame = CGRect(x: backgroundCompanyImageView.frame.width/2-40, y: backgroundCompanyImageView.frame.height/2-60, width: 80, height: 80)
        companyCheckbox.markType = .Checkmark
        companyCheckbox.stateChangeAnimation = .Spiral
        companyCheckbox.animationDuration = 0.5
        companyCheckbox.addTarget(self, action: #selector(checkState(_:)), forControlEvents: .ValueChanged)
        companyCheckbox.tintColor = UIColor.whiteColor()
        
        companyTitle.textColor = UIColor.whiteColor()
        companyTitle.textAlignment = .Center
        companyTitle.font = UIFont.systemFontOfSize(18)
        companyTitle.frame = CGRect(x: 0, y: backgroundCompanyImageView.frame.height/2+20, width: screenWidth, height: 40)
        companyTitle.text = "Company"
        
        companySubtitle.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        companySubtitle.textAlignment = .Center
        companySubtitle.font = UIFont.systemFontOfSize(12)
        companySubtitle.frame = CGRect(x: 0, y: backgroundCompanyImageView.frame.height/2+50, width: screenWidth, height: 40)
        companySubtitle.text = "Higher volume limits enabled"
        
        // Page title
        
        pageTitle.frame = CGRect(x: 0, y: 30, width: screenWidth, height: 40)
        pageTitle.textAlignment = .Center
        pageTitle.text = "Let's get started"
        pageTitle.textColor = UIColor.mediumBlue()
        pageTitle.font = UIFont.systemFontOfSize(18)
        //        self.view.addSubview(pageTitle)
        //        self.view.bringSubviewToFront(pageTitle)
        
        pageSubtitle.frame = CGRect(x: 0, y: 20, width: screenWidth, height: 40)
        pageSubtitle.textAlignment = .Center
        pageSubtitle.text = "Choose entity type"
        pageSubtitle.textColor = UIColor.mediumBlue().colorWithAlphaComponent(0.5)
        pageSubtitle.font = UIFont.systemFontOfSize(14)
        self.view.addSubview(pageSubtitle)
        self.view.bringSubviewToFront(pageSubtitle)
        
        // Close button to return to auth view
        backBtn.setBackgroundImage(UIImage(named: "IconClose"), forState: .Normal)
        backBtn.setBackgroundImage(UIImage(named: "IconClose")?.alpha(0.5), forState: .Highlighted)
        backBtn.addTarget(self, action: #selector(SignupViewControllerZero.goToAuth(_:)), forControlEvents: .TouchUpInside)
        backBtn.frame = CGRectMake(0, -10, 33, 33)
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
    
    func configureCheckboxes() {
        let _ = Timeout(0.2) {
            self.addTopSubviewWithBounce(self.individualCheckbox)
        }

        let _ = Timeout(0.2) {
            self.addBottomSubviewWithBounce(self.companyCheckbox)
        }
    }
    
    func configureViews() {
        self.addTopSubviewWithBounce(self.individualImageView)

        self.addBottomSubviewWithBounce(self.companyImageView)

        self.addTopSubviewWithBounce(self.individualTitle)
        let _ = Timeout(0.1) {
            self.addTopSubviewWithBounce(self.individualSubtitle)
        }
        
        self.addBottomSubviewWithBounce(self.companyTitle)
        let _ = Timeout(0.1) {
            self.addBottomSubviewWithBounce(self.companySubtitle)
        }
    }
    
    func checkState(sender: AnyObject) {
        // Check company state //
        // if company checkbox is checked
        if String(companyCheckbox.checkState) == "Checked" {
            // uncheck individual
            companyCheckbox.userInteractionEnabled = false
            individualCheckbox.userInteractionEnabled = false
            if String(individualCheckbox.checkState) == "Checked" {
                individualCheckbox.toggleCheckState(false)
                UIView.animateWithDuration(0.6, animations: {
                    self.individualImageView.alpha = 1.0
                    }, completion: {(value: Bool) in
                })
            }
            UIView.animateWithDuration(0.6, animations: {
                self.companyImageView.alpha = 0.0
                }, completion: {(value: Bool) in
                    let _ = Timeout(0.6) {
                        self.performSegueWithIdentifier("companySegue", sender: sender)
                    }
            })
        } else if String(companyCheckbox.checkState) == "Unchecked" {
            UIView.animateWithDuration(0.6, animations: {
                self.companyImageView.alpha = 1.0
                }, completion: {(value: Bool) in
                    print("finito company from unchecked")
            })
        }
        
        // Check individual state //
        if String(individualCheckbox.checkState) == "Checked" {
            // uncheck company
            print("print individual checkboxstate is", individualCheckbox.checkState)
            companyCheckbox.userInteractionEnabled = false
            individualCheckbox.userInteractionEnabled = false
            if String(companyCheckbox.checkState) == "Checked" {
                companyCheckbox.toggleCheckState(false)
                // set company image view back to alpha of 1 and unchecked state
                UIView.animateWithDuration(0.6, animations: {
                    self.companyImageView.alpha = 1.0
                    }, completion: {(value: Bool) in
                })
            }
            UIView.animateWithDuration(0.6, animations: {
                self.individualImageView.alpha = 0.0
                }, completion: {(value: Bool) in
                    let _ = Timeout(0.6) {
                        self.performSegueWithIdentifier("individualSegue", sender: sender)
                    }
            })
        } else if String(individualCheckbox.checkState) == "Unchecked" {
            print("individual checkbox is", individualCheckbox.checkState)
            UIView.animateWithDuration(0.6, animations: {
                self.individualImageView.alpha = 1.0
                }, completion: {(value: Bool) in
                    print("finito indivdual from unchecked")
            })
        }
    }
    
    func addTopSubviewWithBounce(view: UIView) {
        view.alpha = 0
        view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001)
        self.backgroundIndividualImageView.addSubview(view)
        UIView.animateWithDuration(0.5, animations: {() -> Void in
            view.alpha = 1
            view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0)
            }, completion: {(finished: Bool) -> Void in
                UIView.animateWithDuration(0.3, animations: {() -> Void in
                    }, completion: {(finished: Bool) -> Void in
                        UIView.animateWithDuration(0.2, animations: {() -> Void in
                            view.transform = CGAffineTransformIdentity
                        })
                })
        })
    }
    
    func addBottomSubviewWithBounce(view: UIView) {
        view.alpha = 0
        view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001)
        self.backgroundCompanyImageView.addSubview(view)
        UIView.animateWithDuration(0.5, animations: {() -> Void in
            view.alpha = 1
            view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0)
            }, completion: {(finished: Bool) -> Void in
                UIView.animateWithDuration(0.3, animations: {() -> Void in
                    }, completion: {(finished: Bool) -> Void in
                        UIView.animateWithDuration(0.2, animations: {() -> Void in
                            view.transform = CGAffineTransformIdentity
                        })
                })
        })
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