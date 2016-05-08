//
//  PayMerchantViewController.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 5/8/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import MZFormSheetPresentationController
import XLActionController
import Alamofire
import Stripe
import SwiftyJSON
import JGProgressHUD

class PayMerchantViewController: UIViewController, STPPaymentCardTextFieldDelegate, PKPaymentAuthorizationViewControllerDelegate, UITextFieldDelegate {
    
    var detailUser: User? {
        didSet {
        }
    }
    
    let currencyFormatter = NSNumberFormatter()

    let chargeInputView = UITextField()

    let merchantLabel = UILabel()

    let selectPaymentOptionButton:UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This will set to only one instance
        
        // screen width and height:
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.barTintColor = UIColor.lightGrayColor()
        
        merchantLabel.frame = CGRect(x: 0, y: 20, width: 300, height: 20)
        merchantLabel.text = "Pay " + (detailUser?.first_name)!
        merchantLabel.textAlignment = .Center
        merchantLabel.font = UIFont(name: "Avenir-Light", size: 16)
        merchantLabel.textColor = UIColor.lightGrayColor()
        self.view.addSubview(merchantLabel)
        
        chargeInputView.delegate = self
        chargeInputView.frame = CGRect(x: 0, y: 70, width: 300, height: 100)
        chargeInputView.textColor = UIColor.mediumBlue()
        chargeInputView.font = UIFont(name: "Avenir-Light", size: 48)
        chargeInputView.textAlignment = .Center
        chargeInputView.keyboardType = .NumberPad
        chargeInputView.placeholder = "$0.00"
        chargeInputView.addTarget(self, action: #selector(PayMerchantViewController.textField(_:shouldChangeCharactersInRange:replacementString:)), forControlEvents: UIControlEvents.EditingChanged)

        selectPaymentOptionButton.frame = CGRect(x: 20, y: 220, width: 260, height: 60)
        selectPaymentOptionButton.layer.borderColor = UIColor.whiteColor().CGColor
        selectPaymentOptionButton.layer.borderWidth = 1
        selectPaymentOptionButton.layer.cornerRadius = 10
        selectPaymentOptionButton.backgroundColor = UIColor.mediumBlue()
        var attribs: [String: AnyObject] = [:]
        attribs[NSFontAttributeName] = UIFont(name: "Avenir-Roman", size: 14)
        attribs[NSForegroundColorAttributeName] = UIColor.whiteColor()
        let str = NSAttributedString(string: "Select Payment Option", attributes: attribs)
        selectPaymentOptionButton.setAttributedTitle(str, forState: .Normal)
        selectPaymentOptionButton.addTarget(self, action: #selector(PayMerchantViewController.showPayModal(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(selectPaymentOptionButton)

    }
    
    override func viewDidDisappear(animated: Bool) {
        
    }
    
    override func viewDidAppear(animated: Bool) {
        print("got it")
        self.view.addSubview(chargeInputView)
        chargeInputView.becomeFirstResponder()
    }
    
    func close() -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        // Construct the text that will be in the field if this change is accepted
        var oldText = chargeInputView.text! as NSString
        var newText = oldText.stringByReplacingCharactersInRange(range, withString: string) as NSString!
        var newTextString = String(newText)
        
        let digits = NSCharacterSet.decimalDigitCharacterSet()
        var digitText = ""
        for c in newTextString.unicodeScalars {
            if digits.longCharacterIsMember(c.value) {
                digitText.append(c)
            }
        }
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: "en_US")
        var numberFromField = (NSString(string: digitText).doubleValue)/100
        newText = formatter.stringFromNumber(numberFromField)
        
        textField.text = String(newText)
        
        return false
    }
    
    // MARK: Payment Options Modal
    
    func showPayModal(sender: AnyObject) {
        let actionController = ArgentActionController()
        actionController.headerData = "Select Payment Method"
        actionController.addAction(Action("Apple Pay", style: .Default, handler: { action in
            self.chargeInputView.endEditing(true)
            Timeout(0.5) {
                self.showApplePayModal(self)
                print("showing apple pay modal")
            }
        }))
        actionController.addAction(Action("Credit Card", style: .Default, handler: { action in
            Timeout(0.5) {
                print("showing pay modal")
            }
        }))
        actionController.addSection(ActionSection())
        actionController.addAction(Action("Cancel", style: .Destructive, handler: { action in
        }))
        self.presentViewController(actionController, animated: true, completion: { _ in
            print("presented modal")
        })
    }
    
    
    // MARK: APPLE PAY
    
    
    func showApplePayModal(sender: AnyObject) {
        guard let request = Stripe.paymentRequestWithMerchantIdentifier(merchantID) else {
            // request will be nil if running on < iOS8
            return
        }
        print("amount is ")
        var str = chargeInputView.text
        str?.removeAtIndex(str!.characters.indices.first!) // remove first letter
        let floatValue = (str! as NSString).floatValue
        request.paymentSummaryItems = [
            PKPaymentSummaryItem(label: (detailUser?.first_name)!, amount: NSDecimalNumber(float: floatValue))
        ]
        if (Stripe.canSubmitPaymentRequest(request)) {
            let paymentController = PKPaymentAuthorizationViewController(paymentRequest: request)
            paymentController.delegate = self
            self.presentViewController(paymentController, animated: true, completion: nil)
        } else {
            // let paymentController = PaymentViewController()
            // Below displays manual credit card entry forms
            // presentViewController(paymentController, animated: true, completion: nil)
            // Show the user your own credit card form (see options 2 or 3)
        }
    }
    
    func paymentCardTextFieldDidChange(textField: STPPaymentCardTextField) {
        // Toggle navigation, for example
//        saveButton.enabled = textField.valid
    }
    
    // STRIPE SAVE METHOD
    @IBAction func save(sender: UIButton) {
//        if let card = paymentTextField.card {
//            STPAPIClient.sharedClient().createTokenWithCard(card) { (token, error) -> Void in
//                if let error = error  {
//                    print(error)
//                }
//                else if let token = token {
//                    self.createBackendChargeWithToken(token) { status in
//                        print(status)
//                    }
//                }
//            }
//        }
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
            // close pay modal
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
        // SEND REQUEST TO Argent API ENDPOINT TO EXCHANGE STRIPE TOKEN
        
        let url = apiUrl + "/v1/stripe/charge/create"
        
        let headers = [
            "Authorization": "Bearer " + String(userAccessToken),
            "Content-Type": "application/json"
        ]
        let parameters : [String : AnyObject] = [
            "token": String(token) ?? "",
            "delegatedUser": (detailUser?.username)!
        ]
        
        // for invalid character 0 be sure the content type is application/json and enconding is .JSON
        Alamofire.request(.POST, url,
            parameters: parameters,
            encoding:.JSON,
            headers: headers)
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        print(PKPaymentAuthorizationStatus.Success)
                        completion(PKPaymentAuthorizationStatus.Success)
                    }
                case .Failure(let error):
                    print(PKPaymentAuthorizationStatus.Failure)
                    completion(PKPaymentAuthorizationStatus.Failure)
                    print(error)
                }
        }
    }
    
    func paymentAuthorizationViewControllerDidFinish(controller: PKPaymentAuthorizationViewController) {
        dismissViewControllerAnimated(true, completion: nil)
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
}