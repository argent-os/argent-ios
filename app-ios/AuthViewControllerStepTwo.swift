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
        
        //        // Set range of string length to exactly 8, the number of characters
        //        lblSubtext.font = UIFont(name: "MyriadPro-Regular", size: 17)
        //        lblSubtext.text = "ARGENT"
        //        lblSubtext.tag = 7579
        //        lblSubtext.font.morphingEffect = .Scale
        //        lblSubtext.font.delegate = self
        //        lblSubtext.font.morphingEnabled = true
        //        lblSubtext.frame.origin.y = screenHeight*0.35 // 20 down from the top
        //        lblSubtext.textAlignment = NSTextAlignment.Center
        //        lblSubtext.textColor = UIColor.whiteColor()
        //        view.addSubview(lblSubtext)
        
    }
    
    //Changing Status Bar
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewDidAppear(animated: Bool) {
        addSubviewWithFade(imageView, parentView: self, duration: 0.8)
    }
}
