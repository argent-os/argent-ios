//
//  AuthViewControllerStepFour.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 8/1/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import Spring

class AuthViewControllerStepFour: UIPageViewController, UIPageViewControllerDelegate {
    
    let lbl = UILabel()
    
    let lblDetail = SpringLabel()
    
    let lblBody = SpringLabel()
    
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
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        let imageName = "BackgroundChef"
        let image = UIImage(named: imageName)
        imageView.image = image
        imageView.contentMode = .ScaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.tag = 7577
        imageView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight*0.5)
        imageView.frame.origin.y = 0
        self.view.addSubview(imageView)
        
        // Set range of string length to exactly 8, the number of characters
        lblDetail.frame = CGRect(x: 0, y: screenHeight*0.5+20, width: screenWidth, height: 40)
        lblDetail.tag = 7579
        lblDetail.textAlignment = NSTextAlignment.Center
        lblDetail.textColor = UIColor.whiteColor()
        lblDetail.adjustAttributedString("BUILT FOR YOU", spacing: 2, fontName: "SFUIText-SemiBold", fontSize: 13, fontColor: UIColor.darkBlue().colorWithAlphaComponent(0.75))
        
        // Set range of string length to exactly 8, the number of characters
        lblBody.frame = CGRect(x: 20, y: screenHeight*0.5+20, width: screenWidth-40, height: 170)
        lblBody.numberOfLines = 0
        lblBody.alpha = 0.9
        let atrText = adjustAttributedString("The business owner.  We promise to deliver satisfaction and help your business grow.", spacing: 1, fontName: "SFUIText-Light", fontSize: 14, fontColor: UIColor.darkBlue(), lineSpacing: 9.0, alignment: .Center)
        lblBody.attributedText = atrText
        lblBody.tag = 7579
        lblBody.textAlignment = NSTextAlignment.Center
        
        // iphone6+ check
        if self.view.layer.frame.height > 667.0 {
            lblBody.frame = CGRect(x: 90, y: 280, width: screenWidth-180, height: 200)
            lblDetail.frame = CGRect(x: 0, y: 290, width: screenWidth, height: 40)
        } else if self.view.layer.frame.height <= 480.0 {
            lblBody.frame = CGRect(x: 90, y: 235, width: screenWidth-180, height: 200)
            lblDetail.frame = CGRect(x: 0, y: 250, width: screenWidth, height: 40)
        }
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
        
        lblBody.animation = "fadeInUp"
        lblBody.duration = 1.2
        lblBody.animate()
        addSubviewWithFade(lblBody, parentView: self, duration: 0.3)
    }
    
    override func viewWillDisappear(animated: Bool) {
        lblDetail.animation = "fadeInUp"
        lblDetail.duration = 3
        lblDetail.animateTo()
        
        lblBody.animation = "fadeInUp"
        lblBody.duration = 1
        lblBody.animateTo()
    }
}