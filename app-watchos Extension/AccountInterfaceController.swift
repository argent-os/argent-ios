//
//  AccountInterfaceController.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 3/30/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import WatchKit
import Alamofire
import WatchConnectivity
import SwiftyJSON

class AccountInterfaceController: WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet var availableBalanceLabel: WKInterfaceLabel!
    @IBOutlet var pendingBalanceLabel: WKInterfaceLabel!
    
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        print("\(applicationContext)")
        dispatch_async(dispatch_get_main_queue(), {
            //update UI here
            // Get data using Alamofire, data passed from login
            // let accountId = applicationContext["account_id"]!.stringValue
            // print(applicationContext["stripe_key"]!)
            
            // check for token, get profile id based on token and make the request
            if let token = applicationContext["token"]  {
                // print("got token in account interface")
                User.getProfile(token as! String, completionHandler: { (user, error) in
                    let headers = [
                        "Authorization": "Bearer " + (token as! String),
                        "Content-Type": "application/x-www-form-urlencoded"
                    ]
                    
                    // print("about to get account balance")
                    Alamofire.request(.GET, Root.API_URL + "/stripe/" + (user?.id)! + "/balance",
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
                                let titleOfAlert = "Account loaded"
                                let messageOfAlert = ""
                                self.presentAlertControllerWithTitle(titleOfAlert, message: messageOfAlert, preferredStyle: .Alert, actions: [WKAlertAction(title: "Close", style: .Default){
                                    //something after clicking OK
                                    }])
                                
                            } else {
                                print("red light")
                                let titleOfAlert = "Account not loaded :("
                                let messageOfAlert = "Contact support for assistance"
                                self.presentAlertControllerWithTitle(titleOfAlert, message: messageOfAlert, preferredStyle: .Alert, actions: [WKAlertAction(title: "Ok", style: .Default){
                                    //something after clicking OK
                                    }])
                                
                            }
                            
                            switch response.result {
                            case .Success:
                                if let value = response.result.value {
                                    let data = JSON(value)
                                    let balance = data["balance"]
                                    let formatter = NSNumberFormatter()
                                    formatter.numberStyle = .CurrencyStyle
                                    // formatter.locale = NSLocale.currentLocale() // This is the default
                                    // print(data)
                                    let availableNum = formatter.stringFromNumber(Float(balance["available"][0]["amount"].stringValue)!/100)
                                    let pendingNum = formatter.stringFromNumber(Float(balance["pending"][0]["amount"].stringValue)!/100)
                                    self.availableBalanceLabel.setText(availableNum)
                                    self.pendingBalanceLabel.setText(pendingNum)
                                }
                            case .Failure(let error):
                                print(error)
                            }
                    }
                })
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



