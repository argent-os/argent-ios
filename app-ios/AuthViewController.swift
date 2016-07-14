//
//  AuthViewController.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 2/9/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import LTMorphingLabel
import Foundation
import TransitionTreasury
import TransitionAnimation

class AuthViewController: UIViewController, LTMorphingLabelDelegate, ModalTransitionDelegate  {
    
    private var i = -1
    private var textArray = [
        "Welcome to " + APP_NAME,
        APP_NAME + "'e hoş geldiniz",
        "Bienvenue à " + APP_NAME,
        "歡迎銀色",
        "Bienvenidos a " + APP_NAME,
        "アージェントすることを歓迎",
        "Добро пожаловать в Серебряном",
        "Willkommen in " + APP_NAME,
        "은빛에 오신 것을 환영합니다",
        "Benvenuto a " + APP_NAME
    ]
    
    internal var tr_presentTransition: TRViewControllerTransitionDelegate?

    let lbl = LTMorphingLabel(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 100.0))
    let imageView = UIImageView()
    
    private var text: String {
        i = i >= textArray.count - 1 ? 0 : i + 1
        return textArray[i]
    }
    
    func changeText(sender: AnyObject) {
        lbl.text = text
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func skipOnboarding(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("kDismissOnboardingNotification", object: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Border radius on uiview
        
        configureView()
    }
    
    func configureView() {
        
        self.view.backgroundColor = UIColor.globalBackground()        // Set background image
        let backgroundView: UIImageView = UIImageView(image: UIImage(named: "BackgroundBusiness1"))
        backgroundView.contentMode = UIViewContentMode.ScaleAspectFill
        backgroundView.frame = self.view.bounds
        self.view!.addSubview(backgroundView)
        
        // screen width and height:
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        // UI
        let loginButton = UIButton(frame: CGRect(x: 10, y: screenHeight-60-10, width: screenWidth/2-20, height: 60.0))
        loginButton.setBackgroundColor(UIColor.mediumBlue().colorWithAlphaComponent(0.2), forState: .Normal)
        loginButton.setBackgroundColor(UIColor.mediumBlue().colorWithAlphaComponent(0.8), forState: .Highlighted)
        loginButton.tintColor = UIColor(rgba: "#fff")
        loginButton.setTitleColor(UIColor(rgba: "#fff"), forState: .Normal)
        loginButton.setTitleColor(UIColor.offWhite(), forState: .Highlighted)
        loginButton.titleLabel?.font = UIFont.systemFontOfSize(16)
        loginButton.setTitle("Log in", forState: .Normal)
        loginButton.layer.cornerRadius = 5
        loginButton.layer.borderWidth = 2
        loginButton.layer.borderColor = UIColor(rgba: "#fffa").CGColor
        loginButton.layer.masksToBounds = true
        loginButton.addTarget(self, action: #selector(AuthViewController.login(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(loginButton)
        
        let signupButton = UIButton(frame: CGRect(x: screenWidth*0.5+10, y: screenHeight-60-10, width: screenWidth/2-20, height: 60.0))
        signupButton.setBackgroundColor(UIColor.whiteColor(), forState: .Normal)
        signupButton.setBackgroundColor(UIColor.offWhite(), forState: .Highlighted)
        signupButton.setTitle("Sign up", forState: .Normal)
        signupButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        signupButton.setTitleColor(UIColor.blackColor(), forState: .Highlighted)
        signupButton.titleLabel?.font = UIFont.systemFontOfSize(16)
        signupButton.layer.cornerRadius = 5
        signupButton.layer.borderWidth = 2
        signupButton.layer.borderColor = UIColor(rgba: "#fff8").CGColor
        signupButton.layer.masksToBounds = true
        signupButton.addTarget(self, action: #selector(AuthViewController.signup(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(signupButton)
        
        let imageName = "LogoOutline"
        let image = UIImage(named: imageName)
        imageView.image = image
        imageView.layer.masksToBounds = true
        imageView.tag = 7577
        imageView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        imageView.frame.origin.y = screenHeight*0.14 // 14 down from the top
        imageView.frame.origin.x = (self.view.bounds.size.width - imageView.frame.size.width) / 2.0 // centered left to right.
        
        let attributedString = NSMutableAttributedString(string: "Welcome to Argent")
        // Set range of string length to exactly 8, the number of characters
        attributedString.addAttribute(NSFontAttributeName, value: "HelveticaNeue-Light", range: NSRange(location: 0, length: 15))
        lbl.morphingEffect = .Scale
        lbl.delegate = self
        lbl.morphingEnabled = true
        lbl.text = text
        lbl.tag = 7578
        lbl.frame.origin.y = screenHeight*0.40 // 20 down from the top
        lbl.textAlignment = NSTextAlignment.Center
        lbl.textColor = UIColor.whiteColor()
        lbl.font = UIFont.systemFontOfSize(16)
        view.addSubview(lbl)
        _ = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(AuthViewController.changeText(_:)), userInfo: nil, repeats: true)


        _ = NSMutableAttributedString(string: "Tap to view app features.")
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 100.0))
        button.tag = 7579
        button.frame.origin.y = screenHeight*0.44 // 20 down from the top
        button.backgroundColor = UIColor.clearColor()
        button.setTitle("Tap to view app features.", forState: .Normal)
        button.setTitleColor(UIColor.whiteColor().colorWithAlphaComponent(0.7), forState: .Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(12)
        button.addTarget(self, action: #selector(self.goToTutorial(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(button)
    }
    
    //Changing Status Bar
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    
    func goToTutorial(sender: AnyObject!) {
        let viewController:UIViewController = UIStoryboard(name: "Auth", bundle: nil).instantiateViewControllerWithIdentifier("onboardingVC") as! OnboardingViewController
        viewController.modalTransitionStyle = .CrossDissolve
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    

    // Set the ID in the storyboard in order to enable transition!
    func signup(sender:AnyObject!) {
        let viewController:UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SignupNavigationController") as! UINavigationController
        
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    // Set the ID in the storyboard in order to enable transition!
    func login(sender:AnyObject!) {
        let model = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        model.modalDelegate = self
        tr_presentViewController(model, method: TRPresentTransitionMethod.Fade, statusBarStyle: .LightContent, completion: {
        })
    }

    // MARK: - Modal tt delegate
    
    func modalViewControllerDismiss(callbackData data: AnyObject? = nil) {
        tr_dismissViewController(completion: {
            print("Dismiss finished.")
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        addSubviewWithFade(imageView, parentView: self, duration: 0.8)
    }
}

extension AuthViewController {
    
    func morphingDidStart(label: LTMorphingLabel) {
        
    }
    
    func morphingDidComplete(label: LTMorphingLabel) {
        
    }
    
    func morphingOnProgress(label: LTMorphingLabel, progress: Float) {
        
    }
    
}