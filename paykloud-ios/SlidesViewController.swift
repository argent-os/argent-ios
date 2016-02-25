//
//  InitializeAuth.swift
//  paykloud-ios
//
//  Created by Sinan Ulkuatam on 2/9/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import QuartzCore
import SwiftGifOrigin
import UIKit
import SVProgressHUD

class SlidesViewController: UIPageViewController  {
    
    var window: UIWindow?
    
    override func viewDidAppear(animated: Bool) {
        SVProgressHUD.dismiss()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.dismiss()
        
        let navigationController = UINavigationController()
        //        var navigationController = UINavigationController(rootViewController: pages)
        // Transparent navigation bar
        navigationController.navigationBar.barTintColor = UIColor.whiteColor()
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.clipsToBounds = true
        navigationController.navigationBar.translucent = true
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("authViewController")
        navigationController.pushViewController(vc, animated: true)
        
        // Border radius on uiview
        view.layer.cornerRadius = 0
        view.layer.masksToBounds = true
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        // UI
        let loginButton = UIButton(frame: CGRect(x: 0, y: screenHeight*0.91, width: screenWidth/2, height: 60.0))
        loginButton.backgroundColor = UIColor(rgba: "#1aa8f6")
        loginButton.tintColor = UIColor(rgba: "#fff")
        loginButton.setTitleColor(UIColor(rgba: "#fff"), forState: .Normal)
        loginButton.titleLabel?.font = UIFont(name: "Nunito", size: 16)
        loginButton.setTitle("Log in", forState: .Normal)
        loginButton.layer.cornerRadius = 0
        loginButton.layer.masksToBounds = true
        loginButton.addTarget(self, action: "login:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(loginButton)
        
        let signupButton = UIButton(frame: CGRect(x: screenWidth*0.5, y: screenHeight*0.91, width: screenWidth/2, height: 60.0))
        signupButton.backgroundColor = UIColor.clearColor()
        signupButton.setTitle("Sign up", forState: .Normal)
        signupButton.setTitleColor(UIColor(rgba: "#1aa8f6"), forState: .Normal)
        signupButton.titleLabel?.font = UIFont(name: "Nunito", size: 16)
        signupButton.layer.cornerRadius = 0
        signupButton.layer.borderWidth = 1
        signupButton.layer.borderColor = UIColor(rgba: "#1aa8f6").CGColor
        signupButton.layer.masksToBounds = true
        signupButton.addTarget(self, action: "signup:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(signupButton)
        
    }
    
    // Set the ID in the storyboard in order to enable transition!
    func signup(sender:AnyObject!)
    {
        print("signup tapped")
        // Key to fixing window transition! Needs to reset view to bounds
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let viewController:UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SignupNavigationController") as! UINavigationController
        self.window?.rootViewController = viewController
        self.window?.makeKeyAndVisible()
        self.window?.makeKeyWindow()
        UIApplication.sharedApplication().keyWindow?.rootViewController = viewController
        UIApplication.sharedApplication().keyWindow?.rootViewController = viewController
        self.navigationController?.presentViewController(viewController, animated: true, completion: nil)
        self.window?.layer.zPosition = 100
        viewController.view.layer.zPosition = 200    }
    
    // Set the ID in the storyboard in order to enable transition!
    func login(sender:AnyObject!)
    {
        print("login tapped")
        // Key to fixing window transition! Needs to reset view to bounds
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let viewController:LoginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        self.window?.rootViewController = viewController
        self.window?.makeKeyAndVisible()
        self.window?.makeKeyWindow()
        UIApplication.sharedApplication().keyWindow?.rootViewController = viewController
        self.navigationController?.presentViewController(viewController, animated: true, completion: nil)
        self.window?.layer.zPosition = 100
        viewController.view.layer.zPosition = 200
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("received memory warning")
        // Dispose of any resources that can be recreated.
    }
    
    func makeKeyAndVisible() {
        window!.backgroundColor = UIColor.clearColor()
        window!.alpha = 0
        UIView.beginAnimations("fade-in", context: nil)
        self.makeKeyAndVisible()
        window!.alpha = 1
        UIView.commitAnimations()
    }
    
    func resignKeyWindow() {
        window!.alpha = 1
        UIView.beginAnimations("fade-out", context: nil)
        self.resignKeyWindow()
        window!.alpha = 0
        UIView.commitAnimations()
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
