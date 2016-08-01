//
//  AuthViewControllerStepTwo.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 8/1/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation

class AuthViewControllerStepTwo: UIPageViewController, UIPageViewControllerDelegate {
    
    private var i = -1
    
    private var textArray2 = [
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
    
    private var textArray3 = [
        "AUTOMATE RECURRING PAYMENTS",
        "ACCEPT ONE-TIME PAYMENTS"
    ]
    
    let lbl = UILabel()
    
    let lblDetail = UILabel()
    
    let imageView = UIImageView()
    
    private var text: String {
        i = i >= textArray3.count - 1 ? 0 : i + 1
        return textArray3[i]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Border radius on uiview
        
        configureView()
    }
    
    func configureView() {
        
        // screen width and height:
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        self.view.backgroundColor = UIColor.globalBackground()        // Set background image
        let backgroundView: UIImageView = UIImageView(image: UIImage(named: "BackgroundWalkthroughTwo"))
        backgroundView.contentMode = UIViewContentMode.ScaleAspectFill
        backgroundView.frame = self.view.bounds
        self.view!.addSubview(backgroundView)
        
        // Set range of string length to exactly 8, the number of characters
        lblDetail.frame = CGRect(x: 0, y: screenHeight*0.39, width: screenWidth, height: 40)
        lblDetail.tag = 7579
        lblDetail.textAlignment = NSTextAlignment.Center
        lblDetail.textColor = UIColor.whiteColor()
        lblDetail.adjustAttributedString("ACCEPT BITCOIN", spacing: 4, fontName: "MyriadPro-Regular", fontSize: 13, fontColor: UIColor.whiteColor())
        view.addSubview(lblDetail)
        
        //        // Set range of string length to exactly 8, the number of characters
        //        lblSubtext.font = UIFont(name: "MyriadPro-Regular", size: 17)
        //        lblSubtext.text = "ARGENT"
        //        lblSubtext.tag = 7579
        //        lblSubtext.font.morphingEffect = .Scale
        //        lblSubtext.font.delegate = self
        //        lblSubtext.font.morphingEnabled = true
        //        lblSubtext.frame.origin.y = screenHeight*0.35 // 20 down from the top
        //        lblSubtext.textAlignment = NSTextAlignment.Center
        //        lblSubtext.textColor = UIColor.whiteColor()
        //        view.addSubview(lblSubtext)
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 100.0))
        button.tag = 7579
        button.frame.origin.y = screenHeight*0.35 // 20 down from the top
        button.backgroundColor = UIColor.clearColor()
        button.setTitle("View Features", forState: .Normal)
        button.setTitleColor(UIColor.whiteColor().colorWithAlphaComponent(0.7), forState: .Normal)
        button.titleLabel?.font = UIFont(name: "MyriadPro-Regular", size: 12)!
        button.addTarget(self, action: #selector(self.goToTutorial(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        //        view.addSubview(button)
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
    
    override func viewDidAppear(animated: Bool) {
        addSubviewWithFade(imageView, parentView: self, duration: 0.8)
    }
}
