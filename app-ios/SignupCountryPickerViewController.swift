//
//  CountryPickerViewController.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 4/25/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import CountryPicker
import FlagKit

class SignupCountryPickerViewController:UIViewController, CountryPickerDelegate, UITextFieldDelegate {
    
    let codeLabel:UILabel = UILabel()

    let flagImg:UIImageView = UIImageView()
    
    let countryPicker:CountryPicker = CountryPicker()

    //Changing Status Bar
    override internal func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidAppear(animated: Bool) {
        self.addSubviewWithBounce(codeLabel)
        self.addSubviewWithBounce(flagImg)
        addSubviewWithBounce(countryPicker)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addToolbarButton()
        
        self.view.backgroundColor = UIColor.offWhite()

        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        let countryPickerBackgroundView = UIView()
        countryPickerBackgroundView.backgroundColor = UIColor.whiteColor()
        countryPickerBackgroundView.frame = CGRect(x: 0, y: screenHeight-210, width: screenWidth, height: 210)
        self.view.addSubview(countryPickerBackgroundView)
        self.view.sendSubviewToBack(countryPickerBackgroundView)
        
        // Set default country code
        let countryCode = NSLocale.currentLocale().objectForKey(NSLocaleCountryCode) as! String
        NSUserDefaults.standardUserDefaults().setValue(countryCode, forKey: "userCountry")

        flagImg.image = UIImage(flagImageWithCountryCode: NSLocale.autoupdatingCurrentLocale().objectForKey(NSLocaleCountryCode) as! String)
        flagImg.layer.cornerRadius = 10
        flagImg.layer.masksToBounds = true
        flagImg.contentMode = .ScaleAspectFit
        
        let countryName: String = NSLocale.systemLocale().displayNameForKey(NSLocaleCountryCode, value: countryCode)!
        codeLabel.tintColor = UIColor.grayColor()
        codeLabel.textAlignment = .Center
        let str = NSAttributedString(string: countryName, attributes:
            [
                NSFontAttributeName: UIFont(name: "Avenir-Light", size: 24)!,
                NSForegroundColorAttributeName:UIColor.darkGrayColor()
            ])
        codeLabel.attributedText = str
        
        // Check for iPhone 4 size screen
        if(screenHeight < 500) {
            flagImg.frame = CGRect(x: screenWidth/2-15, y: screenHeight*0.15, width: 30, height: 30)
            codeLabel.frame = CGRect(x: 0, y: screenHeight*0.22, width: screenWidth, height: 50)
        } else {
            flagImg.frame = CGRect(x: screenWidth/2-15, y: screenHeight*0.22, width: 30, height: 40)
            codeLabel.frame = CGRect(x: 0, y: screenHeight*0.28, width: screenWidth, height: 50)
        }
        
        countryPicker.selectedLocale = NSLocale.currentLocale()
        countryPicker.delegate = self
        countryPicker.frame = CGRect(x: 0, y: screenHeight-215, width: screenWidth, height: 300)
        
        self.navigationController?.view.backgroundColor = UIColor.clearColor()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
        self.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 65))
        navBar.translucent = true
        navBar.tintColor = UIColor.whiteColor()
        navBar.backgroundColor = UIColor.clearColor()
        navBar.shadowImage = UIImage()
        navBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navBar.titleTextAttributes = [
            NSFontAttributeName: UIFont.systemFontOfSize(14),
            NSForegroundColorAttributeName:UIColor.mediumBlue().colorWithAlphaComponent(0.5)
        ]
        self.view.addSubview(navBar)
        let navItem = UINavigationItem(title: "Select your Country")
        navItem.leftBarButtonItem?.tintColor = UIColor.darkGrayColor()
        navBar.setItems([navItem], animated: true)
    }
    
    // Add send toolbar
    func addToolbarButton()
    {
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        countryPicker.backgroundColor = UIColor.clearColor()
        countryPicker.showsSelectionIndicator = true
        self.view.sendSubviewToBack(countryPicker)
        countryPicker.sendSubviewToBack(countryPicker)

        let toolBar = UIToolbar()
        toolBar.frame = CGRect(x: 0, y: screenHeight-250, width: screenWidth, height: 40)
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let next: UIBarButtonItem = UIBarButtonItem(title: "Continue", style: UIBarButtonItemStyle.Done, target: self, action: #selector(SignupCountryPickerViewController.nextStep(_:)))

        toolBar.setItems([flexSpace, next, flexSpace], animated: false)
        toolBar.userInteractionEnabled = true
        
        self.view.addSubview(toolBar)
        self.view.superview?.bringSubviewToFront(toolBar)
        self.view.superview?.sendSubviewToBack(countryPicker)
        self.view.bringSubviewToFront(toolBar)
    }
    
    func nextStep(sender: AnyObject) {
        // Function for toolbar button
        let entity = NSUserDefaults.standardUserDefaults().stringForKey("userLegalEntityType")!
        if entity == "individual" {
            self.performSegueWithIdentifier("VC1i", sender: sender)
        } else {
            self.performSegueWithIdentifier("VC1c", sender: sender)
        }
    }
    
    func countryPicker(picker: CountryPicker, didSelectCountryWithName name: String, code: String) {
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        // Update country code to picked country
        NSUserDefaults.standardUserDefaults().setValue(code, forKey: "userCountry")

        // prevent re-adding image
        flagImg.removeFromSuperview()
        flagImg.layer.cornerRadius = 10
        flagImg.layer.masksToBounds = true
        flagImg.contentMode = .ScaleAspectFit
        flagImg.image = UIImage(flagImageWithCountryCode: code)
        flagImg.frame = CGRect(x: screenWidth/2-15, y: screenHeight*0.22, width: 30, height: 30)
        
        codeLabel.removeFromSuperview()
        codeLabel.text = name
        codeLabel.tintColor = UIColor.grayColor()
        codeLabel.frame = CGRect(x: 0, y: screenHeight*0.3, width: screenWidth, height: 50)
        codeLabel.textAlignment = .Center
        let str = NSAttributedString(string: name, attributes:
            [
                NSFontAttributeName: UIFont(name: "Avenir-Light", size: 24)!,
                NSForegroundColorAttributeName:UIColor.darkGrayColor()
            ])
        codeLabel.attributedText = str
        
        // Check for iPhone 4 size screen
        if(screenHeight < 500) {
            flagImg.frame = CGRect(x: screenWidth/2-15, y: screenHeight*0.15, width: 30, height: 30)
            codeLabel.frame = CGRect(x: 0, y: screenHeight*0.22, width: screenWidth, height: 50)
        } else {
            flagImg.frame = CGRect(x: screenWidth/2-15, y: screenHeight*0.22, width: 30, height: 30)
            codeLabel.frame = CGRect(x: 0, y: screenHeight*0.28, width: screenWidth, height: 50)
        }
        
        self.addSubviewWithBounce(codeLabel)
        self.addSubviewWithBounce(flagImg)
        
    }
    
    
    func addSubviewWithBounce(view: UIView) {
        view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001)
        self.view.addSubview(view)
        UIView.animateWithDuration(0.3 / 1.5, animations: {() -> Void in
            view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0)
            }, completion: {(finished: Bool) -> Void in
                UIView.animateWithDuration(0.3 / 2, animations: {() -> Void in
                    }, completion: {(finished: Bool) -> Void in
                        UIView.animateWithDuration(0.3 / 2, animations: {() -> Void in
                            view.transform = CGAffineTransformIdentity
                        })
                })
        })
    }
    
}