//
//  SearchDetailViewController.swift
//  protonpay-ios
//
//  Created by Sinan Ulkuatam on 4/20/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import UIKit
import Foundation
import MessageUI
import Stripe
import JGProgressHUD
import Alamofire
import SwiftyJSON

class SearchDetailViewController: UIViewController, MFMailComposeViewControllerDelegate, STPPaymentCardTextFieldDelegate, PKPaymentAuthorizationViewControllerDelegate {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var stacks: UIStackView!
    let paymentTextField = STPPaymentCardTextField()
    var saveButton: UIButton! = nil;
    let lbl:UILabel = UILabel()

    var detailUser: User? {
        didSet {
            configureView()
        }
    }
    
    func configureView() {
        
        paymentTextField.frame = CGRectMake(15, 15, CGRectGetWidth(self.view.frame) - 30, 44)
        paymentTextField.delegate = self
        view.addSubview(paymentTextField)
        
        if let detailUser = detailUser {
            if let usernameLabel = usernameLabel {
                usernameLabel.text = detailUser.username
            }
            if let emailLabel = emailLabel {
                emailLabel.text = detailUser.email
            }
            
            // Email textfield
            lbl.text = detailUser.first_name + " " + detailUser.last_name
            lbl.frame = CGRectMake(0, 160, width, 110)
            lbl.textAlignment = .Center
            lbl.textColor = UIColor.whiteColor()
            lbl.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin]
            self.view.addSubview(lbl)

            // User image
            let pic = detailUser.picture
            if pic != "" {
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
                
                // Blurview
                let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
                visualEffectView.frame = CGRectMake(0, 0, width, 250)
                let blurImageView: UIImageView = UIImageView(frame: CGRectMake(0, 0, width, 250))
                blurImageView.contentMode = .ScaleAspectFill
                blurImageView.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin]
                blurImageView.layer.masksToBounds = true
                blurImageView.clipsToBounds = true
                blurImageView.image = img
                self.view.addSubview(blurImageView)
                blurImageView.addSubview(visualEffectView)
                self.view.sendSubviewToBack(blurImageView)
            } else {
                let img: UIImage = UIImage(named: "ProtonLogo")!
                let userImageView: UIImageView = UIImageView(frame: CGRectMake(width / 2, 0, 90, 90))
                userImageView.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin]
                userImageView.center = CGPointMake(self.view.bounds.size.width / 2, 135)
                userImageView.backgroundColor = UIColor.groupTableViewBackgroundColor()
                userImageView.layer.cornerRadius = userImageView.frame.size.height/2
                userImageView.layer.masksToBounds = true
                userImageView.clipsToBounds = true
                userImageView.image = img
                userImageView.layer.borderWidth = 0
                userImageView.layer.borderColor = UIColor(rgba: "#fffa").CGColor
                self.view.addSubview(userImageView)
                
