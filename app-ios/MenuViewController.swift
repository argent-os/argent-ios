//
//  MenuViewController.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 3/7/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import DGRunkeeperSwitch

class MenuViewController: UIViewController {
    
    private let menuSwitch = DGRunkeeperSwitch(leftTitle: "Main", rightTitle: "Admin")

    private let viewTerminalImageView = UIImageView()

    private let addPlanImageView = UIImageView()
    
    private let inviteImageView = UIImageView()

    @IBAction func indexChanged(sender: DGRunkeeperSwitch) {
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
        
        Timeout(0.0) {
            addSubviewWithBounce(self.viewTerminalImageView, parentView: self)
        }
        Timeout(0.1) {
            addSubviewWithBounce(self.addPlanImageView, parentView: self)
        }
        Timeout(0.2) {
            addSubviewWithBounce(self.inviteImageView, parentView: self)
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        viewTerminalImageView.removeFromSuperview()
        addPlanImageView.removeFromSuperview()
        inviteImageView.removeFromSuperview()
    }
    
    func configure() {
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
        
        menuSwitch.backgroundColor = UIColor.clearColor()
        menuSwitch.selectedBackgroundColor = UIColor.lightBlue()
        menuSwitch.titleColor = UIColor.lightBlue()
        menuSwitch.selectedTitleColor = UIColor.whiteColor()
        menuSwitch.titleFont = UIFont.systemFontOfSize(12)
        menuSwitch.frame = CGRect(x: 70, y: 50, width: screenWidth-140, height: 35.0)
        //autoresizing so it stays at top right (flexible left and flexible bottom margin)
        menuSwitch.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin]
        menuSwitch.bringSubviewToFront(menuSwitch)
        menuSwitch.addTarget(self, action: #selector(HomeViewController.indexChanged(_:)), forControlEvents: .ValueChanged)
        self.view.addSubview(menuSwitch)
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
        
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 65))
        // navBar.barTintColor = UIColor(rgba: "#258ff6")
        navBar.barTintColor = UIColor.mediumBlue()
        navBar.tintColor = UIColor.whiteColor()
        navBar.translucent = false
        navBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "Avenir-Book", size: 18)!
        ]
        //self.view.addSubview(navBar);
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