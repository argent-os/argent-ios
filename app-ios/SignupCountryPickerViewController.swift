//
//  CountryPickerViewController.swift
//  protonpay-ios
//
//  Created by Sinan Ulkuatam on 4/25/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import CountryPicker
import FlagKit

class SignupCountryPickerViewController:UIViewController, CountryPickerDelegate {
    
    let textField:UITextField = UITextField()
    
    let codeLabel:UILabel = UILabel()

    let flagImg:UIImageView = UIImageView()
    
    let countryPicker:CountryPicker = CountryPicker()

    //Changing Status Bar
    override internal func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("country picker view loaded")
        
        self.view.addSubview(textField)
        addToolbarButton()
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        countryPicker.selectedLocale = NSLocale.currentLocale()
        countryPicker.delegate = self
        countryPicker.frame = CGRect(x: 0, y: screenHeight-270, width: screenWidth, height: 300)
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
            NSFontAttributeName: UIFont(name: "Nunito-Regular", size: 18)!,
            NSForegroundColorAttributeName:UIColor.lightGrayColor()
        ]
        self.view.addSubview(navBar)
        let navItem = UINavigationItem(title: "Select a Country")
        navItem.leftBarButtonItem?.tintColor = UIColor.darkGrayColor()
        navBar.setItems([navItem], animated: true)
        
        
    }
    
    // Add send toolbar
    func addToolbarButton()
    {
        countryPicker.backgroundColor = .whiteColor()
        countryPicker.showsSelectionIndicator = true
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let done: UIBarButtonItem = UIBarButtonItem(title: "Continue", style: UIBarButtonItemStyle.Done, target: self, action: #selector(SignupViewControllerOne.nextStep(_:)))
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: "donePicker")
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "donePicker")
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        textField.inputView = countryPicker
        textField.inputAccessoryView = toolBar

    }
    
    override func viewDidAppear(animated: Bool) {
        flagImg.image = UIImage(flagImageWithCountryCode: NSLocale.autoupdatingCurrentLocale().objectForKey(NSLocaleCountryCode) as! String)
    }
    
    func countryPicker(picker: CountryPicker, didSelectCountryWithName name: String, code: String) {
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        print(name)
        print(code)
        
        // prevent re-adding image
        flagImg.removeFromSuperview()
        flagImg.layer.cornerRadius = 10
        flagImg.layer.masksToBounds = true
        flagImg.contentMode = .ScaleAspectFit
        flagImg.image = UIImage(flagImageWithCountryCode: code)
        flagImg.frame = CGRect(x: screenWidth/2-25, y: screenHeight*0.22, width: 50, height: 50)
        self.view.addSubview(flagImg)
        
        codeLabel.removeFromSuperview()
        codeLabel.text = name
        codeLabel.tintColor = UIColor.grayColor()
        codeLabel.frame = CGRect(x: 0, y: screenHeight*0.3, width: screenWidth, height: 50)
        codeLabel.textAlignment = .Center
        let str = NSAttributedString(string: name, attributes:
            [
                NSFontAttributeName: UIFont(name: "Nunito-ExtraLight", size: 24)!,
                NSForegroundColorAttributeName:UIColor.darkGrayColor()
            ])
        codeLabel.attributedText = str
        self.view.addSubview(codeLabel)
        
    }
}