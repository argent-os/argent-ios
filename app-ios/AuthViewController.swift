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
        "Welcome to Argent",
        "Argent'e' hoş geldiniz",
        "Bienvenue à Argent",
        "歡迎銀色",
        "Bienvenidos a Argent",
        "アージェントすることを歓迎",
        "Добро пожаловать в Серебряном",
        "Willkommen in Argent",
        "은빛에 오신 것을 환영합니다",
        "Benvenuto a Argent"
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
        // Set background image
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
        loginButton.backgroundColor = UIColor(rgba: "#0003")
        loginButton.tintColor = UIColor(rgba: "#fff")
        loginButton.setTitleColor(UIColor(rgba: "#fff"), forState: .Normal)
        loginButton.setTitleColor(UIColor(rgba: "#ddd"), forState: .Highlighted)
        loginButton.titleLabel?.font = UIFont(name: "Avenir-Book", size: 16)
        loginButton.setTitle("Log in", forState: .Normal)
        loginButton.layer.cornerRadius = 5
        loginButton.layer.borderWidth = 2
        loginButton.layer.borderColor = UIColor(rgba: "#fffa").CGColor
        loginButton.layer.masksToBounds = true
        loginButton.addTarget(self, action: #selector(AuthViewController.login(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(loginButton)
        
        let signupButton = UIButton(frame: CGRect(x: screenWidth*0.5+10, y: screenHeight-60-10, width: screenWidth/2-20, height: 60.0))
        signupButton.backgroundColor = UIColor.whiteColor()
        signupButton.setTitle("Sign up", forState: .Normal)
        signupButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        signupButton.setTitleColor(UIColor(rgba: "#aaa"), forState: .Highlighted)
        signupButton.titleLabel?.font = UIFont(name: "Avenir-Book", size: 16)
        signupButton.layer.cornerRadius = 5
        signupButton.layer.borderWidth = 2
        signupButton.layer.borderColor = UIColor(rgba: "#fffa").CGColor
        signupButton.layer.masksToBounds = true
        signupButton.addTarget(self, action: #selector(AuthViewController.signup(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(signupButton)
        
        let imageName = "Logo"
        let image = UIImage(named: imageName)
        imageView.image = image
        imageView.layer.cornerRadius = 30
        imageView.layer.masksToBounds = true
        imageView.tag = 7577
        imageView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        imageView.frame.origin.y = screenHeight*0.14 // 14 down from the top
        imageView.frame.origin.x = (self.view.bounds.size.width - imageView.frame.size.width) / 2.0 // centered left to right.
        
        let attributedString = NSMutableAttributedString(string: "Welcome to Argent")
        // Set range of string length to exactly 8, the number of characters
        attributedString.addAttribute(NSFontAttributeName, value: "Avenir-Bold", range: NSRange(location: 0, length: 15)
        )
        lbl.morphingEffect = .Scale
        lbl.delegate = self
        lbl.morphingEnabled = true
        lbl.text = text
        lbl.tag = 7578
        lbl.frame.origin.y = screenHeight*0.40 // 20 down from the top
        lbl.textAlignment = NSTextAlignment.Center
        lbl.textColor = UIColor.whiteColor()
        lbl.font = UIFont(name: "Avenir-Bold", size: 14)
        view.addSubview(lbl)
        let lblTimer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(AuthViewController.changeText(_:)), userInfo: nil, repeats: true)


        _ = NSMutableAttributedString(string: "Tap to view app features.")
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 100.0))
        button.tag = 7579
        button.frame.origin.y = screenHeight*0.44 // 20 down from the top
        button.backgroundColor = UIColor.clearColor()
        button.setTitle("Tap to view app features.", forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Light", size: 14)
        button.addTarget(self, action: #selector(self.goToTutorial(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(button)
    }
    
    //Changing Status Bar
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    
    func goToTutorial(sender: AnyObject!) {
        let viewController:UIViewController = UIStoryboard(name: "Auth", bundle: nil).instantiateViewControllerWithIdentifier("onboardingVC") as! OnboardingViewController
        
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
        addSubviewWithBounce(imageView)
    }

    func addSubviewWithBounce(view: UIView) {
        view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001)
        self.view.addSubview(view)
        UIView.animateWithDuration(0.3 / 1.5, animations: {() -> Void in
            view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0)
            }, completion: {(finished: Bool) -> Void in
                UIView.animateWithDuration(0.3 / 2, animations: {() -> Void in
                    }, completion: {(finished: Bool) -> Void in
                        UIView.animateWithDuration(0.3 / 2, animations: {() -> Void in
                            view.transform = CGAffineTransformIdentity
                        })
                })
        })
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