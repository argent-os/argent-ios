//
//  IdentityVerificationViewController.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 5/25/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import ImagePicker
import Alamofire
import Foundation
import CWStatusBarNotification
import MZFormSheetPresentationController
import Crashlytics
import EasyTipView

class IdentityVerificationViewController: UIViewController, ImagePickerDelegate, UINavigationBarDelegate {
    
    let navigationBar = UINavigationBar()

    private var identityCardButton = UIButton()

    private var passportCardButton = UIButton()

    private var driversLicenseButton = UIButton()

    private var socialSecurityButton = UIButton()
    
    private let imagePickerController = ImagePickerController()

    let tipView = EasyTipView(text: "All information processed is SHA-256 Bit encrypted with end-to-end SSL. We do not store social security information on our servers.  Social security and identity document data is handled and processed by Stripe, one of the world's top payment processors.", preferences: EasyTipView.globalPreferences)

    var rightButton = UIBarButtonItem()

    let imageView = UIImageView()
    
    let screen = UIScreen.mainScreen().bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        loadData()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
    
    func configure() {
        
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        addHelpButton()
        
        let titleDocumentLabel = UILabel()
        let titleAttributedString = adjustAttributedString("IDENTITY DOCUMENT", spacing: 2, fontName: "MyriadPro-Regular", fontSize: 15, fontColor: UIColor.darkBlue().colorWithAlphaComponent(0.75), lineSpacing: 0.0, alignment: .Center)
        titleDocumentLabel.attributedText = titleAttributedString
        titleDocumentLabel.textColor = UIColor.lightBlue().colorWithAlphaComponent(0.75)
        titleDocumentLabel.textAlignment = .Center
        titleDocumentLabel.font = UIFont(name: "MyriadPro-Regular", size: 13)!
        titleDocumentLabel.frame = CGRect(x: 0, y: 75, width: screenWidth, height: 30)
        addSubviewWithFade(titleDocumentLabel, parentView: self, duration: 0.5)
        
        let splitView = UIView()
        splitView.frame = CGRect(x: 80, y: 420, width: screenWidth-160, height: 1)
        splitView.backgroundColor = UIColor.lightBlue().colorWithAlphaComponent(0.2)
        addSubviewWithFade(splitView, parentView: self, duration: 0.5)
        
        let ssnTitleLabel = UILabel()
        let ssnAttributedString = adjustAttributedString("SOCIAL SECURITY", spacing: 2, fontName: "MyriadPro-Regular", fontSize: 15, fontColor: UIColor.darkBlue().colorWithAlphaComponent(0.75), lineSpacing: 0.0, alignment: .Center)
        ssnTitleLabel.attributedText = ssnAttributedString
        ssnTitleLabel.textAlignment = .Center
        ssnTitleLabel.font = UIFont(name: "MyriadPro-Regular", size: 13)!
        ssnTitleLabel.textColor = UIColor.lightBlue().colorWithAlphaComponent(0.75)
        ssnTitleLabel.frame = CGRect(x: 00, y: 435, width: screenWidth, height: 30)
        addSubviewWithFade(ssnTitleLabel, parentView: self, duration: 0.5)
        
        self.view.backgroundColor = UIColor.whiteColor()
        
//        self.navigationItem.title = ""
//        self.navigationController?.navigationBar.tintColor = UIColor.lightBlue()
//        self.navigationController?.navigationBar.titleTextAttributes = [
//            NSFontAttributeName: UIFont.systemFontOfSize(14),
//            NSForegroundColorAttributeName: UIColor.lightBlue()
//        ]
        
        passportCardButton.frame = CGRect(x: 30, y: 110, width: screenWidth-60, height: 80)
        passportCardButton.setBackgroundColor(UIColor.whiteColor(), forState: .Normal)
        passportCardButton.setBackgroundColor(UIColor.offWhite(), forState: .Highlighted)
        let str0 = NSAttributedString(string: " Passport", attributes: [
                NSFontAttributeName: UIFont(name: "MyriadPro-Regular", size: 15)!,
                NSForegroundColorAttributeName:UIColor.lightBlue()
            ])
        passportCardButton.setAttributedTitle(str0, forState: .Normal)
        passportCardButton.setTitleColor(UIColor.mediumBlue(), forState: .Normal)
        passportCardButton.setTitleColor(UIColor.darkBlue(), forState: .Highlighted)
        passportCardButton.layer.borderColor = UIColor.lightBlue().colorWithAlphaComponent(0.4).CGColor
        passportCardButton.layer.borderWidth = 1
        passportCardButton.layer.cornerRadius = 5
        passportCardButton.layer.masksToBounds = true
        passportCardButton.backgroundColor = UIColor.whiteColor()
        self.passportCardButton.addTarget(self, action: #selector(IdentityVerificationViewController.openCamera(_:)), forControlEvents: .TouchUpInside)
        addSubviewWithFade(passportCardButton, parentView: self, duration: 0.5)
        
        // Add only on US/CA/AU Location
        self.identityCardButton.frame = CGRect(x: 30, y: 210, width: screenWidth-60, height: 80)
        let str1 = NSAttributedString(string: " Identity Card", attributes: [
            NSFontAttributeName: UIFont(name: "MyriadPro-Regular", size: 15)!,
            NSForegroundColorAttributeName:UIColor.lightBlue()
            ])
        self.identityCardButton.setAttributedTitle(str1, forState: .Normal)
        self.identityCardButton.setBackgroundColor(UIColor.whiteColor(), forState: .Normal)
        self.identityCardButton.setBackgroundColor(UIColor.offWhite(), forState: .Highlighted)
        self.identityCardButton.setTitleColor(UIColor.mediumBlue(), forState: .Normal)
        self.identityCardButton.setTitleColor(UIColor.darkBlue(), forState: .Highlighted)
        self.identityCardButton.layer.borderColor = UIColor.lightBlue().colorWithAlphaComponent(0.4).CGColor
        self.identityCardButton.layer.borderWidth = 1
        self.identityCardButton.layer.cornerRadius = 5
        self.identityCardButton.layer.masksToBounds = true
        self.identityCardButton.backgroundColor = UIColor.whiteColor()
        self.identityCardButton.addTarget(self, action: #selector(IdentityVerificationViewController.openCamera(_:)), forControlEvents: .TouchUpInside)
        
        self.driversLicenseButton.frame = CGRect(x: 30, y: 310, width: screenWidth-60, height: 80)
        let str2 = NSAttributedString(string: " Driver's License", attributes: [
            NSFontAttributeName: UIFont(name: "MyriadPro-Regular", size: 15)!,
            NSForegroundColorAttributeName:UIColor.lightBlue()
            ])
        self.driversLicenseButton.setAttributedTitle(str2, forState: .Normal)
        self.driversLicenseButton.setBackgroundColor(UIColor.whiteColor(), forState: .Normal)
        self.driversLicenseButton.setBackgroundColor(UIColor.offWhite(), forState: .Highlighted)
        self.driversLicenseButton.setTitleColor(UIColor.mediumBlue(), forState: .Normal)
        self.driversLicenseButton.setTitleColor(UIColor.darkBlue(), forState: .Highlighted)
        self.driversLicenseButton.layer.borderColor = UIColor.lightBlue().colorWithAlphaComponent(0.4).CGColor
        self.driversLicenseButton.layer.borderWidth = 1
        self.driversLicenseButton.layer.cornerRadius = 5
        self.driversLicenseButton.layer.masksToBounds = true
        self.driversLicenseButton.backgroundColor = UIColor.whiteColor()
        self.driversLicenseButton.addTarget(self, action: #selector(IdentityVerificationViewController.openCamera(_:)), forControlEvents: .TouchUpInside)
        
        self.socialSecurityButton.frame = CGRect(x: 30, y: 470, width: screenWidth-60, height: 80)
        let str3 = NSAttributedString(string: "Social Security Number", attributes: [
            NSFontAttributeName: UIFont(name: "MyriadPro-Regular", size: 15)!,
            NSForegroundColorAttributeName:UIColor.lightBlue()
            ])
        self.socialSecurityButton.setAttributedTitle(str3, forState: .Normal)
//        self.socialSecurityButton.setImage(UIImage(named: "IconIdentityCard"), forState: .Normal)
        self.socialSecurityButton.setBackgroundColor(UIColor.whiteColor(), forState: .Normal)
        self.socialSecurityButton.setBackgroundColor(UIColor.offWhite(), forState: .Highlighted)
        self.socialSecurityButton.setTitleColor(UIColor.mediumBlue(), forState: .Normal)
        self.socialSecurityButton.setTitleColor(UIColor.darkBlue(), forState: .Highlighted)
        self.socialSecurityButton.layer.borderColor = UIColor.lightBlue().colorWithAlphaComponent(0.4).CGColor
        self.socialSecurityButton.layer.borderWidth = 1
        self.socialSecurityButton.layer.cornerRadius = 5
        self.socialSecurityButton.layer.masksToBounds = true
        self.socialSecurityButton.addTarget(self, action: #selector(self.showSSNModal(_:)), forControlEvents: .TouchUpInside)
        
        if screenHeight < 500 {
            passportCardButton.frame = CGRect(x: 30, y: 80, width: screenWidth-60, height: 60)

            self.identityCardButton.frame = CGRect(x: 30, y: 160, width: screenWidth-60, height: 60)

            self.driversLicenseButton.frame = CGRect(x: 30, y: 240, width: screenWidth-60, height: 60)
            
            self.socialSecurityButton.frame = CGRect(x: 30, y: 320, width: screenWidth-60, height: 60)
            
            splitView.removeFromSuperview()
        }
    }
    
    func loadData() {
        User.getProfile { (user, err) in
            if user?.country == "US" || user?.country == "AU" || user?.country == "CA" {
                addSubviewWithFade(self.identityCardButton, parentView: self, duration: 0.4)
                
                addSubviewWithFade(self.driversLicenseButton, parentView: self, duration: 0.5)
                
                addSubviewWithFade(self.socialSecurityButton, parentView: self, duration: 0.6)
            }
        }
    }
    
    func openCamera(sender: AnyObject) {
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 1
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height

        Answers.logCustomEventWithName("Identity Verification Picture Upload Selected",
                                       customAttributes: [:])
        
        presentViewController(imagePickerController, animated: true, completion: { void in
            let overlayView = UIView()
            overlayView.frame = CGRect(x: 20, y: screenHeight*0.25, width: screenWidth-40, height: 210)
            overlayView.layer.cornerRadius = 5
            overlayView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.4)
            self.imagePickerController.view.addSubview(overlayView)

            let overlayText = UILabel()
            overlayText.text = "Position card over the area below"
            overlayText.font = UIFont.systemFontOfSize(14)
            overlayText.textColor = UIColor.whiteColor()
            overlayText.frame = CGRect(x: 0, y: screenHeight*0.15, width: screenWidth, height: 70)
            overlayText.textAlignment = .Center
            self.imagePickerController.view.addSubview(overlayText)
            
            self.imagePickerController.collapseGalleryView {
                //
            }
        })
    }
    
    // Delegate: Imagepicker
    func wrapperDidPress(images: [UIImage]) {
        imagePickerController.collapseGalleryView { 
            //
        }
    }
    
    func doneButtonDidPress(images: [UIImage]) {
        imageView.image = images[0]
        imageUploadRequest(imageView.image!)
        print(imageView.image)
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        imageView.center = self.view.center
        imageView.layer.cornerRadius = imageView.frame.size.width/2
        imageView.layer.masksToBounds = true
        self.dismissViewControllerAnimated(true, completion: nil)
        let _ = Timeout(0.3) {
            if let navController = self.navigationController {
                navController.popViewControllerAnimated(true)
            }
        }
    }
    
    func cancelButtonDidPress() {
    }
    
    // Request
    
    func imageUploadRequest(uploadedImage: UIImage)
    {
        
        showGlobalNotification("Uploading identity verification document", duration: 4.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.NavigationBarNotification, color: UIColor.pastelBlue())

        if(userAccessToken != nil) {
            User.getProfile { (user, NSError) in
                
                let endpoint = API_URL + "/stripe/" + (user?.id)! + "/upload"
                
                let parameters = [
                    "purpose": "identity_document"
                ]
                
                let headers = [
                    "Authorization": "Bearer " + (userAccessToken as! String),
                    "Content-Type": "application/x-www-form-urlencoded"
                ]
                
                let img = UIImageJPEGRepresentation(uploadedImage, 1)
                
                if(img==nil)  { return; }
                
                let imageData: NSData = NSData(data: img!)
                
                let fileSize = Float(imageData.length) / 1024.0 / 1024.0
                let fileSizeString = String.localizedStringWithFormat("%.2f", fileSize)
                NSLog("File size is : %.2f MB", fileSize)
                
                if(fileSize > 5) {
                    self.dismissViewControllerAnimated(true, completion: nil)
                    showGlobalNotification("File size " + fileSizeString + "MB too large", duration: 4.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.NavigationBarNotification, color: UIColor.redColor())
                } else {
                    Alamofire.upload(.POST, endpoint, headers: headers, multipartFormData: {
                        multipartFormData in
                        
                        multipartFormData.appendBodyPart(data: imageData, name: "document", fileName: "document", mimeType: "image/jpg")
                        
                        for (key, value) in parameters {
                            multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
                        }
                        
                        }, encodingCompletion: {
                            encodingResult in
                            print("encoding result")
                            switch encodingResult {
                            case .Success(let upload, _, _):
                                upload.responseJSON(completionHandler: { response in
                                    switch response.result {
                                    case .Success:
                                        print("success")
                                        showGlobalNotification("Document uploaded!", duration: 4.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.NavigationBarNotification, color: UIColor.pastelBlue())
                                        Answers.logCustomEventWithName("Identity Verification Document Upload Success",
                                            customAttributes: [:])
                                    case .Failure(let error):
                                        showGlobalNotification("Error uploading document, please contact support", duration: 4.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.NavigationBarNotification, color: UIColor.neonOrange())
                                        Answers.logCustomEventWithName("Identity Verification Document Upload Failure",
                                            customAttributes: [
                                                "error": error.localizedDescription
                                            ])
                                        print("failure")
                                        print(error)
                                    }
                                })
                            case .Failure(let encodingError):
                                print(encodingError)
                                Answers.logCustomEventWithName("Identity Verification Encoding Error",
                                    customAttributes: [
                                        "error": "encoding_error"
                                    ])
                            }
                    })
                }
            }
        }
    }
    
    // MARK: SSN modal
    
    func showSSNModal(sender: AnyObject) {
        
        Answers.logCustomEventWithName("Identity Verification SSN Selected",
                                       customAttributes: [:])
        
        let navigationController = self.storyboard!.instantiateViewControllerWithIdentifier("ssnModalNavigationController") as! UINavigationController
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: navigationController)
        
        print("showing ssn modal")
        // Initialize and style the terms and conditions modal
        formSheetController.presentationController?.contentViewSize = CGSizeMake(280, 280)
        formSheetController.presentationController?.shouldUseMotionEffect = true
        formSheetController.presentationController?.containerView?.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        formSheetController.presentationController?.containerView?.sizeToFit()
        formSheetController.presentationController?.shouldApplyBackgroundBlurEffect = true
        formSheetController.presentationController?.blurEffectStyle = UIBlurEffectStyle.Dark
        formSheetController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyle.SlideFromBottom
        formSheetController.presentationController?.movementActionWhenKeyboardAppears = MZFormSheetActionWhenKeyboardAppears.CenterVertically
        formSheetController.contentViewCornerRadius = 5
        formSheetController.allowDismissByPanningPresentedView = true
        formSheetController.interactivePanGestureDismissalDirection = .All;
        
        // Blur will be applied to all MZFormSheetPresentationControllers by default
        MZFormSheetPresentationController.appearance().shouldApplyBackgroundBlurEffect = true
        
        let presentedViewController = navigationController.viewControllers.first as! IdentitySSNModalViewController
        
        // keep passing along user data to modal
        presentedViewController.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
        presentedViewController.navigationItem.leftItemsSupplementBackButton = true
        
        // Be sure to update current module on storyboard
        self.presentViewController(formSheetController, animated: true, completion: nil)
    }
}


extension IdentityVerificationViewController {
    func addHelpButton() {
        // Offset by 20 pixels vertically to take the status bar into account
        navigationBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 50)
        navigationBar.backgroundColor = UIColor.clearColor()
        navigationBar.tintColor = UIColor.lightBlue()
        navigationBar.delegate = self
        
        // Assign the navigation item to the navigation bar
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.lightBlue()]
        
        // Create left and right button for navigation item
        rightButton = UIBarButtonItem(title: "Encryption", style: .Plain, target: self, action: #selector(self.presentTutorial(_:)))
        rightButton.setTitleTextAttributes([
            NSForegroundColorAttributeName:UIColor.darkBlue(),
            NSFontAttributeName: UIFont(name: "MyriadPro-Regular", size: 17)!
            ], forState: UIControlState.Normal)
        // Create two buttons for the navigation item
        navigationItem.rightBarButtonItem = rightButton
        
        // Assign the navigation item to the navigation bar
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.lightBlue()]
        navigationBar.items = [navigationItem]
        
        self.view.addSubview(navigationBar)
    }
    
    func presentTutorial(sender: AnyObject) {
        var preferences = EasyTipView.Preferences()
        preferences.drawing.font = UIFont(name: "MyriadPro-Regular", size: 13)!
        preferences.drawing.foregroundColor = UIColor.whiteColor()
        preferences.drawing.backgroundColor = UIColor.skyBlue()
        preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.Top
        tipView.show(forView: self.passportCardButton, withinSuperview: self.view)
        
        Answers.logCustomEventWithName("Identity Security Tutorial Presented",
                                       customAttributes: [:])
        
    }
}

    