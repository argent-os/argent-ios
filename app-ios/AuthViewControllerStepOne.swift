//
//  AuthViewControllerStepOne.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 8/1/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import Shimmer

class AuthViewControllerStepOne: UIPageViewController, UIPageViewControllerDelegate {
    
    let lbl = UILabel()
    
    let lblDetail = UILabel()
    
    let imageView = UIImageView()
    
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
        self.view.addSubview(imageView)
        
        // Set range of string length to exactly 8, the number of characters
        lblDetail.frame = CGRect(x: 0, y: 280, width: screenWidth, height: 40)
        lblDetail.tag = 7579
        lblDetail.textAlignment = NSTextAlignment.Center
        lblDetail.textColor = UIColor.darkBlue()
        lblDetail.adjustAttributedString("SWIPE TO LEARN MORE", spacing: 4, fontName: "SFUIText-Regular", fontSize: 13, fontColor: UIColor.darkBlue())
        view.addSubview(lblDetail)
        
        let shimmeringView = FBShimmeringView()
        shimmeringView.frame = CGRect(x: 0, y: 300, width: screenWidth, height: screenHeight*0.88) // shimmeringView.bounds
        shimmeringView.contentView = lblDetail
        shimmeringView.shimmering = true
        addSubviewWithFade(shimmeringView, parentView: self, duration: 1)
        addSubviewWithFade(lblDetail, parentView: self, duration: 1)
        
        if self.view.layer.frame.height <= 480.0 {
            lblDetail.frame = CGRect(x: 0, y: 320, width: screenWidth, height: 40)
            shimmeringView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight+70) // shimmeringView.bounds
        }
        
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
    }
}
