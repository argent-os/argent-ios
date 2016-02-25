//
//  InitializeAuth.swift
//  paykloud-ios
//
//  Created by Sinan Ulkuatam on 2/9/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import QuartzCore
import SwiftGifOrigin
import Pages
import UIKit
import SVProgressHUD

class AuthViewController: UIViewController, UIGestureRecognizerDelegate  {
    
    var window: UIWindow?
    
    func pagesControllerInCode() -> PagesController {
        
        // screen width and height:
        let width = UIScreen.mainScreen().bounds.size.width
        let height = UIScreen.mainScreen().bounds.size.height
        
        // Padding for paragraph
        var initialFrame: CGRect = CGRectMake(0, height*0.45, width, 100)
        var contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        var paddedFrame: CGRect = UIEdgeInsetsInsetRect(initialFrame, contentInsets)
        
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        let viewController1 = UIViewController()
        viewController1.view.backgroundColor = .whiteColor()
        viewController1.view.frame=CGRectMake(0, 0,width, height);
        viewController1.title = " "
        let imageName = "IconLogoColor"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 0, y: height*0.18, width: 60, height: 60)
        imageView.frame.origin.y = height*0.20 // 20 down from the top
        imageView.frame.origin.x = (self.view.bounds.size.width - imageView.frame.size.width) / 2.0 // centered left to right.
        viewController1.view.addSubview(imageView)
        viewController1.view.bringSubviewToFront(imageView)
        let attributedString = NSMutableAttributedString(string: "Welcome to PayKloud")
        // Set range of string length to exactly 8, the number of characters in PayKloud
        attributedString.addAttribute(NSFontAttributeName, value: "Nunito", range: NSRange(location: 0, length: 15)
        )
        let text = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: 100.0))
        text.frame.origin.y = height*0.25 // 20 down from the top
        text.textAlignment = NSTextAlignment.Center
        text.textColor = UIColor.darkGrayColor()
        text.attributedText = attributedString
        text.font = UIFont(name: "Nunito-SemiBold", size: 14)
        viewController1.view.addSubview(text)
        viewController1.view.bringSubviewToFront(text)
        
        let attributedString1 = NSMutableAttributedString(string: "Swipe to learn more.")
        let text1 = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: 100.0))
        text1.frame.origin.y = height*0.29 // 20 down from the top
        text1.attributedText = attributedString1
        text1.textAlignment = NSTextAlignment.Center
        text1.textColor = UIColor.lightGrayColor()
        text1.font = UIFont (name: "Nunito", size: 14)
        viewController1.view.addSubview(text1)
        viewController1.view.bringSubviewToFront(text1)
        
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        let viewController2 = UIViewController()
        viewController2.view.backgroundColor = .whiteColor()
        viewController2.title = " "
        // Add the image
        let imageViewBackground2 = UIImageView(frame: CGRectMake(0, 0, 120, 120))
        imageViewBackground2.image = UIImage(named: "IconPhoneRecur")
        imageViewBackground2.contentMode = UIViewContentMode.ScaleAspectFill
        imageViewBackground2.frame.origin.y = height*0.22 // 22 down from the top
        imageViewBackground2.frame.origin.x = (self.view.bounds.size.width - imageViewBackground2.frame.size.width) / 2.0
        viewController2.view.addSubview(imageViewBackground2)
        viewController2.view.sendSubviewToBack(imageViewBackground2)
        // Create string
        let attributedHeaderString2 = NSMutableAttributedString(string: "Eazy Peazy")
        let header2 = UILabel(frame: paddedFrame)
        header2.frame.origin.y = height*0.40 // 20 down from the top
        header2.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
        header2.numberOfLines = 4
        header2.attributedText = attributedHeaderString2
        header2.textAlignment = NSTextAlignment.Center
        header2.textColor = UIColor.darkGrayColor()
        header2.font = UIFont (name: "Nunito", size: 24)
        viewController2.view.addSubview(header2)
        viewController2.view.bringSubviewToFront(header2)
        let attributedString2 = NSMutableAttributedString(string: "Leggings bushwick locavore, photo booth gastropub cornhole brooklyn man bun art party shoreditch. Salvia hoodie humblebrag, gastropub fingerstache lo-fi chia selvage meggings fanny pack. Franzen authentic normcore 8-bit tumblr. Ugh YOLO selvage tumblr butcher. IPhone gastropub irony food truck, authentic artisan gluten-free pop-up umami bicycle rights. Selfies chartreuse lumbersexual, tacos venmo chicharrones you probably haven't heard of them YOLO everyday carry. PBR&B waistcoat cred, mlkshk 3 wolf moon knausgaard intelligentsia hoodie authentic dreamcatcher cronut lo-fi brooklyn YOLO paleo.")
        let text2 = UILabel(frame: paddedFrame)
        // Style for the text block
        text2.frame.origin.y = height*0.50 // 20 down from the top
        text2.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
        text2.numberOfLines = 4
        text2.attributedText = attributedString2
        text2.textAlignment = NSTextAlignment.Center
        text2.textColor = UIColor.lightGrayColor()
        text2.font = UIFont (name: "Nunito", size: 14)
        viewController2.view.addSubview(text2)
        viewController2.view.bringSubviewToFront(text2)
        
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        let viewController3 = UIViewController()
        viewController3.view.backgroundColor = .whiteColor()
        viewController3.title = " "
        // Add the image
        let imageViewBackground3 = UIImageView(frame: CGRectMake(0, 0, 120, 120))
        imageViewBackground3.image = UIImage(named: "IconNotify")
        imageViewBackground3.contentMode = UIViewContentMode.ScaleAspectFill
        imageViewBackground3.frame.origin.y = height*0.22 // 22 down from the top
        imageViewBackground3.frame.origin.x = (self.view.bounds.size.width - imageViewBackground3.frame.size.width) / 2.0
        viewController3.view.addSubview(imageViewBackground3)
        viewController3.view.sendSubviewToBack(imageViewBackground3)
        // Create string
        let attributedHeaderString3 = NSMutableAttributedString(string: "Lemon Squeezy")
        let header3 = UILabel(frame: paddedFrame)
        header3.frame.origin.y = height*0.40 // 20 down from the top
        header3.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
        header3.numberOfLines = 4
        header3.attributedText = attributedHeaderString3
        header3.textAlignment = NSTextAlignment.Center
        header3.textColor = UIColor.darkGrayColor()
        header3.font = UIFont (name: "Nunito", size: 24)
        viewController3.view.addSubview(header3)
        viewController3.view.bringSubviewToFront(header3)
        let attributedString3 = NSMutableAttributedString(string: "Leggings bushwick locavore, photo booth gastropub cornhole brooklyn man bun art party shoreditch. Salvia hoodie humblebrag, gastropub fingerstache lo-fi chia selvage meggings fanny pack. Franzen authentic normcore 8-bit tumblr. Ugh YOLO selvage tumblr butcher. IPhone gastropub irony food truck, authentic artisan gluten-free pop-up umami bicycle rights. Selfies chartreuse lumbersexual, tacos venmo chicharrones you probably haven't heard of them YOLO everyday carry. PBR&B waistcoat cred, mlkshk 3 wolf moon knausgaard intelligentsia hoodie authentic dreamcatcher cronut lo-fi brooklyn YOLO paleo.")
        let text3 = UILabel(frame: paddedFrame)
        // Style for the text block
        text3.frame.origin.y = height*0.50 // 20 down from the top
        text3.attributedText = attributedString3
        text3.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
        text3.numberOfLines = 4
        text3.textAlignment = NSTextAlignment.Center
        text3.textColor = UIColor.lightGrayColor()
        text3.font = UIFont (name: "Nunito", size: 14)
        viewController3.view.addSubview(text3)
        viewController3.view.bringSubviewToFront(text3)
        
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        
        let viewController4 = UIViewController()
        viewController4.view.backgroundColor = .whiteColor()
        viewController4.title = " "
        // Add the image
        let imageViewBackground4 = UIImageView(frame: CGRectMake(0, 0, 120, 120))
        imageViewBackground4.image = UIImage(named: "IconCreditCard")
        imageViewBackground4.contentMode = UIViewContentMode.ScaleAspectFill
        imageViewBackground4.frame.origin.y = height*0.22 // 22 down from the top
        imageViewBackground4.frame.origin.x = (self.view.bounds.size.width - imageViewBackground4.frame.size.width) / 2.0
        viewController4.view.addSubview(imageViewBackground4)
        viewController4.view.sendSubviewToBack(imageViewBackground4)
        // Create string
        let attributedHeaderString4 = NSMutableAttributedString(string: "Super App")
        let header4 = UILabel(frame: paddedFrame)
        header4.frame.origin.y = height*0.40 // 20 down from the top
        header4.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
        header4.numberOfLines = 4
        header4.attributedText = attributedHeaderString4
        header4.textAlignment = NSTextAlignment.Center
        header4.textColor = UIColor.darkGrayColor()
        header4.font = UIFont (name: "Nunito", size: 24)
        viewController4.view.addSubview(header4)
        viewController4.view.bringSubviewToFront(header4)
        let attributedString4 = NSMutableAttributedString(string: "Leggings bushwick locavore, photo booth gastropub cornhole brooklyn man bun art party shoreditch. Salvia hoodie humblebrag, gastropub fingerstache lo-fi chia selvage meggings fanny pack. Franzen authentic normcore 8-bit tumblr. Ugh YOLO selvage tumblr butcher. IPhone gastropub irony food truck, authentic artisan gluten-free pop-up umami bicycle rights. Selfies chartreuse lumbersexual, tacos venmo chicharrones you probably haven't heard of them YOLO everyday carry. PBR&B waistcoat cred, mlkshk 3 wolf moon knausgaard intelligentsia hoodie authentic dreamcatcher cronut lo-fi brooklyn YOLO paleo.")
        let text4 = UILabel(frame: paddedFrame)
        // Style for the text block
        text4.frame.origin.y = height*0.50 // 50 down from the top
        text4.attributedText = attributedString4
        text4.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
        text4.numberOfLines = 4
        text4.textAlignment = NSTextAlignment.Center
        text4.textColor = UIColor.lightGrayColor()
        text4.font = UIFont (name: "Nunito", size: 14)
        viewController4.view.addSubview(text4)
        viewController4.view.bringSubviewToFront(text4)
        
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        
        let viewController5 = UIViewController()
        viewController5.view.backgroundColor = .whiteColor()
        viewController5.title = " "
        // Add the image
        let imageViewBackground5 = UIImageView(frame: CGRectMake(0, 0, 120, 120))
        imageViewBackground5.image = UIImage(named: "IconTouchSecure")
        imageViewBackground5.contentMode = UIViewContentMode.ScaleAspectFill
        imageViewBackground5.frame.origin.y = height*0.22 // 22 down from the top
        imageViewBackground5.frame.origin.x = (self.view.bounds.size.width - imageViewBackground5.frame.size.width) / 2.0
        viewController5.view.addSubview(imageViewBackground5)
        viewController5.view.sendSubviewToBack(imageViewBackground5)
        // Create string
        let attributedHeaderString5 = NSMutableAttributedString(string: "Wow Power")
        let header5 = UILabel(frame: paddedFrame)
        header5.frame.origin.y = height*0.40 // 20 down from the top
        header5.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
        header5.numberOfLines = 4
        header5.attributedText = attributedHeaderString5
        header5.textAlignment = NSTextAlignment.Center
        header5.textColor = UIColor.darkGrayColor()
        header5.font = UIFont (name: "Nunito", size: 24)
        viewController5.view.addSubview(header5)
        viewController5.view.bringSubviewToFront(header5)
        let attributedString5 = NSMutableAttributedString(string: "Leggings bushwick locavore, photo booth gastropub cornhole brooklyn man bun art party shoreditch. Salvia hoodie humblebrag, gastropub fingerstache lo-fi chia selvage meggings fanny pack. Franzen authentic normcore 8-bit tumblr. Ugh YOLO selvage tumblr butcher. IPhone gastropub irony food truck, authentic artisan gluten-free pop-up umami bicycle rights. Selfies chartreuse lumbersexual, tacos venmo chicharrones you probably haven't heard of them YOLO everyday carry. PBR&B waistcoat cred, mlkshk 3 wolf moon knausgaard intelligentsia hoodie authentic dreamcatcher cronut lo-fi brooklyn YOLO paleo.")
        let text5 = UILabel(frame: paddedFrame)
        // Style for the text block
        text5.frame.origin.y = height*0.50 // 20 down from the top
        text5.attributedText = attributedString5
        text5.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
        text5.numberOfLines = 4
        text5.textAlignment = NSTextAlignment.Center
        text5.textColor = UIColor.lightGrayColor()
        text5.font = UIFont (name: "Nunito", size: 14)
        viewController5.view.addSubview(text5)
        viewController5.view.bringSubviewToFront(text5)
        
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        let pages = PagesController([viewController1,
            viewController2,
            viewController3,
            viewController4,
            viewController5
            ])
        
        // var pageControl: UIPageControl!
        // pageControl!.currentPageIndicatorTintColor = UIColor.darkGrayColor()
        // pageControl!.pageIndicatorTintColor = UIColor.orangeColor()
        // pages.bottomLineView.backgroundColor = UIColor.grayColor()
        // pages.showPageControl = true
        
        pages.showPageControl = false
        pages.enableSwipe = true
        pages.showBottomLine = true
        
        SVProgressHUD.dismiss()

        return pages
    }
    
    func pagesControllerInStoryboard() -> PagesController {
        let storyboardIds = ["authViewController"]
        return PagesController(storyboardIds)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.show()
        let pages = pagesControllerInCode()
//      let pages = pagesControllerInStoryboard()


        var navigationController = UINavigationController(rootViewController: pages)
        // Transparent navigation bar
        navigationController.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.translucent = true
    
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("authViewController")
        self.navigationController?.pushViewController(vc, animated: true)

        // var swipeRight = UISwipeGestureRecognizer(target: pages, action: "previous")
        // swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        // pages.view.addGestureRecognizer(swipeRight)
        // var swipeLeft = UISwipeGestureRecognizer(target: pages, action: "next")
        // swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        // pages.view.addGestureRecognizer(swipeLeft)

        pages.navigationItem.leftBarButtonItem = UIBarButtonItem(title: " ",
            style: .Plain,
            target: pages,
            action: "previous")
        
        pages.navigationItem.rightBarButtonItem = UIBarButtonItem(title: " ",
            style: .Plain,
            target: pages,
            action: "next")
        
        // Border radius on uiview
        pages.view.layer.cornerRadius = 0
        pages.view.layer.masksToBounds = true
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        // U
        let loginButton = UIButton(frame: CGRect(x: 0, y: screenHeight*0.91, width: screenWidth/2, height: 60.0))
        loginButton.backgroundColor = UIColor(rgba: "#1aa8f6")
        loginButton.tintColor = UIColor(rgba: "#fff")
        loginButton.setTitleColor(UIColor(rgba: "#fff"), forState: .Normal)
        loginButton.titleLabel?.font = UIFont(name: "Nunito", size: 16)
        loginButton.setTitle("Log in", forState: .Normal)
        loginButton.layer.cornerRadius = 0
        loginButton.layer.masksToBounds = true
        loginButton.addTarget(self, action: "login:", forControlEvents: UIControlEvents.TouchUpInside)
        pages.view.addSubview(loginButton)
        pages.view.bringSubviewToFront(loginButton)

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
        pages.view.addSubview(signupButton)
        pages.view.bringSubviewToFront(signupButton)

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
