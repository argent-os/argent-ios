//
//  InitializeAuth.swift
//  paykloud-ios
//
//  Created by Sinan Ulkuatam on 2/9/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import VideoSplashKit
import QuartzCore

class AuthViewController: VideoSplashViewController  {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Border radius on uiview
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("authViewController")
        self.navigationController?.pushViewController(vc, animated: true)
//        print(storyboard)
//        print(vc)

        let url = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("nyc", ofType: "mp4")!)
        self.videoFrame = view.frame
        self.fillMode = .ResizeAspectFill
        self.alwaysRepeat = true
        self.sound = false
        self.startTime = 0
        self.duration = 10
        self.alpha = 0.5
        self.backgroundColor = UIColor.blackColor()
        self.contentURL = url
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        // UI
        let imageName = "IconLogo"
        let image = UIImage(named: imageName)
        resizeImage(image!, newSize: CGSize.init(width: 40, height: 40))
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 0, y: screenHeight*0.2, width: 50, height: 50)
        imageView.frame.origin.y = screenHeight*0.25 // 25 down from the top
        imageView.frame.origin.x = (self.view.bounds.size.width - imageView.frame.size.width) / 2.0 // centered left to right.
        view.addSubview(imageView)

        let loginButton = UIButton(frame: CGRect(x: 0, y: screenHeight*0.9, width: screenWidth/2, height: 42.0))
        loginButton.setImage(UIImage(named: "ButtonLogin"), forState: .Normal)
        loginButton.layer.cornerRadius = 4
        loginButton.layer.masksToBounds = true
        loginButton.addTarget(self, action: "login:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(loginButton)
        
        let signupButton = UIButton(frame: CGRect(x: screenWidth*0.5, y: screenHeight*0.9, width: screenWidth/2, height: 42.0))
        signupButton.setImage(UIImage(named: "ButtonSignup"), forState: .Normal)
        signupButton.layer.cornerRadius = 4
        signupButton.layer.masksToBounds = true
        signupButton.addTarget(self, action: "signup:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(signupButton)
        
        let attributedString = NSMutableAttributedString(string: "PayKloud")
        // Set range of string length to exactly 8, the number of characters in PayKloud
        attributedString.addAttribute(NSKernAttributeName, value:   CGFloat(2.0), range: NSRange(location: 0, length: 8))
        attributedString.addAttribute(NSFontAttributeName, value: "Nunito", range: NSRange(location: 0, length: 8)
        )

        let text = UILabel(frame: CGRect(x: 0, y: screenHeight*0.3, width: screenWidth, height: 100.0))
        text.textAlignment = NSTextAlignment.Center
        text.textColor = UIColor.whiteColor()
        text.attributedText = attributedString
        text.font = UIFont (name: "Nunito", size: 30)
        view.addSubview(text)
        
    }

    // Set the ID in the storyboard in order to enable transition!
    func signup(sender:AnyObject!)
    {
        let viewController:SignupViewControllerZero = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SignupViewControllerZero") as! SignupViewControllerZero
        
        self.presentViewController(viewController, animated: true, completion: nil)
        
    }
    
    // Set the ID in the storyboard in order to enable transition!
    func login(sender:AnyObject!)
    {
        let viewController:LoginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        
        self.presentViewController(viewController, animated: true, completion: nil)
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
