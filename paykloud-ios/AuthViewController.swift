//
//  InitializeAuth.swift
//  paykloud-ios
//
//  Created by Sinan Ulkuatam on 2/9/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import VideoSplashKit
import QuartzCore
import SVProgressHUD
import Gecco

class AuthViewController: UIViewController  {
    
    var spotlightViewController: SpotlightViewController?
    
    override func viewDidAppear(animated: Bool) {

        SVProgressHUD.dismiss()
    }
    
    
    @IBAction func basicAlertButtonPress() {
        JSSAlertView().show(self, title: "Boring and basic, but with a multi-line title")
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "tutorialView") {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Border radius on uiview
        view.layer.cornerRadius = 0
        view.layer.masksToBounds = true
        
        showSpotlight()

        // Set background image
        var backgroundView: UIImageView = UIImageView(image: UIImage(named: "BackgroundGradientInverse"))
        backgroundView.contentMode = UIViewContentMode.ScaleAspectFill
        backgroundView.frame = self.view.bounds
        self.view!.addSubview(backgroundView)
        
        // screen width and height:
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("authViewController")
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        // UI
        let loginButton = UIButton(frame: CGRect(x: 0, y: screenHeight*0.91, width: screenWidth/2, height: 60.0))
        loginButton.backgroundColor = UIColor(rgba: "#1796fa")
        loginButton.tintColor = UIColor(rgba: "#fff")
        loginButton.setTitleColor(UIColor(rgba: "#fff"), forState: .Normal)
        loginButton.titleLabel?.font = UIFont(name: "Nunito-SemiBold", size: 16)
        loginButton.setTitle("Log in", forState: .Normal)
        loginButton.layer.cornerRadius = 0
        loginButton.layer.masksToBounds = true
        loginButton.addTarget(self, action: "login:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(loginButton)
        
        let signupButton = UIButton(frame: CGRect(x: screenWidth*0.5, y: screenHeight*0.91, width: screenWidth/2, height: 60.0))
        signupButton.backgroundColor = UIColor.whiteColor()
        signupButton.setTitle("Sign up", forState: .Normal)
        signupButton.setTitleColor(UIColor(rgba: "#1796fa"), forState: .Normal)
        signupButton.titleLabel?.font = UIFont(name: "Nunito-SemiBold", size: 16)
        signupButton.layer.cornerRadius = 0
        signupButton.layer.borderWidth = 1
        signupButton.layer.borderColor = UIColor(rgba: "#ffffff").CGColor
        signupButton.layer.masksToBounds = true
        signupButton.addTarget(self, action: "signup:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(signupButton)
        
        let imageName = "IconLogo"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.tag = 7577
        imageView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        imageView.frame.origin.y = screenHeight*0.14 // 14 down from the top
        imageView.frame.origin.x = (self.view.bounds.size.width - imageView.frame.size.width) / 2.0 // centered left to right.
        view.addSubview(imageView)
        
        let attributedString = NSMutableAttributedString(string: "Welcome to Proton Payments")
        // Set range of string length to exactly 8, the number of characters in PayKloud
        attributedString.addAttribute(NSFontAttributeName, value: "Nunito", range: NSRange(location: 0, length: 15)
        )
        let text = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 100.0))
        text.tag = 7578
        text.frame.origin.y = screenHeight*0.40 // 20 down from the top
        text.textAlignment = NSTextAlignment.Center
        text.textColor = UIColor.whiteColor()
        text.attributedText = attributedString
        text.font = UIFont(name: "Nunito-ExtraBold", size: 14)
        view.addSubview(text)
        
        let attributedString1 = NSMutableAttributedString(string: "Tap to view app features.")
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 100.0))
        button.tag = 7579
        button.frame.origin.y = screenHeight*0.44 // 20 down from the top
        button.backgroundColor = UIColor.clearColor()
        button.setTitle("Tap to view app features.", forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.titleLabel?.font = UIFont(name: "Nunito-SemiBold", size: 14)
        button.addTarget(self, action: "goToTutorial:", forControlEvents: UIControlEvents.TouchUpInside)
//        button.textAlignment = NSTextAlignment.Center
//        button.textColor = UIColor(rgba: "#1aa8f6")
//        button.font = UIFont (name: "Nunito", size: 14)
        view.addSubview(button)
        
    }
    
    //Changing Status Bar
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    // Set the ID in the storyboard in order to enable transition!
    func signup(sender:AnyObject!)
    {
        let viewController:UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SignupNavigationController") as! UINavigationController
        
        self.presentViewController(viewController, animated: true, completion: nil)
        
    }
    
    func goToTutorial(sender: AnyObject!) {
        let viewController:BackgroundAnimationViewController = UIStoryboard(name: "Auth", bundle: nil).instantiateViewControllerWithIdentifier("BackgroundAnimationViewController") as! BackgroundAnimationViewController
        
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    // Set the ID in the storyboard in order to enable transition!
    func login(sender:AnyObject!)
    {
        let viewController:LoginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        
        self.presentViewController(viewController, animated: true, completion: nil)
    }

    func showSpotlight() {
        let spotlightViewController = SpotlightViewController()
        presentViewController(spotlightViewController, animated: true, completion: nil)
        spotlightViewController.spotlightView.appear(Spotlight.Oval(center: CGPointMake(100, 100), diameter: 100))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func resizeImage(image: UIImage, newSize: CGSize) -> (UIImage) {
        let newRect = CGRectIntegral(CGRectMake(0,0, newSize.width, newSize.height))
        let imageRef = image.CGImage
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        let context = UIGraphicsGetCurrentContext()
        
        // Set the quality level to use when rescaling
        CGContextSetInterpolationQuality(context, CGInterpolationQuality.High)
        let flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height)
        
        CGContextConcatCTM(context, flipVertical)
        // Draw into the context; this scales the image
        CGContextDrawImage(context, newRect, imageRef)
        
        let newImageRef = CGBitmapContextCreateImage(context)! as CGImage
        let newImage = UIImage(CGImage: newImageRef)
        
        // Get the resized image from the context and a UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}