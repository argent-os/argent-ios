//
//  MenuViewController.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 3/7/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import CircleMenu

class MenuViewController: UIViewController, CircleMenuDelegate {

    
    let circleMenuButton = CircleMenu(
        frame: CGRect(x: 0, y: 0, width: 85, height: 85),
        normalIcon:"IconMenu",
        selectedIcon:"IconCloseLight",
        buttonsCount: 3,
        duration: 0.5,
        distance: 140)
    
    let colors = [UIColor.redColor(), UIColor.grayColor(), UIColor.greenColor(), UIColor.purpleColor()]
    let items: [(icon: String, color: UIColor)] = [
        ("ic_card_light", UIColor.whiteColor()),        
        ("ic_repeat_light", UIColor.whiteColor()),
        ("ic_paper_plane_light", UIColor.whiteColor()),
//        ("ic_coinbag_light", UIColor.whiteColor()),
//        ("ic_link_light", UIColor.whiteColor()),
//        ("ic_paper_light", UIColor.whiteColor()),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
        visualEffectView.frame = CGRectMake(0, 0, screenWidth, screenHeight)
        let backgroundImageView = UIImageView(image: UIImage(), highlightedImage: nil)
        backgroundImageView.backgroundColor = UIColor.mediumBlue()
        backgroundImageView.frame = CGRectMake(0, 0, screenWidth, screenHeight)
        backgroundImageView.contentMode = .ScaleAspectFill
        backgroundImageView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        backgroundImageView.layer.masksToBounds = true
        backgroundImageView.clipsToBounds = true
        self.view.addSubview(backgroundImageView)
//        backgroundImageView.addSubview(visualEffectView)
        self.view.sendSubviewToBack(backgroundImageView)
        self.view.addSubview(backgroundImageView)
        
//        self.view.backgroundColor = UIColor.mediumBlue()
        
//        circleMenuButton.backgroundColor = UIColor.clearColor()
        circleMenuButton.backgroundColor = UIColor.darkBlue()
        circleMenuButton.delegate = self
        circleMenuButton.center = self.view.center
        circleMenuButton.layer.cornerRadius = circleMenuButton.frame.size.width / 2.0
        circleMenuButton.layer.borderColor = UIColor(rgba: "#fff3").CGColor
        circleMenuButton.layer.borderWidth = 1
        view.addSubview(circleMenuButton)
        
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 65))
//        navBar.barTintColor = UIColor(rgba: "#258ff6")
        navBar.barTintColor = UIColor.mediumBlue()
        navBar.tintColor = UIColor.whiteColor()
        navBar.translucent = false
        navBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "Avenir-Book", size: 18)!
        ]
        self.view.addSubview(navBar);
        let navItem = UINavigationItem(title: "Main Menu");
        navBar.setItems([navItem], animated: false);
        
    }
    
    override func viewDidAppear(animated: Bool) {
        UIStatusBarStyle.Default
        circleMenuButton.sendActionsForControlEvents(.TouchUpInside)
        if(Int(circleMenuButton.state.rawValue) == 0) {
            circleMenuButton.sendActionsForControlEvents(.TouchUpInside)
        }
    }
    
    func addBlurView(){
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
    
    // MARK: CircleMenu Delegate

    func circleMenu(circleMenu: CircleMenu, willDisplay circleMenuButton: CircleMenuButton, atIndex: Int) {
        //        circleMenuButton.backgroundColor = items[atIndex].color
        circleMenuButton.backgroundColor = UIColor.darkBlue()
        circleMenuButton.layer.borderColor = UIColor(rgba: "#fff3").CGColor
        circleMenuButton.layer.borderWidth = 1
        circleMenuButton.setImage(UIImage(imageLiteral: items[atIndex].icon), forState: .Normal)

        // set highlighted image
        let highlightedImage  = UIImage(imageLiteral: items[atIndex].icon).imageWithRenderingMode(.AlwaysTemplate)
        circleMenuButton.setImage(highlightedImage, forState: .Highlighted)
        circleMenuButton.tintColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.3)
    }
    
    func circleMenu(circleMenu: CircleMenu, buttonWillSelected circleMenuButton: CircleMenuButton, atIndex: Int) {
        circleMenuButton.backgroundColor = items[atIndex].color
    }
    
    func circleMenu(circleMenu: CircleMenu, buttonDidSelected circleMenuButton: CircleMenuButton, atIndex: Int) {
        circleMenuButton.backgroundColor = items[atIndex].color
        
        if atIndex == 0 {
            self.performSegueWithIdentifier("chargeView", sender: self)
        }
        if atIndex == 1 {
            self.performSegueWithIdentifier("addPlanView", sender: self)
        }
        if atIndex == 2 {
            self.performSegueWithIdentifier("addCustomerView", sender: self)
        }
    }
    
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