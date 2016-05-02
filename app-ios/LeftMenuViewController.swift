//
//  LeftMenuViewController.swift
//  RESideSwift
//
//  Created by miguelicious on 11/25/14.
//  Copyright (c) 2014 miguelicious. All rights reserved.
//

import UIKit

//protocol :
class LeftMenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource ,RESideMenuDelegate{

    var tableView: UITableView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView = UITableView()
        self.tableView.frame = CGRectMake(0, 10, self.view.frame.size.width  , 54 * 5)
        tableView.autoresizingMask = [UIViewAutoresizing.FlexibleTopMargin, UIViewAutoresizing.FlexibleBottomMargin, UIViewAutoresizing.FlexibleWidth]
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = true;
        tableView.backgroundColor = UIColor.clearColor()
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.bounces = false;
        tableView.scrollsToTop = false;
        self.view.addSubview(tableView)
        
        // Do any additional setup after loading the view.
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath( indexPath, animated: true)
        switch (indexPath.row) {
        // Navigation clicked, case 0 equivalent to pressing 'Home' and going to HomeViewController
        case 0:
            // Load the root view when returning home
            let rootViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("RootViewController"))! as UIViewController
            sideMenuViewController?.contentViewController = rootViewController
            sideMenuViewController?.hideMenuViewController()
            break;
        case 1:
            // Load the root view when returning home
            let rootViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("RootViewController"))! as UIViewController
            sideMenuViewController?.contentViewController = rootViewController
            sideMenuViewController?.hideMenuViewController()
            break;
        case 2:
            // Load the root view when returning home
            let rootViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("RootViewController"))! as UIViewController
            sideMenuViewController?.contentViewController = rootViewController
            sideMenuViewController?.hideMenuViewController()
            break;
        case 3:
            // Load the root view when returning home
            let rootViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("RootViewController"))! as UIViewController
            sideMenuViewController?.contentViewController = rootViewController
            sideMenuViewController?.hideMenuViewController()
            break;
        case 4:
            // 1
            let optionMenu = UIAlertController(title: nil, message: "Are you sure you want to logout?", preferredStyle: .ActionSheet)
            // 2
            let logoutAction = UIAlertAction(title: "Logout", style: .Destructive, handler: {
                (alert: UIAlertAction!) -> Void in
                NSUserDefaults.standardUserDefaults().setBool(false,forKey:"userLoggedIn");
                NSUserDefaults.standardUserDefaults().synchronize();
                // go to login view
                self.performSegueWithIdentifier("loginView", sender: self);
            })
            //
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
                (alert: UIAlertAction!) -> Void in
                print("Cancelled")
            })
            // 4
            optionMenu.addAction(logoutAction)
            optionMenu.addAction(cancelAction)
            // 5
            self.presentViewController(optionMenu, animated: true, completion: nil)
            
            break;
        default:
            break;
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return number of rows in side menu
        return 5
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel?.textColor = UIColor.whiteColor()
        var titles = ["", "", "", "Return Home", "Log Out"]
        var images = ["IconLogoWhite", "IconEmpty", "IconEmpty", "IconEmpty", "IconEmpty"];
        cell.textLabel?.text = titles[indexPath.row]
        cell.textLabel?.font = UIFont(name: "Avenir-Book", size: 16)
        cell.imageView?.image = UIImage(named: images[indexPath.row])
        
        return cell
        
    }
    
}
