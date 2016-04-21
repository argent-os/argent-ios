//
//  SearchDetailViewController.swift
//  protonpay-ios
//
//  Created by Sinan Ulkuatam on 4/20/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import UIKit

class SearchDetailViewController: UIViewController {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var stacks: UIStackView!
    let lbl:UILabel = UILabel()

    var detailUser: User? {
        didSet {
            configureView()
        }
    }
    
    func configureView() {
        if let detailUser = detailUser {
            if let usernameLabel = usernameLabel {
                usernameLabel.text = detailUser.username
            }
            if let emailLabel = emailLabel {
                emailLabel.text = detailUser.email
            }
            
            // Email textfield
            lbl.text = detailUser.email
            lbl.frame = CGRectMake(0, 160, width, 110)
            lbl.textAlignment = .Center
            lbl.textColor = UIColor.whiteColor()
            lbl.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin]
            self.view.addSubview(lbl)

            // User image
            let img: UIImage = UIImage(data: NSData(contentsOfURL: NSURL(string: detailUser.picture)!)!)!
            let userImageView: UIImageView = UIImageView(frame: CGRectMake(width / 2, 0, 90, 90))
            userImageView.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin]
            userImageView.center = CGPointMake(self.view.bounds.size.width / 2, 135)
            userImageView.backgroundColor = UIColor.groupTableViewBackgroundColor()
            userImageView.layer.cornerRadius = userImageView.frame.size.height/2
            userImageView.layer.masksToBounds = true
            userImageView.clipsToBounds = true
            userImageView.image = img
            userImageView.layer.borderWidth = 2
            userImageView.layer.borderColor = UIColor(rgba: "#fffa").CGColor
            self.view.addSubview(userImageView)
            
            // Title
            self.navigationController?.view.backgroundColor = UIColor.clearColor()
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
            self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
            self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
            let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: width, height: 65))
            navBar.translucent = true
            navBar.backgroundColor = UIColor.clearColor()
            navBar.shadowImage = UIImage()
            navBar.titleTextAttributes = [
                NSForegroundColorAttributeName : UIColor.whiteColor(),
                NSFontAttributeName : UIFont(name: "Nunito-Regular", size: 18)!
            ]
            self.view.addSubview(navBar)
            let navItem = UINavigationItem(title: "@"+detailUser.username)
            navBar.setItems([navItem], animated: true)

            // Blurview
            let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
            visualEffectView.frame = CGRectMake(0, 0, width, 250)
            let blurImageView: UIImageView = UIImageView(frame: CGRectMake(0, 0, width, 250))
            blurImageView.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin]
            blurImageView.layer.masksToBounds = true
            blurImageView.clipsToBounds = true
            blurImageView.image = img
            self.view.addSubview(blurImageView)
            blurImageView.addSubview(visualEffectView)
            self.view.sendSubviewToBack(blurImageView)
            
            // Button
            let inviteButton = UIButton(frame: CGRect(x: 10, y: 265, width: (width/2)-20, height: 48.0))
            inviteButton.backgroundColor = UIColor.protonDarkBlue()
            inviteButton.tintColor = UIColor(rgba: "#fff")
            inviteButton.setTitleColor(UIColor(rgba: "#fff"), forState: .Normal)
            inviteButton.titleLabel?.font = UIFont(name: "Nunito-Regular", size: 14)
            inviteButton.setTitle("Invite Customer", forState: .Normal)
            inviteButton.layer.cornerRadius = 5
            inviteButton.layer.masksToBounds = true
            inviteButton.addTarget(self, action: #selector(AuthViewController.login(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            view.addSubview(inviteButton)
            
            // Button
            let subscribeButton = UIButton(frame: CGRect(x: width*0.5+10, y: 265, width: (width/2)-20, height: 48.0))
            subscribeButton.backgroundColor = UIColor.protonBlue()
            subscribeButton.setTitle("Subscribe", forState: .Normal)
            subscribeButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            subscribeButton.titleLabel?.font = UIFont(name: "Nunito-Regular", size: 14)
            subscribeButton.layer.cornerRadius = 5
            subscribeButton.layer.borderColor = UIColor(rgba: "#ffffff").CGColor
            subscribeButton.layer.masksToBounds = true
            subscribeButton.addTarget(self, action: #selector(AuthViewController.signup(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            view.addSubview(subscribeButton)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

