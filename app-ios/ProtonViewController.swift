//
//  RecurringViewController.swift
//  protonpay-ios
//
//  Created by Sinan Ulkuatam on 3/7/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import CircleMenu

class ProtonViewController: UIViewController {

    
    let button = CircleMenu(
        frame: CGRect(x: 0, y: 0, width: 70, height: 70),
        normalIcon:"IconMenu",
        selectedIcon:"IconCloseLight",
        buttonsCount: 6,
        duration: 0.5,
        distance: 140)
    
    let colors = [UIColor.redColor(), UIColor.grayColor(), UIColor.greenColor(), UIColor.purpleColor()]
    let items: [(icon: String, color: UIColor)] = [
        ("ic_repeat_light", UIColor.whiteColor()),
        ("ic_paper_plane_light", UIColor.whiteColor()),
        ("ic_paper_light", UIColor.whiteColor()),
        ("ic_link_light", UIColor.whiteColor()),
        ("ic_coinbag_light", UIColor.whiteColor()),
        ("ic_card_light", UIColor.whiteColor()),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded proton")
        
        let screen = UIScreen.mainScreen().bounds
        let width = screen.size.width
        let height = screen.size.height
        
        // Blurview
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
        visualEffectView.frame = CGRectMake(0, 0, width, height)
        let blurImageView: UIImageView = UIImageView(frame: CGRectMake(0, 0, width, height))
        blurImageView.contentMode = .ScaleAspectFill
        blurImageView.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin]
        blurImageView.layer.masksToBounds = true
        blurImageView.clipsToBounds = true
        blurImageView.image = UIImage(named: "BackgroundGradientInverse")
        self.view.addSubview(blurImageView)
        // adds blur
        blurImageView.addSubview(visualEffectView)
        self.view.sendSubviewToBack(blurImageView)
        
        // screen width and height:
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        button.backgroundColor = UIColor.clearColor()
        button.delegate = self
        button.center = self.view.center
        button.layer.cornerRadius = button.frame.size.width / 2.0
        button.layer.borderColor = UIColor.whiteColor().CGColor
        button.layer.borderWidth = 1
        view.addSubview(button)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        UIStatusBarStyle.Default
        if(Int(button.state.rawValue) == 0) {
            button.sendActionsForControlEvents(.TouchUpInside)
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
    
    // MARK: DELEGATE METHODS
    
    // MARK: CircleMenuDelegate
    
    func circleMenu(circleMenu: CircleMenu, willDisplay button: CircleMenuButton, atIndex: Int) {
        //        button.backgroundColor = items[atIndex].color
        button.backgroundColor = UIColor.clearColor()
        button.layer.borderColor = UIColor.whiteColor().CGColor
        button.layer.borderWidth = 1
        button.setImage(UIImage(imageLiteral: items[atIndex].icon), forState: .Normal)

        // set highlighted image
        let highlightedImage  = UIImage(imageLiteral: items[atIndex].icon).imageWithRenderingMode(.AlwaysTemplate)
        button.setImage(highlightedImage, forState: .Highlighted)
        button.tintColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.3)
    }
    
    func circleMenu(circleMenu: CircleMenu, buttonWillSelected button: CircleMenuButton, atIndex: Int) {
        print("button will selected: \(atIndex)")
        button.backgroundColor = items[atIndex].color
    }
    
    func circleMenu(circleMenu: CircleMenu, buttonDidSelected button: CircleMenuButton, atIndex: Int) {
        print("button did selected: \(atIndex)")
        button.backgroundColor = items[atIndex].color
    }
    
    // Statusbar
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
    
}