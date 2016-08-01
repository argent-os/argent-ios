//
//  AuthViewControllerStepTwo.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 8/1/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation

class AuthViewControllerStepTwo: UIPageViewController, UIPageViewControllerDelegate {
    
    let lbl = UILabel()
    
    let lblDetail = UILabel()

    let lblBody = UILabel()

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
        let backgroundView: UIImageView = UIImageView(image: UIImage(named: "BackgroundWalkthroughOne"))
        backgroundView.contentMode = UIViewContentMode.ScaleAspectFill
        backgroundView.frame = self.view.bounds
        self.view!.addSubview(backgroundView)
        
        // Set range of string length to exactly 8, the number of characters
        lblDetail.frame = CGRect(x: 0, y: screenHeight*0.39, width: screenWidth, height: 40)
        lblDetail.tag = 7579
        lblDetail.textAlignment = NSTextAlignment.Center
        lblDetail.textColor = UIColor.whiteColor()
        lblDetail.adjustAttributedString("AUTOMATE RECURRING PAYMENTS", spacing: 4, fontName: "MyriadPro-Regular", fontSize: 13, fontColor: UIColor.whiteColor())
        view.addSubview(lblDetail)
        
        // Set range of string length to exactly 8, the number of characters
        lblBody.frame = CGRect(x: 50, y: screenHeight*0.40, width: screenWidth-100, height: 200)
        lblBody.numberOfLines = 0
        lblBody.alpha = 0.9
        lblBody.adjustAttributedString("Eliminate the hassle of asking for checks and credit card payments on a regular basis.", spacing: 2, fontName: "HelveticaNeue-Light", fontSize: 14, fontColor: UIColor.whiteColor())
        lblBody.tag = 7579
        lblBody.textAlignment = NSTextAlignment.Center
        lblBody.textColor = UIColor.whiteColor()
        view.addSubview(lblBody)
        
    }
    
    //Changing Status Bar
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewDidAppear(animated: Bool) {
        addSubviewWithFade(imageView, parentView: self, duration: 0.8)
    }
}
