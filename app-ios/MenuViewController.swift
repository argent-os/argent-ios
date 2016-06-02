//
//  MenuViewController.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 3/7/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import AnimatedSegmentSwitch

class MenuViewController: UIViewController {

    private let menuSwitch = AnimatedSegmentSwitch()

    private let viewTerminalImageView = UIView()

    private let addPlanImageView = UIView()
    
    private let inviteImageView = UIView()

    private var mainView = UIView()
    
    private var overView = UIView()
    
    @IBAction func indexChanged(sender: AnimatedSegmentSwitch) {
        if(sender.selectedIndex == 0) {

        }
        if(sender.selectedIndex == 1) {

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidAppear(animated: Bool) {
        UIStatusBarStyle.Default
    }
    
    func configure() {
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        mainView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        overView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        
        self.view.addSubview(mainView)
        
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
        mainView.sendSubviewToBack(backgroundImageView)
        mainView.addSubview(backgroundImageView)
        
        menuSwitch.items = ["Main", "Overview"]
        menuSwitch.backgroundColor = UIColor.clearColor()
        menuSwitch.thumbColor = UIColor.clearColor()
        menuSwitch.titleColor = UIColor.lightBlue().colorWithAlphaComponent(0.5)
        menuSwitch.selectedTitleColor = UIColor.mediumBlue()
        menuSwitch.font = UIFont(name: "ArialRoundedMTBold", size: 16)
        menuSwitch.frame = CGRect(x: 50, y: 50, width: screenWidth-100, height: 35.0)
        //autoresizing so it stays at top right (flexible left and flexible bottom margin)
        menuSwitch.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin]
        menuSwitch.bringSubviewToFront(menuSwitch)
        menuSwitch.addTarget(self, action: #selector(HomeViewController.indexChanged(_:)), forControlEvents: .ValueChanged)
        addSubviewWithFade(menuSwitch, parentView: self, duration: 0.8)
        self.view.bringSubviewToFront(menuSwitch)
        self.view.superview?.bringSubviewToFront(menuSwitch)
        
        // Layers create issues with gesture recognizers, add buttons on top of layers to fix this issue
        
        viewTerminalImageView.backgroundColor = UIColor.whiteColor()
        viewTerminalImageView.layer.cornerRadius = 10
        viewTerminalImageView.frame = CGRect(x: 35, y: screenHeight*0.2, width: screenWidth-70, height: 120)
        viewTerminalImageView.contentMode = .ScaleAspectFit
        addSubviewWithShadow(UIColor.lightBlue(), radius: 10.0, offsetX: 0.0, offsetY: 0, opacity: 0.2, parentView: self, childView: viewTerminalImageView)
        let btn1 = UIButton()
        let str1 = NSAttributedString(string: " POS Terminal", attributes: [
            NSForegroundColorAttributeName : UIColor.lightBlue(),
            NSFontAttributeName : UIFont(name: "ArialRoundedMTBold", size: 18)!
        ])
        btn1.setAttributedTitle(str1, forState: .Normal)
        btn1.setBackgroundColor(UIColor.offWhite(), forState: .Highlighted)
        btn1.frame = CGRect(x: 35, y: screenHeight*0.2, width: screenWidth-70, height: 120)
        btn1.setImage(UIImage(named: "IconPOS"), forState: .Normal)
        btn1.setImage(UIImage(named: "IconPOS")?.alpha(0.5), forState: .Highlighted)
        btn1.layer.cornerRadius = 10
        btn1.layer.masksToBounds = true
        btn1.backgroundColor = UIColor.whiteColor()
        btn1.addTarget(self, action: #selector(terminalButtonSelected(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(btn1)
        self.view.bringSubviewToFront(btn1)
        self.view.superview?.bringSubviewToFront(btn1)
        self.view.bringSubviewToFront(btn1)
        
        addPlanImageView.backgroundColor = UIColor.whiteColor()
        addPlanImageView.layer.cornerRadius = 10
        addPlanImageView.frame = CGRect(x: 35, y: screenHeight*0.42, width: screenWidth-70, height: 120)
        addPlanImageView.contentMode = .ScaleAspectFit
        addSubviewWithShadow(UIColor.lightBlue(), radius: 10.0, offsetX: 0.0, offsetY: 0, opacity: 0.2, parentView: self, childView: addPlanImageView)
        let btn2 = UIButton()
        let str2 = NSAttributedString(string: " Add Plan", attributes: [
            NSForegroundColorAttributeName : UIColor.lightBlue(),
            NSFontAttributeName : UIFont(name: "ArialRoundedMTBold", size: 18)!
        ])
        btn2.setAttributedTitle(str2, forState: .Normal)
        btn2.setBackgroundColor(UIColor.offWhite(), forState: .Highlighted)
        btn2.frame = CGRect(x: 35, y: screenHeight*0.42, width: screenWidth-70, height: 120)
        btn2.setImage(UIImage(named: "IconRepeat"), forState: .Normal)
        btn2.setImage(UIImage(named: "IconRepeat")?.alpha(0.5), forState: .Highlighted)
        btn2.layer.cornerRadius = 10
        btn2.layer.masksToBounds = true
        btn2.backgroundColor = UIColor.whiteColor()
        btn2.addTarget(self, action: #selector(planButtonSelected(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(btn2)
        self.view.bringSubviewToFront(btn2)
        self.view.superview?.bringSubviewToFront(btn2)
        self.view.bringSubviewToFront(btn2)
        
        inviteImageView.backgroundColor = UIColor.whiteColor()
        inviteImageView.layer.cornerRadius = 10
        inviteImageView.frame = CGRect(x: 35, y: screenHeight*0.64, width: screenWidth-70, height: 120)
        inviteImageView.contentMode = .ScaleAspectFit
        addSubviewWithShadow(UIColor.lightBlue(), radius: 10.0, offsetX: 0.0, offsetY: 0, opacity: 0.2, parentView: self, childView: inviteImageView)
        let btn3 = UIButton()
        let str3 = NSAttributedString(string: " Invite", attributes: [
            NSForegroundColorAttributeName : UIColor.lightBlue(),
            NSFontAttributeName : UIFont(name: "ArialRoundedMTBold", size: 18)!
        ])
        btn3.setAttributedTitle(str3, forState: .Normal)
        btn3.setBackgroundColor(UIColor.offWhite(), forState: .Highlighted)
        btn3.setImage(UIImage(named: "IconContactBook"), forState: .Normal)
        btn3.setImage(UIImage(named: "IconContactBook")?.alpha(0.5), forState: .Highlighted)
        btn3.frame = CGRect(x: 35, y: screenHeight*0.64, width: screenWidth-70, height: 120)
        btn3.layer.cornerRadius = 10
        btn3.layer.masksToBounds = true
        btn3.backgroundColor = UIColor.whiteColor()
        btn3.addTarget(self, action: #selector(inviteButtonSelected(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(btn3)
        self.view.bringSubviewToFront(btn3)
        self.view.superview?.bringSubviewToFront(btn3)
        self.view.bringSubviewToFront(btn3)
        
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 65))
        // navBar.barTintColor = UIColor(rgba: "#258ff6")
        navBar.barTintColor = UIColor.mediumBlue()
        navBar.tintColor = UIColor.whiteColor()
        navBar.translucent = false
        navBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "ArialRoundedMTBold", size: 18)!
        ]
        //mainView.addSubview(navBar);
        let navItem = UINavigationItem(title: "Main Menu");
        navBar.setItems([navItem], animated: false);
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
    
    private func addBlurView(){
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = CGRectMake(0, 0, screenWidth, screenHeight)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        self.view.insertSubview(blurView, aboveSubview: self.view)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Delegate Methods
    
    // Statusbar
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "menuView") {
            let rootViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("RootViewController"))! as UIViewController
            self.presentViewController(rootViewController, animated: true, completion: nil)
        }
    }
}

extension MenuViewController {
    
    
    
    
}