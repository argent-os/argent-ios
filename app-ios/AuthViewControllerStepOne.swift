//
//  AuthViewControllerStepOne.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 8/1/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import Shimmer
import Spring

class AuthViewControllerStepOne: UIPageViewController, UIPageViewControllerDelegate {
    
    let lbl = SpringLabel()
    
    let lblDetail = SpringLabel()
    
    let shimmeringView = FBShimmeringView()

    let imageView = SpringImageView()
    
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
        let backgroundView: UIImageView = UIImageView(image: UIImage(named: "BackgroundIntro"))
        backgroundView.contentMode = UIViewContentMode.ScaleAspectFill
        backgroundView.frame = self.view.bounds
//        self.view!.addSubview(backgroundView)
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        let imageName = "LogoOutlineDark"
        let image = UIImage(named: imageName)
        imageView.image = image
        imageView.layer.masksToBounds = true
        imageView.tag = 7577
        imageView.frame = CGRect(x: 0, y: 0, width: 75, height: 75)
        imageView.frame.origin.y = 130
        imageView.frame.origin.x = (self.view.bounds.size.width - imageView.frame.size.width) / 2.0 // centered left to right.
        
        // Set range of string length to exactly 8, the number of characters
        lblDetail.frame = CGRect(x: 0, y: 260, width: screenWidth, height: 40)
        lblDetail.tag = 7579
        lblDetail.textAlignment = NSTextAlignment.Center
        lblDetail.textColor = UIColor.darkBlue()
        lblDetail.adjustAttributedString("Swipe to learn more", spacing: 4, fontName: "SFUIDisplay-Thin", fontSize: 12, fontColor: UIColor.darkBlue())
        
        shimmeringView.frame = CGRect(x: 0, y: 300, width: screenWidth, height: screenHeight*0.85) // shimmeringView.bounds
        shimmeringView.contentView = lblDetail
        shimmeringView.shimmering = true
        
        if self.view.layer.frame.height <= 480.0 {
            lblDetail.frame = CGRect(x: 0, y: 320, width: screenWidth, height: 40)
            shimmeringView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight+70) // shimmeringView.bounds
        } else if self.view.layer.frame.height > 667.0 {
            shimmeringView.frame = CGRect(x: 0, y: 300, width: screenWidth, height: screenHeight*0.88) // shimmeringView.bounds
        }
        
        // Set range of string length to exactly 8, the number of characters
        lbl.frame = CGRect(x: 0, y: 215, width: screenWidth, height: 40)
        lbl.font = UIFont(name: "SFUIText-Regular", size: 23)
        lbl.tag = 7578
        lbl.textAlignment = NSTextAlignment.Center
        lbl.textColor = UIColor.darkBlue()
        lbl.adjustAttributedString(APP_NAME.uppercaseString, spacing: 8, fontName: "SFUIDisplay-Thin", fontSize: 17, fontColor: UIColor.darkBlue())
        
        //        _ = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(AuthViewController.changeText(_:)), userInfo: nil, repeats: true)
        
        //        // Set range of string length to exactly 8, the number of characters
        //        lblSubtext.font = UIFont(name: "SFUIText-Regular", size: 17)
        //        lblSubtext.text = APP_NAME
        //        lblSubtext.tag = 7579
        //        lblSubtext.font.morphingEffect = .Scale
        //        lblSubtext.font.delegate = self
        //        lblSubtext.font.morphingEnabled = true
        //        lblSubtext.frame.origin.y = screenHeight*0.35 // 20 down from the top
        //        lblSubtext.textAlignment = NSTextAlignment.Center
        //        lblSubtext.textColor = UIColor.darkBlue()
        //        view.addSubview(lblSubtext)

    }
    
    //Changing Status Bar
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewDidAppear(animated: Bool) {
        lblDetail.animation = "fadeInUp"
        lblDetail.duration = 1
        lblDetail.animate()
        addSubviewWithFade(lblDetail, parentView: self, duration: 0.3)
        addSubviewWithFade(shimmeringView, parentView: self, duration: 1)

        lbl.animation = "fadeInUp"
        lbl.duration = 1.2
        lbl.animate()
        addSubviewWithFade(lbl, parentView: self, duration: 0.3)
        
        imageView.animation = "fadeInUp"
        imageView.duration = 1
        imageView.animate()
        addSubviewWithFade(imageView, parentView: self, duration: 0.3)
    }
    
    override func viewWillDisappear(animated: Bool) {
        lblDetail.animation = "fadeIn"
        lblDetail.duration = 3
        lblDetail.animateTo()
        
        lbl.animation = "fadeIn"
        lbl.duration = 3
        lbl.animateTo()
        
        imageView.animation = "fadeIn"
        imageView.duration = 3
        imageView.animateTo()
    }
}
