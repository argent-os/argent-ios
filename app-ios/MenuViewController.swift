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

    private let viewTerminalImageView = UIImageView()

    private let addPlanImageView = UIImageView()
    
    private let inviteImageView = UIImageView()

    private var mainView = UIView()
    
    private var overView = UIView()
    
    @IBAction func indexChanged(sender: AnimatedSegmentSwitch) {
        if(sender.selectedIndex == 0) {
            // remove previous views
            UIView.animateWithDuration(0.2, animations: {
                self.viewTerminalImageView.alpha = 1.0
                }, completion: {(value: Bool) in
                    addSubviewWithFade(self.viewTerminalImageView, parentView: self, duration: 0.8)
            })
            UIView.animateWithDuration(0.7, animations: {
                self.addPlanImageView.alpha = 1.0
                }, completion: {(value: Bool) in
                    addSubviewWithFade(self.addPlanImageView, parentView: self, duration: 0.8)
            })
            UIView.animateWithDuration(1.2, animations: {
                self.inviteImageView.alpha = 1.0
                }, completion: {(value: Bool) in
                    addSubviewWithFade(self.inviteImageView, parentView: self, duration: 0.8)
            })
            // add views
            UIView.animateWithDuration(0.2, animations: {
                self.viewTerminalImageView.alpha = 1.0
                }, completion: {(value: Bool) in
                    addSubviewWithFade(self.viewTerminalImageView, parentView: self, duration: 0.8)
            })
            UIView.animateWithDuration(0.7, animations: {
                self.addPlanImageView.alpha = 1.0
                }, completion: {(value: Bool) in
                    addSubviewWithFade(self.addPlanImageView, parentView: self, duration: 0.8)
            })
            UIView.animateWithDuration(1.2, animations: {
                self.inviteImageView.alpha = 1.0
                }, completion: {(value: Bool) in
                    addSubviewWithFade(self.inviteImageView, parentView: self, duration: 0.8)
            })
        }
        if(sender.selectedIndex == 1) {
            // remove previous views
            UIView.animateWithDuration(0.2, animations: {
                self.viewTerminalImageView.alpha = 0.0
                }, completion: {(value: Bool) in
                self.viewTerminalImageView.removeFromSuperview()
            })
            UIView.animateWithDuration(0.7, animations: {
                self.addPlanImageView.alpha = 0.0
                }, completion: {(value: Bool) in
                    self.addPlanImageView.removeFromSuperview()
            })
            UIView.animateWithDuration(1.2, animations: {
                self.inviteImageView.alpha = 0.0
                }, completion: {(value: Bool) in
                    self.inviteImageView.removeFromSuperview()
            })
            // add views
            UIView.animateWithDuration(0.2, animations: {
                self.viewTerminalImageView.alpha = 1.0
                }, completion: {(value: Bool) in
                    addSubviewWithFade(self.viewTerminalImageView, parentView: self, duration: 0.8)
            })
            UIView.animateWithDuration(0.7, animations: {
                self.addPlanImageView.alpha = 1.0
                }, completion: {(value: Bool) in
                    addSubviewWithFade(self.addPlanImageView, parentView: self, duration: 0.8)
            })
            UIView.animateWithDuration(1.2, animations: {
                self.inviteImageView.alpha = 1.0
                }, completion: {(value: Bool) in
                    addSubviewWithFade(self.inviteImageView, parentView: self, duration: 0.8)
            })
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
        
        menuSwitch.items = ["Main", "Overview", "History"]
        menuSwitch.backgroundColor = UIColor.clearColor()
        menuSwitch.thumbColor = UIColor(rgba: "#00b5ff")
        menuSwitch.titleColor = UIColor.lightBlue().colorWithAlphaComponent(0.5)
        menuSwitch.selectedTitleColor = UIColor.whiteColor()
        menuSwitch.font = UIFont(name: "ArialRoundedMTBold", size: 16)
        menuSwitch.frame = CGRect(x: 35, y: 50, width: screenWidth-70, height: 35.0)
        //autoresizing so it stays at top right (flexible left and flexible bottom margin)
        menuSwitch.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin]
        menuSwitch.bringSubviewToFront(menuSwitch)
        menuSwitch.addTarget(self, action: #selector(HomeViewController.indexChanged(_:)), forControlEvents: .ValueChanged)
        addSubviewWithFade(menuSwitch, parentView: self, duration: 0.8)
        self.view.bringSubviewToFront(menuSwitch)
        self.view.superview?.bringSubviewToFront(menuSwitch)
        
        viewTerminalImageView.image = UIImage(named: "IconTerminal")
        viewTerminalImageView.frame = CGRect(x: 35, y: screenHeight*0.2, width: screenWidth-70, height: 150)
        viewTerminalImageView.contentMode = .ScaleAspectFit
        let gestureRecognizerTerminal = UITapGestureRecognizer(target: self, action: #selector(terminalButtonSelected(_:)))
        viewTerminalImageView.addGestureRecognizer(gestureRecognizerTerminal)
        viewTerminalImageView.userInteractionEnabled = true
        
        addPlanImageView.image = UIImage(named: "IconAddPlan")
        addPlanImageView.frame = CGRect(x: 35, y: screenHeight*0.4, width: screenWidth-70, height: 150)
        addPlanImageView.contentMode = .ScaleAspectFit
        let gestureRecognizerPlan = UITapGestureRecognizer(target: self, action: #selector(planButtonSelected(_:)))
        addPlanImageView.addGestureRecognizer(gestureRecognizerPlan)
        addPlanImageView.userInteractionEnabled = true
        
        inviteImageView.image = UIImage(named: "IconInvite")
        inviteImageView.frame = CGRect(x: 35, y: screenHeight*0.6, width: screenWidth-70, height: 150)
        inviteImageView.contentMode = .ScaleAspectFit
        let gestureRecognizerInvite = UITapGestureRecognizer(target: self, action: #selector(inviteButtonSelected(_:)))
        inviteImageView.addGestureRecognizer(gestureRecognizerInvite)
        inviteImageView.userInteractionEnabled = true
        
        Timeout(0.2) {
            addSubviewWithFade(self.viewTerminalImageView, parentView: self, duration: 0.8)
        }
        Timeout(0.7) {
            addSubviewWithFade(self.addPlanImageView, parentView: self, duration: 0.8)
        }
        Timeout(1.2) {
            addSubviewWithFade(self.inviteImageView, parentView: self, duration: 0.8)
        }
        
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
    
    internal func terminalButtonSelected(sender: AnyObject) {
        viewTerminalImageView.highlighted = true
        self.performSegueWithIdentifier("chargeView", sender: self)
    }
    
    internal func planButtonSelected(sender: AnyObject) {
        addPlanImageView.highlighted = true
        self.performSegueWithIdentifier("addPlanView", sender: self)
    }
    
    internal func inviteButtonSelected(sender: AnyObject) {
        inviteImageView.highlighted = true
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