//
//  RootViewController.swift
//  RESideSwift
//
//  Created by miguelicious on 11/24/14.
//  Copyright (c) 2014 miguelicious. All rights reserved.
//

import UIKit

class RootViewController: RESideMenu, RESideMenuDelegate {
    
    var window: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func awakeFromNib() {
        
        self.contentViewShadowColor = UIColor.blackColor();
        self.contentViewShadowOffset = CGSizeMake(0, 0);
        self.contentViewShadowOpacity = 0.6;
        self.contentViewShadowRadius = 12;
        self.contentViewShadowEnabled = true;

        self.contentViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("ContentViewController"))! as UIViewController
        self.leftMenuViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("LeftMenuViewController"))! as UIViewController
        //self.rightMenuViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("RightMenuViewController"))! as UIViewController
        
    }
    
    // MARK: RESide Delegate Methods
    
    func sideMenu(sideMenu: RESideMenu!, willShowMenuViewController menuViewController: UIViewController!) {
        print("This will show the menu")
    }
    
    func close(){
        self.sideMenuViewController.hideMenuViewController()
        print("closing menu")
    }
    
    
}


