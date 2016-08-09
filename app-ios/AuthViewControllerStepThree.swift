//
//  AuthViewControllerStepThree.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 8/1/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation

class AuthViewControllerStepThree: UIPageViewController, UIPageViewControllerDelegate {
    
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
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        let imageName = "IconCustomUsers"
        let image = UIImage(named: imageName)
        imageView.image = image
        imageView.layer.masksToBounds = true
        imageView.tag = 7577
        imageView.frame = CGRect(x: 0, y: 0, width: 130, height: 130)
        imageView.frame.origin.y = 80
        imageView.frame.origin.x = (self.view.bounds.size.width - imageView.frame.size.width) / 2.0 // centered left to right.
        self.view.addSubview(imageView)
        
        // Set range of string length to exactly 8, the number of characters
        lblDetail.frame = CGRect(x: 0, y: 270, width: screenWidth, height: 40)
        lblDetail.tag = 7579
        lblDetail.textAlignment = NSTextAlignment.Center
        lblDetail.textColor = UIColor.whiteColor()
        lblDetail.adjustAttributedString("SEARCH & PAY", spacing: 2, fontName: "MyriadPro-Regular", fontSize: 13, fontColor: UIColor.darkBlue().colorWithAlphaComponent(0.75))
        view.addSubview(lblDetail)
        
        let lblBody = UILabel()
        // Set range of string length to exactly 8, the number of characters
        lblBody.frame = CGRect(x: 90, y: 260, width: screenWidth-180, height: 200)
        lblBody.numberOfLines = 0
        lblBody.alpha = 0.9
        let atrString = adjustAttributedString("Search users and pay them instantly with either Apple Pay or credit card.", spacing: 1, fontName: "MyriadPro-Regular", fontSize: 14, fontColor: UIColor.darkBlue(), lineSpacing: 9.0)
        lblBody.attributedText = atrString
        lblBody.tag = 7579
        lblBody.textAlignment = NSTextAlignment.Center
        view.addSubview(lblBody)
        
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
}

