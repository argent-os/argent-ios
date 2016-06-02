//
//  MenuViewController.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 3/7/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import BTNavigationDropdownMenu

class MenuViewController: UIViewController {

    private let viewTerminalImageView = UIView()

    private let addPlanImageView = UIView()
    
    private let inviteImageView = UIView()

    private var mainView = UIView()
    
    private var overView = UIView()
    
    let selectedCellLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMainMenu()
    }
    
    override func viewDidAppear(animated: Bool) {
        UIStatusBarStyle.Default
    }
    
    func configureMainMenu() {
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
        
        let items = ["Main Menu", "Plans", "Customers", "Subscriptions"]
        
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.mediumBlue()
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "ArialRoundedMTBold", size: 16)!
        ]
        
        self.selectedCellLabel.text = items.first
        
        let menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, title: items[0], items: items)
        menuView.cellHeight = 50
        menuView.cellSeparatorColor = UIColor.whiteColor().colorWithAlphaComponent(0.4)
        menuView.cellBackgroundColor = self.navigationController?.navigationBar.barTintColor
        menuView.cellSelectionColor = UIColor.mediumBlue().colorWithAlphaComponent(0.5)
        menuView.keepSelectedCellColor = true
        menuView.checkMarkImage = UIImage(named: "ic_check_light")
        menuView.cellTextLabelColor = UIColor.whiteColor()
        menuView.cellTextLabelFont = UIFont(name: "HelveticaNeue", size: 16)
        menuView.cellTextLabelAlignment = .Center // .Center // .Right // .Left
        menuView.arrowPadding = 15
        menuView.animationDuration = 0.2
        menuView.maskBackgroundColor = UIColor.blackColor()
        menuView.maskBackgroundOpacity = 0.3
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
            print("Did select item at index: \(indexPath)")
            self.selectedCellLabel.text = items[indexPath]
            if(indexPath == 1) {
                let viewController:PlansListTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("PlansListTableViewController") as! PlansListTableViewController
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            if(indexPath == 2) {
                let viewController:CustomersListTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CustomersListTableViewController") as! CustomersListTableViewController
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            if(indexPath == 3) {
                let viewController:SubscriptionsListTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SubscriptionsListTableViewController") as! SubscriptionsListTableViewController
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
        
        self.navigationItem.titleView = menuView
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
        return UIStatusBarStyle.LightContent
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "menuView") {
            let rootViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("RootViewController"))! as UIViewController
            self.presentViewController(rootViewController, animated: true, completion: nil)
        }
    }
}