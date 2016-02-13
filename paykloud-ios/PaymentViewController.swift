//
//  PaymentViewController.swift
//  paykloud-ios
//
//  Created by Sinan Ulkuatam on 2/12/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import Stripe


class PaymentViewController: UIViewController, STPPaymentCardTextFieldDelegate {
    
    let paymentTextField = STPPaymentCardTextField()
    var saveButton: UIButton! = nil;
    
    // This function is called before the segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "homeView") {
            let rootViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("RootViewController"))! as UIViewController
            self.presentViewController(rootViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func showPayModal() {
        // STRIPE APPLE PAY
        guard let request = Stripe.paymentRequestWithMerchantIdentifier(merchantID) else {
            // request will be nil if running on < iOS8
            return
        }
            request.paymentSummaryItems = [
            PKPaymentSummaryItem(label: "Premium Llama Food", amount: 10.0)
        ]
        if (Stripe.canSubmitPaymentRequest(request)) {
            let paymentController = PKPaymentAuthorizationViewController(paymentRequest: request)
            presentViewController(paymentController, animated: true, completion: nil)
        } else {
            // Show the user your own credit card form (see options 2 or 3)
        }
    }
    
    func paymentCardTextFieldDidChange(textField: STPPaymentCardTextField) {
        // Toggle navigation, for example
        saveButton.enabled = textField.valid
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        paymentTextField.frame = CGRectMake(15, 15, CGRectGetWidth(self.view.frame) - 30, 44)
        paymentTextField.delegate = self
        view.addSubview(paymentTextField)
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
        // SEND REQUEST TO PAYKLOUD API ENDPOINT TO EXCHANGE STRIPE TOKEN
        let url = NSURL(string: apiUrl + "/auth/token")!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        let body = "stripeToken=(token.tokenId)"
        request.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)
        let configuration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        let session = NSURLSession(configuration: configuration)
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if error != nil {
                completion(PKPaymentAuthorizationStatus.Failure)
            }
            else {
                completion(PKPaymentAuthorizationStatus.Success)
            }
        }
        task.resume()
    }
}
