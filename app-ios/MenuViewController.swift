//
//  MenuViewController.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 3/7/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import TransitionTreasury
import TransitionAnimation
import Shimmer
import KeychainSwift

class MenuViewController: UIViewController {

    private let viewTerminalImageView = UIView()

    private let addPlanImageView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMainMenu()
    }
    
    func configureMainMenu() {
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
        visualEffectView.frame = CGRectMake(0, 0, screenWidth, screenHeight)
        let backgroundImageView = UIImageView(image: UIImage(), highlightedImage: nil)
        backgroundImageView.backgroundColor = UIColor.offWhite()
        backgroundImageView.frame = CGRectMake(0, 0, screenWidth, screenHeight)
        backgroundImageView.contentMode = .ScaleAspectFill
        backgroundImageView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        backgroundImageView.layer.masksToBounds = true
        backgroundImageView.clipsToBounds = true
        // backgroundImageView.addSubview(visualEffectView)
        self.view.sendSubviewToBack(backgroundImageView)
        self.view.addSubview(backgroundImageView)
        
        let btn1 = UIButton()
        let str1 = NSAttributedString(string: "Accept Payment", attributes: [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "MyriadPro-Regular", size: 15)!
        ])
        btn1.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
        btn1.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
        btn1.contentHorizontalAlignment = .Left
        btn1.setAttributedTitle(str1, forState: .Normal)
        btn1.setBackgroundColor(UIColor.deepBlue().lighterColor(), forState: .Highlighted)
        btn1.frame = CGRect(x: 15, y: 30, width: screenWidth-30, height: 60)
        btn1.layer.cornerRadius = 3
        btn1.layer.masksToBounds = true
        btn1.layer.borderColor = UIColor.lightBlue().colorWithAlphaComponent(0.2).CGColor
        btn1.layer.borderWidth = 1
        btn1.backgroundColor = UIColor.deepBlue()
        btn1.addTarget(self, action: #selector(terminalButtonSelected(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(btn1)
        self.view.bringSubviewToFront(btn1)
        self.view.superview?.bringSubviewToFront(btn1)
        self.view.bringSubviewToFront(btn1)
//        btn1.setImage(UIImage(named: "IconCard"), inFrame: CGRectMake(18, 18, 64, 64), forState: .Normal)
//        btn1.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: btn1.frame.width-20, bottom: 0.0, right: 10.0)

        let btn2 = UIButton()
        let str2 = NSAttributedString(string: "Create Plan", attributes: [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "MyriadPro-Regular", size: 15)!
            ])
        btn2.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
        btn2.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
        btn2.contentHorizontalAlignment = .Left
        btn2.setAttributedTitle(str2, forState: .Normal)
        btn2.setBackgroundColor(UIColor.oceanBlue().lighterColor(), forState: .Highlighted)
        btn2.frame = CGRect(x: 15, y: 100, width: screenWidth-30, height: 60)
        btn2.layer.cornerRadius = 3
        btn2.layer.masksToBounds = true
        btn2.layer.borderColor = UIColor.lightBlue().colorWithAlphaComponent(0.2).CGColor
        btn2.layer.borderWidth = 1
        btn2.backgroundColor = UIColor.oceanBlue()
        btn2.addTarget(self, action: #selector(planButtonSelected(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(btn2)
        self.view.bringSubviewToFront(btn2)
        self.view.superview?.bringSubviewToFront(btn2)
        self.view.bringSubviewToFront(btn2)

        setupNav()

    }
    
    func setupNav() {
        
        // NAV
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        //let screenHeight = screen.size.height
        
        self.navigationItem.title = "Menu"
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.oceanBlue()
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "MyriadPro-Regular", size: 17)!
        ]
        
    }
    
    func terminalButtonSelected(sender: AnyObject) {
        print("charge selected")
        self.performSegueWithIdentifier("chargeView", sender: self)
    }
    
    func planButtonSelected(sender: AnyObject) {
        print("plan selected")
        self.performSegueWithIdentifier("addPlanView", sender: self)
    }
    
    func inviteButtonSelected(sender: AnyObject) {
        self.performSegueWithIdentifier("addCustomerView", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Delegate Methods
    
    //Changing Status Bar
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    //Changing Status Bar
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "menuView") {
            let rootViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("RootViewController"))! as UIViewController
            self.presentViewController(rootViewController, animated: true, completion: nil)
        }
    }
}

extension MenuViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let ges = gestureRecognizer as? UIPanGestureRecognizer {
            return ges.velocityInView(ges.view).y != 0
        }
        return false
    }
}