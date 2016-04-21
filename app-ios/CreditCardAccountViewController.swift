//
//  CreditCardAccountViewController.swift
//  protonpay-ios
//
//  Created by Sinan Ulkuatam on 3/20/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class CreditCardAccountViewController: UIViewController, CardIOPaymentViewControllerDelegate {
    
    @IBOutlet weak var addCardButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addCardButton.backgroundColor = UIColor.protonBlue()
    }
    // CARD IO
    @IBAction func scanCard(sender: AnyObject) {
        let cardIOVC = CardIOPaymentViewController(paymentDelegate: self)
        cardIOVC.hideCardIOLogo = true
        cardIOVC.collectPostalCode = true
        cardIOVC.allowFreelyRotatingCardGuide = true
        cardIOVC.guideColor = UIColor.protonBlue()
        cardIOVC.modalPresentationStyle = .FormSheet
        presentViewController(cardIOVC, animated: true, completion: nil)
    }
    
    func userDidCancelPaymentViewController(paymentViewController: CardIOPaymentViewController!) {
        //        resultLabel.text = "Card not entered"
        paymentViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didScanCard(cardInfo: CardIOCreditCardInfo) {
        // The full card number is available as info.cardNumber, but don't log that!
        print("Received card info. Number: %@, expiry: %02i/%i, cvv: %@.", cardInfo.redactedCardNumber, cardInfo.expiryMonth, cardInfo.expiryYear, cardInfo.cvv);
        // Use the card info...
        // Post to Stripe
    }
    
    func userDidProvideCreditCardInfo(cardInfo: CardIOCreditCardInfo!, inPaymentViewController paymentViewController: CardIOPaymentViewController!) {
        print("user did provide info")
        if let info = cardInfo {
            let str = NSString(format: "Received card info.\n Number: %@\n expiry: %02lu/%lu\n cvv: %@.", info.redactedCardNumber, info.expiryMonth, info.expiryYear, info.cvv)
            print(str)
            // resultLabel.text = str as String
            // Post to Stripe

            if let token = userData?["token"].stringValue, accountId = userData?["stripe"]["accountId"].stringValue  {
                let headers = [
                    "Authorization": "Bearer " + token,
                    "Content-Type": "application/json"
                ]
                
                let parameters: [String: AnyObject] = [
                    "object": "card",
                    "exp_month": info.expiryMonth,
                    "exp_year": info.expiryYear,
                    "number": info.cardNumber,
                    "cvc": info.cvv,
                    "accountId": accountId
                ]

                // print(userData)
                print(parameters)
                let endpoint = apiUrl + "/v1/stripe/account/cards/";
                
                Alamofire.request(.POST, endpoint, parameters: parameters, encoding: .JSON, headers: headers)
                    .responseJSON { response in
                        // print(response)
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
                            }
                        case .Failure(let error):
                            print(error)
                        }
                }
            }
        }
        paymentViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
