//
//  AccountVerificationTutorialViewController.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 7/3/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import MZFormSheetPresentationController

class AccountVerificationTutorialViewController: UIViewController {
    
    let titleLabel = UILabel()
    
    let tutImage1 = UIImageView()
    
    let tutImage2 = UIImageView()
    
    let tutImage3 = UIImageView()

    let tutImage4 = UIImageView()

    let tutText1 = UILabel()
    
    let tutText2 = UILabel()
    
    let tutText3 = UILabel()
    
    let tutText4 = UILabel()
    
    let tutSubText1 = UILabel()

    let tutSubText2 = UILabel()

    let tutSubText3 = UILabel()

    let bottomColorView = UIView()

    let exitButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    func configureView() {
        // This will set to only one instance
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        // screen width and height:
        let screen = UIScreen.mainScreen().bounds
        _ = screen.size.width
        _ = screen.size.height
        
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.barTintColor = UIColor.lightGrayColor()
        
        titleLabel.frame = CGRect(x: 0, y: 35, width: 300, height: 20)
        titleLabel.text = "Verification Instructions"
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont.systemFontOfSize(18, weight: UIFontWeightLight)
        titleLabel.textColor = UIColor.lightBlue()
        self.view.addSubview(titleLabel)
        
        tutImage1.frame = CGRect(x: 35, y: 90, width: 50, height: 50)
        tutImage1.image = UIImage(named: "IconSettings")
        tutImage1.contentMode = .ScaleAspectFit
        self.view.addSubview(tutImage1)
        tutText1.frame = CGRect(x: 90, y: 80, width: 210, height: 50)
        tutText1.text = "Complete your profile"
        tutText1.textAlignment = .Left
        tutText1.textColor = UIColor.lightBlue()
        self.view.addSubview(tutText1)
        tutSubText1.frame = CGRect(x: 90, y: 100, width: 210, height: 50)
        tutSubText1.text = "In Edit Profile"
        tutSubText1.textAlignment = .Left
        tutSubText1.textColor = UIColor.lightBlue()
        tutSubText1.font = UIFont.systemFontOfSize(12)
        self.view.addSubview(tutSubText1)
        
        tutImage2.frame = CGRect(x: 35, y: 170, width: 50, height: 50)
        tutImage2.image = UIImage(named: "IconBank")
        tutImage2.contentMode = .ScaleAspectFit
        self.view.addSubview(tutImage2)
        tutText2.frame = CGRect(x: 90, y: 160, width: 210, height: 50)
        tutText2.text = "Add a bank account"
        tutText2.textAlignment = .Left
        tutText2.textColor = UIColor.lightBlue()
        self.view.addSubview(tutText2)
        tutSubText2.frame = CGRect(x: 90, y: 180, width: 210, height: 50)
        tutSubText2.text = "Direct login or manual entry"
        tutSubText2.textAlignment = .Left
        tutSubText2.textColor = UIColor.lightBlue()
        tutSubText2.font = UIFont.systemFontOfSize(12)
        self.view.addSubview(tutSubText2)
        
        tutImage3.frame = CGRect(x: 35, y: 250, width: 50, height: 50)
        tutImage3.image = UIImage(named: "IconPerson")
        tutImage3.contentMode = .ScaleAspectFit
        self.view.addSubview(tutImage3)
        tutText3.frame = CGRect(x: 90, y: 240, width: 210, height: 50)
        tutText3.text = "Verify your identity"
        tutText3.textAlignment = .Left
        tutText3.textColor = UIColor.lightBlue()
        self.view.addSubview(tutText3)
        tutSubText3.frame = CGRect(x: 90, y: 260, width: 210, height: 50)
        tutSubText3.text = "One document and SSN"
        tutSubText3.textAlignment = .Left
        tutSubText3.textColor = UIColor.lightBlue()
        tutSubText3.font = UIFont.systemFontOfSize(12)
        self.view.addSubview(tutSubText3)
        
        tutImage4.frame = CGRect(x: 0, y: 320, width: 300, height: 60)
        tutImage4.image = UIImage(named: "IconCheckFilled")
        tutImage4.contentMode = .ScaleAspectFit
        self.view.addSubview(tutImage4)
        self.view.bringSubviewToFront(tutImage4)
        tutText4.frame = CGRect(x: 0, y: 370, width: 300, height: 60)
        tutText4.numberOfLines = 3
        tutText4.font = UIFont.systemFontOfSize(15)
        tutText4.text = "Congratulations, you are now ready to \n start accepting payments!"
        tutText4.textAlignment = .Center
        tutText4.textColor = UIColor.lightBlue()
        self.view.addSubview(tutText4)
        
        if UIScreen.mainScreen().bounds.size.width > 320 {
            bottomColorView.frame = CGRect(x: 0, y: UIScreen.mainScreen().bounds.height-320, width: 300, height: 320)
            bottomColorView.backgroundColor = UIColor.offWhite()
            self.view.addSubview(bottomColorView)
            self.view.sendSubviewToBack(bottomColorView)
        }
        
        exitButton.frame = CGRect(x: 20, y: UIScreen.mainScreen().bounds.height-220, width: 260, height: 50)
        exitButton.layer.borderColor = UIColor.whiteColor().CGColor
        exitButton.layer.borderWidth = 0
        exitButton.layer.cornerRadius = 10
        exitButton.layer.masksToBounds = true
        var attribs: [String: AnyObject] = [:]
        attribs[NSFontAttributeName] = UIFont.systemFontOfSize(14)
        attribs[NSForegroundColorAttributeName] = UIColor.whiteColor()
        let str = NSAttributedString(string: "Exit Tutorial", attributes: attribs)
        exitButton.setBackgroundColor(UIColor.lightBlue(), forState: .Normal)
        exitButton.setBackgroundColor(UIColor.lightBlue().colorWithAlphaComponent(0.5), forState: .Highlighted)
        exitButton.setAttributedTitle(str, forState: .Normal)
        exitButton.addTarget(self, action: #selector(self.close(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(exitButton)
    }
    
    override func viewDidDisappear(animated: Bool) {
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    func close(sender: AnyObject) -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}