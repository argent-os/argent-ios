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
            guard sender.translationInView(view).y > 0 else {
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
        
        // remove view shadow
        let maskView = UIView()
        maskView.backgroundColor = UIColor.offWhite()
        maskView.frame = CGRect(x: 0, y: -30, width: screenWidth, height: 60)
        self.view.addSubview(maskView)
        
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
        viewTerminalImageView.layer.cornerRadius = 10
        viewTerminalImageView.frame = CGRect(x: 35, y: screenHeight*0.1, width: screenWidth-70, height: 120)
        viewTerminalImageView.contentMode = .ScaleAspectFit
        addSubviewWithShadow(UIColor.lightBlue(), radius: 10.0, offsetX: 0.0, offsetY: 0, opacity: 0.2, parentView: self, childView: viewTerminalImageView)
        let btn1 = UIButton()
        let str1 = NSAttributedString(string: "  POS Terminal", attributes: [
            NSForegroundColorAttributeName : UIColor.lightBlue(),
            NSFontAttributeName : UIFont(name: "ArialRoundedMTBold", size: 18)!
        ])
        btn1.setAttributedTitle(str1, forState: .Normal)
        btn1.setBackgroundColor(UIColor.offWhite(), forState: .Highlighted)
        btn1.frame = CGRect(x: 35, y: screenHeight*0.1, width: screenWidth-70, height: 120)
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
        addPlanImageView.frame = CGRect(x: 35, y: screenHeight*0.32, width: screenWidth-70, height: 120)
        addPlanImageView.contentMode = .ScaleAspectFit
        addSubviewWithShadow(UIColor.lightBlue(), radius: 10.0, offsetX: 0.0, offsetY: 0, opacity: 0.2, parentView: self, childView: addPlanImageView)
        let btn2 = UIButton()
        let str2 = NSAttributedString(string: "  Add Plan", attributes: [
            NSForegroundColorAttributeName : UIColor.lightBlue(),
            NSFontAttributeName : UIFont(name: "ArialRoundedMTBold", size: 18)!
        ])
        btn2.setAttributedTitle(str2, forState: .Normal)
        btn2.setBackgroundColor(UIColor.offWhite(), forState: .Highlighted)
        btn2.frame = CGRect(x: 35, y: screenHeight*0.32, width: screenWidth-70, height: 120)
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
        inviteImageView.frame = CGRect(x: 35, y: screenHeight*0.54, width: screenWidth-70, height: 120)
        inviteImageView.contentMode = .ScaleAspectFit
        addSubviewWithShadow(UIColor.lightBlue(), radius: 10.0, offsetX: 0.0, offsetY: 0, opacity: 0.2, parentView: self, childView: inviteImageView)
        let btn3 = UIButton()
        let str3 = NSAttributedString(string: "  Invite", attributes: [
            NSForegroundColorAttributeName : UIColor.lightBlue(),
            NSFontAttributeName : UIFont(name: "ArialRoundedMTBold", size: 18)!
        ])
        btn3.setAttributedTitle(str3, forState: .Normal)
        btn3.setBackgroundColor(UIColor.offWhite(), forState: .Highlighted)
        btn3.setImage(UIImage(named: "IconContactBook"), forState: .Normal)
        btn3.setImage(UIImage(named: "IconContactBook")?.alpha(0.5), forState: .Highlighted)
        btn3.frame = CGRect(x: 35, y: screenHeight*0.54, width: screenWidth-70, height: 120)
        btn3.layer.cornerRadius = 10
        btn3.layer.masksToBounds = true
        btn3.backgroundColor = UIColor.whiteColor()
        btn3.addTarget(self, action: #selector(inviteButtonSelected(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(btn3)
        self.view.bringSubviewToFront(btn3)
        self.view.superview?.bringSubviewToFront(btn3)
        self.view.bringSubviewToFront(btn3)
        
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
        swipeMenuSelectionLabel.font = UIFont.systemFontOfSize(14, weight: UIFontWeightThin)
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
            return ges.translationInView(ges.view).y != 0
        }
        return false
    }
}