//
//  RecurringViewController.swift
//  protonpay-ios
//
//  Created by Sinan Ulkuatam on 3/7/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import LiquidFloatingActionButton
import CircleMenu

class ProtonViewController: UIViewController, LiquidFloatingActionButtonDataSource, LiquidFloatingActionButtonDelegate {
    
    var cells: [LiquidFloatingCell] = []
    var floatingActionButton: LiquidFloatingActionButton!
    
    let button = CircleMenu(
        frame: CGRect(x: 0, y: 0, width: 70, height: 70),
        normalIcon:"IconMenu",
        selectedIcon:"IconCloseLight",
        buttonsCount: 6,
        duration: 0.5,
        distance: 140)
    
    let colors = [UIColor.redColor(), UIColor.grayColor(), UIColor.greenColor(), UIColor.purpleColor()]
    let items: [(icon: String, color: UIColor)] = [
        ("ic_proton_outline_white", UIColor.protonBlue()),
        ("ic_proton_outline_white", UIColor.protonBlue()),
        ("ic_proton_outline_white", UIColor.protonBlue()),
        ("ic_proton_outline_white", UIColor.protonBlue()),
        ("ic_proton_outline_white", UIColor.protonBlue()),
        ("ic_proton_outline_white", UIColor.protonBlue()),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded proton")
        self.view.backgroundColor = UIColor.whiteColor()
        
        // screen width and height:
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
//        button.setBackgroundImage(UIImage(named: "BackgroundGradientInverse"), forState: .Normal)
        button.backgroundColor = UIColor.protonDarkBlue()
        button.delegate = self
        button.center = self.view.center
        button.layer.cornerRadius = button.frame.size.width / 2.0
        view.addSubview(button)

        // TODO: create segues to chargeView, addPlanView
        
        let createButton: (CGRect, LiquidFloatingActionButtonAnimateStyle) -> LiquidFloatingActionButton = { (frame, style) in
            let floatingActionButton = LiquidFloatingActionButton(frame: frame)
            floatingActionButton.animateStyle = style
            floatingActionButton.dataSource = self
            floatingActionButton.delegate = self
            floatingActionButton.color = UIColor.protonBlue()
            return floatingActionButton
        }
        
        let customCellFactory: (String, String, String) -> LiquidFloatingCell = { (iconName, description, segue) in
            let cell = CustomCell(icon: UIImage(named: iconName)!, name: description, segue: segue)
            return cell
        }
        cells.append(customCellFactory("IconEmpty", "Create Charge", "chargeView"))
        cells.append(customCellFactory("IconEmpty", "Add Plan", "addPlanView"))
        cells.append(customCellFactory("IconEmpty", "Add Customer", "addCustomerView"))
        let floatingFrame = CGRect(x: self.view.frame.width - 56 - 16, y: self.view.frame.height - 116 - 16, width: 56, height: 56)
        let bottomRightButton = createButton(floatingFrame, .Up)
        print(bottomRightButton.isOpening.boolValue)
        print(bottomRightButton.isClosed.boolValue)
        
        if(bottomRightButton.isOpening.boolValue) {
            print("adding blurview")
//            self.addBlurView()
        } else if(bottomRightButton.isClosed.boolValue) {
            print("button is closed")
            //                removeBlurView()
        }
//        self.view.addSubview(bottomRightButton)
        
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
    
    // Liquid Floating Button Delegate
    func numberOfCells(liquidFloatingActionButton: LiquidFloatingActionButton) -> Int {
        return cells.count
    }
    
    func cellForIndex(index: Int) -> LiquidFloatingCell {
        return cells[index]
    }
    
    func liquidFloatingActionButton(liquidFloatingActionButton: LiquidFloatingActionButton, didSelectItemAtIndex index: Int) {
        print("did Tapped! \(index)")
        if index == 0 {
            self.performSegueWithIdentifier("chargeView", sender: self)
        }
        if index == 1 {
            self.performSegueWithIdentifier("addPlanView", sender: self)
        }
        if index == 2 {
            self.performSegueWithIdentifier("addCustomerView", sender: self)
        }
        liquidFloatingActionButton.close()
    }
    
    // MARK: <CircleMenuDelegate>
    
    func circleMenu(circleMenu: CircleMenu, willDisplay button: CircleMenuButton, atIndex: Int) {
        button.backgroundColor = items[atIndex].color
        button.layer.borderColor = UIColor.protonDarkBlue().CGColor
        button.layer.borderWidth = 2
        button.setImage(UIImage(imageLiteral: items[atIndex].icon), forState: .Normal)
        
        // set highlighted image
        let highlightedImage  = UIImage(imageLiteral: items[atIndex].icon).imageWithRenderingMode(.AlwaysTemplate)
        button.setImage(highlightedImage, forState: .Highlighted)
        button.tintColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.3)
    }
    
    func circleMenu(circleMenu: CircleMenu, buttonWillSelected button: CircleMenuButton, atIndex: Int) {
        print("button will selected: \(atIndex)")
    }
    
    func circleMenu(circleMenu: CircleMenu, buttonDidSelected button: CircleMenuButton, atIndex: Int) {
        print("button did selected: \(atIndex)")
    }
    
    // Statusbar
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
    
}


public class CustomCell : LiquidFloatingCell {
    var name: String = "sample"
    var segue: String = "sampleSegue"
    
    init(icon: UIImage, name: String, segue: String) {
        self.name = name
        self.segue = segue
        super.init(icon: icon)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setupView(view: UIView) {
        super.setupView(view)
        let label = UILabel()
        label.text = name
        label.textAlignment = .Right
        label.textColor = UIColor(rgba: "#004790")
        label.font = UIFont(name: "Nunito-Regular", size: 12)
        addSubview(label)
        label.snp_makeConstraints { make in
            make.left.equalTo(self).offset(-120)
            make.width.equalTo(100)
            make.top.height.equalTo(self)
        }
    }
}