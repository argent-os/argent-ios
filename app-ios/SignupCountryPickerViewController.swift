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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addToolbarButton()
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        let width = screen.size.width
        let height = screen.size.height
        
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
            flagImg.frame = CGRect(x: screenWidth/2-25, y: screenHeight*0.11, width: 50, height: 50)
            codeLabel.frame = CGRect(x: 0, y: screenHeight*0.19, width: screenWidth, height: 50)
        } else {
            flagImg.frame = CGRect(x: screenWidth/2-25, y: screenHeight*0.22, width: 50, height: 50)
            codeLabel.frame = CGRect(x: 0, y: screenHeight*0.30, width: screenWidth, height: 50)
        }
        
        self.view.addSubview(codeLabel)
        self.view.addSubview(flagImg)
        
        countryPicker.selectedLocale = NSLocale.currentLocale()
        countryPicker.delegate = self
        countryPicker.frame = CGRect(x: 0, y: screenHeight-280, width: screenWidth, height: 300)
        self.view.addSubview(countryPicker)
        
        self.navigationController?.view.backgroundColor = UIColor.clearColor()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
        self.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: width, height: 47))
        navBar.translucent = true
        navBar.tintColor = UIColor.whiteColor()
        navBar.backgroundColor = UIColor.clearColor()
        navBar.shadowImage = UIImage()
        navBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navBar.titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "Avenir-Light", size: 16)!,
            NSForegroundColorAttributeName:UIColor.lightGrayColor()
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
        toolBar.frame = CGRect(x: 0, y: screenHeight-310, width: screenWidth, height: 40)
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
        flagImg.frame = CGRect(x: screenWidth/2-25, y: screenHeight*0.22, width: 50, height: 50)
        
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
            flagImg.frame = CGRect(x: screenWidth/2-25, y: screenHeight*0.11, width: 50, height: 50)
            codeLabel.frame = CGRect(x: 0, y: screenHeight*0.19, width: screenWidth, height: 50)
        } else {
            flagImg.frame = CGRect(x: screenWidth/2-25, y: screenHeight*0.22, width: 50, height: 50)
            codeLabel.frame = CGRect(x: 0, y: screenHeight*0.30, width: screenWidth, height: 50)
        }
        
        self.view.addSubview(flagImg)
        self.view.addSubview(codeLabel)
        
    }
}