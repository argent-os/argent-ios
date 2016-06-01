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

class IdentityVerificationViewController: UIViewController, ImagePickerDelegate {
    
    private var identityCardButton = UIButton()

    private var passportCardButton = UIButton()

    private var driversLicenseButton = UIButton()

    private var socialSecurityButton = UIButton()
    
    private let imagePickerController = ImagePickerController()

    let imageView = UIImageView()
    
    let screen = UIScreen.mainScreen().bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        loadData()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func configure() {
        
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        self.navigationItem.title = "Identity Verification"
        self.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont.systemFontOfSize(14),
            NSForegroundColorAttributeName: UIColor.darkGrayColor()
        ]
        
        passportCardButton.frame = CGRect(x: 30, y: 100, width: screenWidth-60, height: 80)
        passportCardButton.setTitle(" Passport", forState: .Normal)
        passportCardButton.setImage(UIImage(named: "IconPassport"), forState: .Normal)
        passportCardButton.setTitleColor(UIColor.lightBlue(), forState: .Normal)
        passportCardButton.setTitleColor(UIColor.mediumBlue(), forState: .Highlighted)
        passportCardButton.layer.borderColor = UIColor.lightBlue().colorWithAlphaComponent(0.5).CGColor
        passportCardButton.layer.borderWidth = 1
        passportCardButton.layer.cornerRadius = 10
        passportCardButton.backgroundColor = UIColor.clearColor()
        self.passportCardButton.addTarget(self, action: #selector(IdentityVerificationViewController.openCamera(_:)), forControlEvents: .TouchUpInside)
        addSubviewWithBounce(passportCardButton, parentView: self, duration: 0.3)
        
        // Add only on US/CA/AU Location
        self.identityCardButton.frame = CGRect(x: 30, y: 200, width: screenWidth-60, height: 80)
        self.identityCardButton.setTitle(" Identity Card", forState: .Normal)
        self.identityCardButton.setImage(UIImage(named: "IconIdentityCard"), forState: .Normal)
        self.identityCardButton.setTitleColor(UIColor.lightBlue(), forState: .Normal)
        self.identityCardButton.setTitleColor(UIColor.mediumBlue(), forState: .Highlighted)
        self.identityCardButton.layer.borderColor = UIColor.lightBlue().colorWithAlphaComponent(0.5).CGColor
        self.identityCardButton.layer.borderWidth = 1
        self.identityCardButton.layer.cornerRadius = 10
        self.identityCardButton.backgroundColor = UIColor.clearColor()
        self.identityCardButton.addTarget(self, action: #selector(IdentityVerificationViewController.openCamera(_:)), forControlEvents: .TouchUpInside)
        
        self.driversLicenseButton.frame = CGRect(x: 30, y: 300, width: screenWidth-60, height: 80)
        self.driversLicenseButton.setTitle(" Driver's License", forState: .Normal)
        self.driversLicenseButton.setImage(UIImage(named: "IconIdentityCard"), forState: .Normal)
        self.driversLicenseButton.setTitleColor(UIColor.lightBlue(), forState: .Normal)
        self.driversLicenseButton.setTitleColor(UIColor.mediumBlue(), forState: .Highlighted)
        self.driversLicenseButton.layer.borderColor = UIColor.lightBlue().colorWithAlphaComponent(0.5).CGColor
        self.driversLicenseButton.layer.borderWidth = 1
        self.driversLicenseButton.layer.cornerRadius = 10
        self.driversLicenseButton.backgroundColor = UIColor.clearColor()
        self.driversLicenseButton.addTarget(self, action: #selector(IdentityVerificationViewController.openCamera(_:)), forControlEvents: .TouchUpInside)
        
        self.socialSecurityButton.frame = CGRect(x: 30, y: 400, width: screenWidth-60, height: 80)
        self.socialSecurityButton.setTitle(" Social Security Number", forState: .Normal)
        self.socialSecurityButton.setImage(UIImage(named: "IconIdentityCard"), forState: .Normal)
        self.socialSecurityButton.setTitleColor(UIColor.lightBlue(), forState: .Normal)
        self.socialSecurityButton.setTitleColor(UIColor.mediumBlue(), forState: .Highlighted)
        self.socialSecurityButton.layer.borderColor = UIColor.lightBlue().colorWithAlphaComponent(0.5).CGColor
        self.socialSecurityButton.layer.borderWidth = 1
        self.socialSecurityButton.layer.cornerRadius = 10
        self.socialSecurityButton.backgroundColor = UIColor.clearColor()
    }
    
    func loadData() {
        User.getProfile { (user, err) in
            if user?.country == "US" || user?.country == "AU" || user?.country == "CA" {
                addSubviewWithBounce(self.identityCardButton, parentView: self, duration: 0.4)
                
                addSubviewWithBounce(self.driversLicenseButton, parentView: self, duration: 0.5)
                
                addSubviewWithBounce(self.socialSecurityButton, parentView: self, duration: 0.6)
            }
        }
    }
    
    func openCamera(sender: AnyObject) {
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 1
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height

        presentViewController(imagePickerController, animated: true, completion: { void in
            let overlayView = UIView()
            overlayView.frame = CGRect(x: 10, y: screenHeight*0.25, width: screenWidth-20, height: 210)
            overlayView.layer.cornerRadius = 10
            overlayView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.2)
            self.imagePickerController.view.addSubview(overlayView)

            var overlayText = UILabel()
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
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        imageView.center = self.view.center
        imageView.layer.cornerRadius = imageView.frame.size.width/2
        imageView.layer.masksToBounds = true
        self.dismissViewControllerAnimated(true, completion: nil)
        Timeout(0.3) {
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
        
        if(userAccessToken != nil) {
            User.getProfile { (user, NSError) in
                
                let endpoint = API_URL + "/v1/cloudinary/" + (user?.id)! + "/upload"
                
                let parameters = [:]
                
                let img = UIImageJPEGRepresentation(uploadedImage, 1)
                
                if(img==nil)  { return; }
                
                let imageData: NSData = NSData(data: img!)
                
                let fileSize = Float(imageData.length) / 1024.0 / 1024.0
                let fileSizeString = String.localizedStringWithFormat("%.2f", fileSize)
                NSLog("File size is : %.2f MB", fileSize)
                
                if(fileSize > 1.25) {
                    self.dismissViewControllerAnimated(true, completion: nil)
                    self.imageView.removeFromSuperview()
                } else {
                    Alamofire.upload(.POST, endpoint, multipartFormData: {
                        multipartFormData in
                        
                        multipartFormData.appendBodyPart(data: imageData, name: "avatar", fileName: "avatar", mimeType: "image/jpg")
                        
                        for (key, value) in parameters {
                            multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key as! String)
                        }
                        
                        }, encodingCompletion: {
                            encodingResult in
                            
                            switch encodingResult {
                            case .Success(let upload, _, _):
                                upload.responseJSON(completionHandler: { response in
                                    switch response.result {
                                    case .Success:
                                        print("success")
                                    case .Failure(let error):
                                        print("failure")
                                    }
                                })
                            case .Failure(let encodingError):
                                print(encodingError)
                            }
                    })
                }
            }
        }
    }
}

    