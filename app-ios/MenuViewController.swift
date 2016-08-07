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
import XLPagerTabStrip

class MenuViewController: ButtonBarPagerTabStripViewController {

    private let viewTerminalImageView = UIView()

    private let addPlanImageView = UIView()
    
    @IBOutlet weak var barButtonView: ButtonBarView!
    
    let blueInstagramColor = UIColor.oceanBlue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMainMenu()
    }
    
    func configureMainMenu() {
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        barButtonView.backgroundColor = UIColor.whiteColor()
        
        // change selected bar color
//        settings.style.buttonBarBackgroundColor = UIColor.redColor()
        settings.style.buttonBarItemBackgroundColor = UIColor.whiteColor()
//        settings.style.selectedBarBackgroundColor = UIColor.greenColor()
        settings.style.buttonBarItemFont = UIFont(name: "MyriadPro-Regular", size: 14)!
        settings.style.selectedBarHeight = 20
        settings.style.buttonBarMinimumLineSpacing = 10
//        settings.style.buttonBarItemTitleColor = UIColor.greenColor()
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 40
        settings.style.buttonBarRightContentInset = 40
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .blackColor()
            newCell?.label.textColor = self?.blueInstagramColor
        }
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
        visualEffectView.frame = CGRectMake(0, 0, screenWidth, screenHeight)
        let backgroundImageView = UIImageView(image: UIImage(), highlightedImage: nil)
//        backgroundImageView.backgroundColor = UIColor.offWhite()
        backgroundImageView.frame = CGRectMake(0, 0, screenWidth, screenHeight)
        backgroundImageView.contentMode = .ScaleAspectFill
        backgroundImageView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        backgroundImageView.layer.masksToBounds = true
        backgroundImageView.clipsToBounds = true
        // backgroundImageView.addSubview(visualEffectView)
//        self.view.sendSubviewToBack(backgroundImageView)
//        self.view.addSubview(backgroundImageView)

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

    // MARK: - PagerTabStripDataSource
    
    override func viewControllersForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = MenuChildViewControllerOne(itemInfo: "MAIN")
        let child_2 = MenuChildViewControllerTwo(itemInfo: "OVERVIEW")
        return [child_1, child_2]
    }
}
