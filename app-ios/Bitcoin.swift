//
//  Bitcoin.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 5/5/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class Bitcoin {
    
    let amount: Int
    let uri: String
    
    required init(amount: Int, uri: String) {
        self.amount = amount
        self.uri = uri
    }
    
    class func createBitcoinReceiver(amount: Int, completionHandler: (Bitcoin?, NSError?) -> ()) {
        if(userAccessToken != nil) {
            User.getProfile({ (user, error) in
                if error != nil {
                    print(error)
                }
                
                let headers = [
                    "Authorization": "Bearer " + (userAccessToken as! String),
                    "Content-Type": "application/json"
                ]
                let parameters : [String : AnyObject] = [
                    "amount": amount,
                ]
                
                let endpoint = apiUrl + "/v1/stripe/" + (user?.id)! + "/bitcoin"
                
                Alamofire.request(.POST, endpoint,
                    parameters: parameters,
                    encoding:.JSON,
                    headers: headers)
                    .responseJSON { response in
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                let data = JSON(value)
                                let uri = data["receiver"]["bitcoin_uri"].stringValue
                                let amount = data["receiver"]["bitcoin_amount"].intValue
                                let bitcoin = Bitcoin(amount: amount, uri: uri)
                                completionHandler(bitcoin, response.result.error)
                            }
                        case .Failure(let error):
                            print(error)
                        }
                }
            })
        }
    }
    
    class func getBitcoinReceivers(completionHandler: ([Bitcoin]?, NSError?) -> Void) {
        // request to api to get data as json, put in list and table
    }
}