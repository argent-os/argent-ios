//
//  CreditCardAccountViewController.swift
//  argent-ios
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
        
        self.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()

        addCardButton.layer.cornerRadius = 5
        addCardButton.backgroundColor = UIColor.mediumBlue()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()
    }
    
    // CARD IO
    @IBAction func scanCard(sender: AnyObject) {
        let cardIOVC = CardIOPaymentViewController(paymentDelegate: self)
        cardIOVC.hideCardIOLogo = true
        cardIOVC.collectPostalCode = true
        cardIOVC.allowFreelyRotatingCardGuide = true
        cardIOVC.guideColor = UIColor.mediumBlue()
        cardIOVC.modalPresentationStyle = .FormSheet
        presentViewController(cardIOVC, animated: true, completion: nil)
    }
    
    func userDidCancelPaymentViewController(paymentViewController: CardIOPaymentViewController!) {
        //        resultLabel.text = "Card not entered"
        paymentViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didScanCard(cardInfo: CardIOCreditCardInfo) {
        // The full card number is available as info.cardNumber, but don't log that!
        // print("Received card info. Number: %@, expiry: %02i/%i, cvv: %@.", cardInfo.redactedCardNumber, cardInfo.expiryMonth, cardInfo.expiryYear, cardInfo.cvv);
        // Use the card info...
        // Post to Stripe, make API call here
    }
    
    func userDidProvideCreditCardInfo(cardInfo: CardIOCreditCardInfo!, inPaymentViewController paymentViewController: CardIOPaymentViewController!) {
        if let info = cardInfo {
            _ = NSString(format: "Received card info.\n Number: %@\n expiry: %02lu/%lu\n cvv: %@.", info.redactedCardNumber, info.expiryMonth, info.expiryYear, info.cvv)
            // resultLabel.text = str as String
            // Post to Stripe

            if userAccessToken != nil  {
                let headers = [
                    "Authorization": "Bearer " + (userAccessToken as! String),
                    "Content-Type": "application/json"
                ]
                
                let parameters: [String: AnyObject] = [
                    "object": "card",
                    "exp_month": info.expiryMonth,
                    "exp_year": info.expiryYear,
                    "number": info.cardNumber,
                    "cvc": info.cvv
                ]

                let endpoint = API_URL + "/stripe/account/cards/";
                
                Alamofire.request(.POST, endpoint, parameters: parameters, encoding: .JSON, headers: headers)
                    .responseJSON { response in
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                _ = JSON(value)
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
