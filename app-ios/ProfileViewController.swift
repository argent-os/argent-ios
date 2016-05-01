//
//  ProfileViewController.swift
//  protonpay-ios
//
//  Created by Sinan Ulkuatam on 3/7/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import JGProgressHUD

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!

    override func viewDidAppear(animated: Bool) {
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        UIStatusBarStyle.Default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Profile"
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.darkGrayColor()]
        print("loaded profile")
        self.view.backgroundColor = UIColor.whiteColor()
        
        // Style user avatar
//        avatarImageView.image = UIImage(named: "avatar")
//        avatarImageView.layer.cornerRadius = 1.0
//        avatarImageView.layer.borderColor = UIColor.blackColor().CGColor
//        avatarImageView.clipsToBounds = true
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 15, width: screenWidth, height: 50))
        navBar.barTintColor = UIColor.clearColor()
        navBar.translucent = true
        navBar.tintColor = UIColor.whiteColor()
        navBar.backgroundColor = UIColor.clearColor()
        navBar.shadowImage = UIImage()
        navBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "Avenir-Black", size: 18)!
        ]
        self.view.addSubview(navBar)
        self.view.bringSubviewToFront(navBar)
        
        
        User.getProfile({ (item, error) in
            if error != nil
            {
                let alert = UIAlertController(title: "Error", message: "Could not load profile \(error?.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            let navItem = UINavigationItem(title: "@"+(item?.username)!)
            navBar.setItems([navItem], animated: false)
        })
        
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor(rgba: "#157efb"),
            NSFontAttributeName : UIFont(name: "Avenir-Light", size: 18.0)!
        ]
            
        if(userData?["user"]["picture"]["secureUrl"].stringValue != nil && userData?["user"]["picture"]["secureUrl"].stringValue.containsString("app") != true) {
            let userPicture = userData?["user"]["picture"]["secureUrl"].stringValue
            let pictureUrl = NSURL(string: userPicture!)
            let data = NSData(contentsOfURL: pictureUrl!) //make sure your image in this url does exist, otherwise unwrap in a if let check
            if(data != nil) {
                print(data)
//                self.avatarImageView.image = UIImage(data: data!)
//                //self.avatarImageView.layer.cornerRadius = 4;
//                self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2;
//                avatarImageView.layer.borderWidth = 2.0
                //self.avatarImageView.clipsToBounds = YES;
            } else {
//                self.avatarImageView.image = UIImage(named:"ic_user")
                // self.avatarImageView.image = UIImageView.setGravatar(Gravatar)
            }
            //print(userData)
        }
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}