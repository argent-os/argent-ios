//
//  Stripe.swift
//  protonpay-ios
//
//  Created by Sinan Ulkuatam on 4/22/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class History {
    
    let history: String
    
    required init(history: String) {
        self.history = history
    }
    
    class func getAccountHistory(completionHandler: ([History]?, NSError?) -> Void) {
        // request to api to get account data as json, put in list and table
        let parameters : [String : AnyObject] = [
            "accountId" : userData!["stripe"]["accountId"].stringValue
        ]
        
        let headers = [
            "Authorization": "Bearer " + (userAccessToken as! String),
            "Content-Type": "application/json"
        ]
        
        let endpoint = apiUrl + "/v1/stripe/account/history/list"
        
        print(parameters)
        
        Alamofire.request(.POST, endpoint, parameters: parameters, encoding: .JSON, headers: headers)
            .validate().responseJSON { response in
                print(response)
                switch response.result {
                case .Success:
                    print("success")
                    if let value = response.result.value {
                        let data = JSON(value)
                        print("got stripe account history data")
                        // print(data)
                        var stripeItemsArray = [History]()
                        let accountHistories = data["data"].arrayValue
                        print(data["data"].arrayValue)
                        for jsonItem in accountHistories {
                            let history = jsonItem["amount"].stringValue
                            
                            let item = History(history: history)
                            stripeItemsArray.append(item)
                        }
                        completionHandler(stripeItemsArray, response.result.error)
                    }
                case .Failure(let error):
                    print(error)
                }
        }
    }
}