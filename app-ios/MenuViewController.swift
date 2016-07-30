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

class MenuViewController: UIViewController, ModalTransitionDelegate {

    var tr_presentTransition: TRViewControllerTransitionDelegate?

    private let viewTerminalImageView = UIView()

    private let addPlanImageView = UIView()
    
    private let inviteImageView = UIView()
    
    let selectedCellLabel = UILabel()
    
    let swipeMenuSelectionLabel = UILabel()
    
    let swipeArrowImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMainMenu()
    }
    
    func interactiveTransition(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .Began:
            guard sender.velocityInView(view).y > 0 else {
                break
            }
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MenuDetailViewController") as! MenuDetailViewController
            vc.modalDelegate = self
            tr_presentViewController(vc, method: TRPresentTransitionMethod.Scanbot(present: sender, dismiss: vc.dismissGestureRecognizer), completion: {
                print("Present finished")
            })
        default: break
        }
    }
    
    
    // modal callback
    func modalViewControllerDismiss(interactive interactive: Bool, callbackData data: AnyObject?) {
        
        tr_dismissViewController(interactive: interactive, completion: nil)
    }
    
    func configureMainMenu() {
        
        // set up pan gesture recognizers
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.interactiveTransition(_:)))
        pan.delegate = self
        view.addGestureRecognizer(pan)
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
//        self.view.frame = CGRect(x: 0, y: 80, width: screenWidth, height: screenHeight)
//        self.view.backgroundColor = UIColor.whiteColor()
//        self.view.layer.shadowOffset = CGSizeMake(0, 0)
//        self.view.layer.shadowColor = UIColor.clearColor().CGColor
//        self.view.layer.cornerRadius = 0.0
//        self.view.layer.shadowRadius = 0.0
//        self.view.layer.shadowOpacity = 0.00
//        
//        let headerView = UIImageView()
//        headerView.image = UIImage(named: "BackgroundSwipeDown")
//        headerView.contentMode = .ScaleAspectFill
//        headerView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 140)
//        self.view.addSubview(headerView)
//        self.view.sendSubviewToBack(headerView)
        
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
        
        // Layers create issues with gesture recognizers, add buttons on top of layers to fix this issue
        
        viewTerminalImageView.backgroundColor = UIColor.whiteColor()
        viewTerminalImageView.layer.cornerRadius = 5
        viewTerminalImageView.frame = CGRect(x: 35, y: screenHeight*0.1, width: screenWidth-70, height: 120)
        viewTerminalImageView.contentMode = .ScaleAspectFit
        addSubviewWithFade(viewTerminalImageView, parentView: self, duration: 0.5)
        
        let btn1 = CenteredButton()
        let str1 = NSAttributedString(string: "  Point of Sale Terminal", attributes: [
            NSForegroundColorAttributeName : UIColor.lightBlue(),
            NSFontAttributeName : UIFont(name: "MyriadPro-Regular", size: 17)!
        ])
        btn1.setAttributedTitle(str1, forState: .Normal)
        btn1.setBackgroundColor(UIColor.offWhite().lighterColor(), forState: .Highlighted)
        btn1.setImage(UIImage(named: "IconHoldCard")?.alpha(0.5), forState: .Highlighted)
        btn1.frame = CGRect(x: 35, y: screenHeight*0.1, width: screenWidth-70, height: 120)
        btn1.layer.cornerRadius = 5
        btn1.layer.masksToBounds = true
        btn1.layer.borderColor = UIColor.lightBlue().colorWithAlphaComponent(0.2).CGColor
        btn1.layer.borderWidth = 1
        btn1.backgroundColor = UIColor.whiteColor()
        btn1.addTarget(self, action: #selector(terminalButtonSelected(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(btn1)
        self.view.bringSubviewToFront(btn1)
        self.view.superview?.bringSubviewToFront(btn1)
        self.view.bringSubviewToFront(btn1)
        btn1.setImage(UIImage(named: "IconHoldCard"), inFrame: CGRectMake(18, 18, 64, 64), forState: .Normal)

        addPlanImageView.backgroundColor = UIColor.whiteColor()
        addPlanImageView.layer.cornerRadius = 5
        addPlanImageView.frame = CGRect(x: 35, y: screenHeight*0.32, width: screenWidth-70, height: 120)
        addPlanImageView.contentMode = .ScaleAspectFit
        addSubviewWithFade(addPlanImageView, parentView: self, duration: 0.7)
        
        let btn2 = CenteredButton()
        btn2.imageEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        let str2 = NSAttributedString(string: "  Create Plan", attributes: [
            NSForegroundColorAttributeName : UIColor.lightBlue(),
            NSFontAttributeName : UIFont(name: "MyriadPro-Regular", size: 17)!
        ])
        btn2.setAttributedTitle(str2, forState: .Normal)
        btn2.setBackgroundColor(UIColor.offWhite().lighterColor(), forState: .Highlighted)
        btn2.setImage(UIImage(named: "IconWand")?.alpha(0.5), forState: .Highlighted)
        btn2.frame = CGRect(x: 35, y: screenHeight*0.32, width: screenWidth-70, height: 120)
        btn2.layer.cornerRadius = 5
        btn2.layer.masksToBounds = true
        btn2.layer.borderColor = UIColor.lightBlue().colorWithAlphaComponent(0.2).CGColor
        btn2.layer.borderWidth = 1
        btn2.backgroundColor = UIColor.whiteColor()
        btn2.addTarget(self, action: #selector(planButtonSelected(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(btn2)
        self.view.bringSubviewToFront(btn2)
        self.view.superview?.bringSubviewToFront(btn2)
        self.view.bringSubviewToFront(btn2)
        btn2.setImage(UIImage(named: "IconWand"), inFrame: CGRectMake(18, 18, 64, 64), forState: .Normal)

        inviteImageView.backgroundColor = UIColor.whiteColor()
        inviteImageView.layer.cornerRadius = 5
        inviteImageView.frame = CGRect(x: 35, y: screenHeight*0.54, width: screenWidth-70, height: 120)
        inviteImageView.contentMode = .ScaleAspectFit
        addSubviewWithFade(inviteImageView, parentView: self, duration: 1)
        
        let btn3 = CenteredButton()
        let str3 = NSAttributedString(string: "  Invite User", attributes: [
            NSForegroundColorAttributeName : UIColor.lightBlue(),
            NSFontAttributeName : UIFont(name: "MyriadPro-Regular", size: 17)!
        ])
        btn3.setAttributedTitle(str3, forState: .Normal)
        btn3.setBackgroundColor(UIColor.offWhite().lighterColor(), forState: .Highlighted)
        btn3.setImage(UIImage(named: "LogoOutlineDark")?.alpha(0.5), forState: .Highlighted)
        btn3.frame = CGRect(x: 35, y: screenHeight*0.54, width: screenWidth-70, height: 120)
        btn3.layer.cornerRadius = 5
        btn3.layer.masksToBounds = true
        btn3.layer.borderColor = UIColor.lightBlue().colorWithAlphaComponent(0.2).CGColor
        btn3.layer.borderWidth = 1
        btn3.backgroundColor = UIColor.whiteColor()
        btn3.addTarget(self, action: #selector(inviteButtonSelected(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(btn3)
        self.view.bringSubviewToFront(btn3)
        self.view.superview?.bringSubviewToFront(btn3)
        self.view.bringSubviewToFront(btn3)
        btn3.setImage(UIImage(named: "LogoOutlineDark"), inFrame: CGRectMake(18, 18, 64, 64), forState: .Normal)

        setupNav()

    }
    
    func setupNav() {
        
        // NAV
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        //let screenHeight = screen.size.height
        
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.offWhite()
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.lightBlue(),
            NSFontAttributeName: UIFont(name: "ArialRoundedMTBold", size: 16)!
        ]
        
        let shimmeringView: FBShimmeringView = FBShimmeringView()
        swipeMenuSelectionLabel.text = "Swipe down to view more"
        swipeMenuSelectionLabel.textAlignment = .Center
        swipeMenuSelectionLabel.textColor = UIColor.lightBlue()
        swipeMenuSelectionLabel.font = UIFont(name: "MyriadPro-Regular", size: 14)!
        swipeMenuSelectionLabel.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 15) // shimmeringView.bounds
        
        shimmeringView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 15) // shimmeringView.bounds
        shimmeringView.contentView = swipeMenuSelectionLabel
        shimmeringView.shimmering = true
        addSubviewWithFade(shimmeringView, parentView: self, duration: 1)
        addSubviewWithFade(swipeMenuSelectionLabel, parentView: self, duration: 1)
        
        swipeArrowImageView.image = UIImage(named: "ic_arrow_down_gray")
        swipeArrowImageView.frame = CGRect(x: 0, y: 20, width: screenWidth, height: 20) // shimmeringView.bounds
        swipeArrowImageView.contentMode = .ScaleAspectFit
        addSubviewWithFade(swipeArrowImageView, parentView: self, duration: 1)
        
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