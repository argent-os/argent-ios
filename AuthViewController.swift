//
//  InitializeAuth.swift
//  paykloud-ios
//
//  Created by Sinan Ulkuatam on 2/9/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import VideoSplashKit

class AuthViewController: VideoSplashViewController  {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("authViewController")
        self.navigationController?.pushViewController(vc, animated: true)
        print(storyboard)
        print(vc)

        let url = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("nyc", ofType: "mp4")!)
        self.videoFrame = view.frame
        self.fillMode = .ResizeAspectFill
        self.alwaysRepeat = true
        self.sound = true
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
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 0, y: screenHeight*0.2, width: 50, height: 50)
        imageView.frame.origin.y = screenHeight*0.25 // 25 down from the top
        imageView.frame.origin.x = (self.view.bounds.size.width - imageView.frame.size.width) / 2.0 // centered left to right.
        view.addSubview(imageView)

        let btn1 = UIButton(frame: CGRect(x: 0, y: screenHeight*0.9, width: screenWidth/2, height: 42.0))
        btn1.setImage(UIImage(named: "ButtonLogin"), forState: .Normal)
        btn1.layer.cornerRadius = 4
        btn1.layer.masksToBounds = true
        btn1.addTarget(self, action: "login:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(btn1)
        
        let btn2 = UIButton(frame: CGRect(x: screenWidth*0.5, y: screenHeight*0.9, width: screenWidth/2, height: 42.0))
        btn2.setImage(UIImage(named: "ButtonSignup"), forState: .Normal)
        btn2.layer.cornerRadius = 4
        btn2.layer.masksToBounds = true
        btn2.addTarget(self, action: "signup:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(btn2)
        
        let attributedString = NSMutableAttributedString(string: "PayKloud")
        // Set range of string length to exactly 8, the number of characters in PayKloud
        attributedString.addAttribute(NSKernAttributeName, value:   CGFloat(2.0), range: NSRange(location: 0, length: 8))
        
        let text = UILabel(frame: CGRect(x: 0, y: screenHeight*0.3, width: screenWidth, height: 100.0))
        text.textAlignment = NSTextAlignment.Center
        text.textColor = UIColor.whiteColor()
        text.attributedText = attributedString
        text.font = UIFont (name: "Nunito", size: 30)
        view.addSubview(text)
        
    }

    func signup(sender:AnyObject!)
    {
        let viewController:SignupViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SignupViewController") as! SignupViewController
        
        self.presentViewController(viewController, animated: true, completion: nil)
        
    }
    
    func login(sender:AnyObject!)
    {
        let viewController:LoginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}