                // Blurview
                let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
                visualEffectView.frame = CGRectMake(0, 0, width, 250)
                let blurImageView: UIImageView = UIImageView(frame: CGRectMake(0, 0, width, 250))
                blurImageView.contentMode = .ScaleAspectFill
                blurImageView.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin]
                blurImageView.layer.masksToBounds = true
                blurImageView.clipsToBounds = true
                blurImageView.image = img
                self.view.addSubview(blurImageView)
                blurImageView.addSubview(visualEffectView)
                self.view.sendSubviewToBack(blurImageView)
            }
            
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
            
            // Button
            let inviteButton = UIButton(frame: CGRect(x: 10, y: 265, width: (width/2)-20, height: 48.0))
            inviteButton.backgroundColor = UIColor.protonDarkBlue()
            inviteButton.tintColor = UIColor(rgba: "#fff")
            inviteButton.setTitleColor(UIColor(rgba: "#fff"), forState: .Normal)
            inviteButton.titleLabel?.font = UIFont(name: "Helvetica", size: 14)
            inviteButton.setTitle(" Apple Pay", forState: .Normal)
            inviteButton.layer.cornerRadius = 5
            inviteButton.layer.masksToBounds = true
            inviteButton.addTarget(self, action: #selector(SearchDetailViewController.showPayModal(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            view.addSubview(inviteButton)
            
            // Button
            let subscribeButton = UIButton(frame: CGRect(x: width*0.5+10, y: 265, width: (width/2)-20, height: 50.0))
            subscribeButton.backgroundColor = UIColor.protonBlue()
            subscribeButton.setTitle("Become Customer", forState: .Normal)
            subscribeButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            subscribeButton.titleLabel?.font = UIFont(name: "Helvetica", size: 14)
            subscribeButton.layer.cornerRadius = 5
            subscribeButton.layer.borderColor = UIColor(rgba: "#ffffff").CGColor
            subscribeButton.layer.masksToBounds = true
            subscribeButton.addTarget(self, action: #selector(SearchDetailViewController.showPayModal(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            view.addSubview(subscribeButton)
            
            // Email Button
            let emailButton = UIButton(frame: CGRect(x: width*0.5+10, y: 265, width: (width/2)-20, height: 50.0))
            emailButton.backgroundColor = UIColor.whiteColor()
            emailButton.setTitle("Send Message", forState: .Normal)
            emailButton.setTitleColor(UIColor.protonBlue(), forState: .Normal)
//            emailButton.setBackgroundImage(UIImage(named: "IconPerson"), forState: .Normal)
            emailButton.titleLabel?.font = UIFont(name: "Nunito-Regular", size: 14)
            emailButton.layer.cornerRadius = 5
            emailButton.layer.borderColor = UIColor.protonBlue().CGColor
            emailButton.layer.borderWidth = 1
            emailButton.layer.masksToBounds = true
            var y_co: CGFloat = self.view.frame.size.height - 60.0
            emailButton.frame = CGRectMake(10, y_co, width-20, 50.0)
            emailButton.addTarget(self, action: #selector(SearchDetailViewController.sendEmailButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            view.addSubview(emailButton)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func sendEmailButtonTapped(sender: AnyObject) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients([(detailUser?.email)!])
        mailComposerVC.setSubject("Message from Proton Payments User")
        mailComposerVC.setMessageBody("Hello!", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: STRIPE AND APPLE PAY
    @IBAction func showPayModal(sender: AnyObject) {
        // STRIPE APPLE PAY
        guard let request = Stripe.paymentRequestWithMerchantIdentifier(merchantID) else {
            // request will be nil if running on < iOS8
            return
        }
        request.paymentSummaryItems = [
            PKPaymentSummaryItem(label: (detailUser?.first_name)!, amount: 10.0)
        ]
        if (Stripe.canSubmitPaymentRequest(request)) {
            let paymentController = PKPaymentAuthorizationViewController(paymentRequest: request)
            paymentController.delegate = self
            presentViewController(paymentController, animated: true, completion: nil)
        } else {
            let paymentController = PaymentViewController()
            presentViewController(paymentController, animated: true, completion: nil)
            // Show the user your own credit card form (see options 2 or 3)
        }
    }
    
    func paymentCardTextFieldDidChange(textField: STPPaymentCardTextField) {
        // Toggle navigation, for example
        saveButton.enabled = textField.valid
    }
    
    // STRIPE SAVE METHOD
    @IBAction func save(sender: UIButton) {
        if let card = paymentTextField.card {
            STPAPIClient.sharedClient().createTokenWithCard(card) { (token, error) -> Void in
                if let error = error  {
                    print(error)
                }
                else if let token = token {
                    self.createBackendChargeWithToken(token) { status in
                        print(status)
                    }
                }
            }
        }
    }
    
    // STRIPE FUNCTIONS
    func paymentAuthorizationViewController(controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: (PKPaymentAuthorizationStatus) -> Void) {
        let HUD: JGProgressHUD = JGProgressHUD()
        HUD.showInView(self.view!)
        HUD.textLabel.text = "Payment success"
        HUD.indicatorView = JGProgressHUDSuccessIndicatorView()
        HUD.dismissAfterDelay(1)
        /*
         We'll implement this method below in 'Creating a single-use token'.
         Note that we've also been given a block that takes a
         PKPaymentAuthorizationStatus. We'll call this function with either
         PKPaymentAuthorizationStatusSuccess or PKPaymentAuthorizationStatusFailure
         after all of our asynchronous code is finished executing. This is how the
         PKPaymentAuthorizationViewController knows when and how to update its UI.
         */
        handlePaymentAuthorizationWithPayment(payment) { (PKPaymentAuthorizationStatus) -> () in
            print(PKPaymentAuthorizationStatus)
            print(payment)
            controller.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func handlePaymentAuthorizationWithPayment(payment: PKPayment, completion: PKPaymentAuthorizationStatus -> ()) {
        STPAPIClient.sharedClient().createTokenWithPayment(payment) { (token, error) -> Void in
            if error != nil {
                completion(PKPaymentAuthorizationStatus.Failure)
                return
            }
            /*
             We'll implement this below in "Sending the token to your server".
             Notice that we're passing the completion block through.
             See the above comment in didAuthorizePayment to learn why.
             */
            self.createBackendChargeWithToken(token, completion: completion)
        }
    }
    
    func createBackendChargeWithToken(token: STPToken!, completion: PKPaymentAuthorizationStatus -> ()) {
        // SEND REQUEST TO PROTON PAYMENTS API ENDPOINT TO EXCHANGE STRIPE TOKEN
        
        let url = apiUrl + "/v1/stripe/charge"
        
        let headers = [
            "Authorization": "Bearer " + String(userAccessToken),
            "Content-Type": "application/json"
        ]
        let parameters : [String : AnyObject] = [
            "token": String(token) ?? "",
        ]
        
        // for invalid character 0 be sure the content type is application/json and enconding is .JSON
        Alamofire.request(.POST, url,
            parameters: parameters,
            encoding:.JSON,
            headers: headers)
            .responseJSON { response in
                print(response.request) // original URL request
                print(response.response?.statusCode) // URL response
                print(response.data) // server data
                print(response.result) // result of response serialization
                
                // go to main view
                if(response.response?.statusCode == 200) {
                    print("green light")
                } else {
                    print("red light")
                }
                
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        print("succes in payment authorization")
                        print(PKPaymentAuthorizationStatus.Success)
                        completion(PKPaymentAuthorizationStatus.Success)
                        print(json)
                    }
                case .Failure(let error):
                    print("error occured")
                    print(PKPaymentAuthorizationStatus.Failure)
                    completion(PKPaymentAuthorizationStatus.Failure)
                    print(error)
                }
        }
    }
    
    func paymentAuthorizationViewControllerDidFinish(controller: PKPaymentAuthorizationViewController) {
        print("payment auth finished")
        dismissViewControllerAnimated(true, completion: nil)
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}

