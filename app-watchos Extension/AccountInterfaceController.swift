//
//  AccountInterfaceController.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 3/30/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import WatchKit
import Foundation
import Alamofire
import WatchConnectivity
import SwiftyJSON

class AccountInterfaceController: WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet var availableBalanceLabel: WKInterfaceLabel!
    @IBOutlet var pendingBalanceLabel: WKInterfaceLabel!
    
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        print("\(applicationContext)")
        dispatch_async(dispatch_get_main_queue(), {
            print("update ui")
            //update UI here
            // Get data using Alamofire, data passed from login
            // let accountId = applicationContext["account_id"]!.stringValue
            // print(applicationContext["stripe_key"]!)
            
            if let stripeKey = applicationContext["stripe_key"] {
                let headers = [
                    "Authorization": "Bearer " + (stripeKey as! String),
                    "Content-Type": "application/x-www-form-urlencoded"
                ]
                
                Alamofire.request(.GET, Root.STRIPE_API_URL + "/v1/balance",
                    encoding:.URL,
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
                                let formatter = NSNumberFormatter()
                                formatter.numberStyle = .CurrencyStyle
                                // formatter.locale = NSLocale.currentLocale() // This is the default
                                let availableNum = formatter.stringFromNumber(Float(json["available"][0]["amount"].stringValue)!/100)
                                let pendingNum = formatter.stringFromNumber(Float(json["pending"][0]["amount"].stringValue)!/100)
                                self.availableBalanceLabel.setText(availableNum)
                                self.pendingBalanceLabel.setText(pendingNum)
                            }
                        case .Failure(let error):
                            print(error)
                        }
                }
            }
        })
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        let watchSession = WCSession.defaultSession()
        watchSession.delegate = self
        watchSession.activateSession()
        
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
}



