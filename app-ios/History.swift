//
//  History.swift
//  protonpay-ios
//
//  Created by Sinan Ulkuatam on 4/22/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class History {
    
    let amount: String
    
    required init(amount: String) {
        self.amount = amount
    }
    
    class func getAccountHistory(completionHandler: ([History]?, NSError?) -> Void) {
        // request to api to get data as json, put in list and table
        print("in get account history")
        
        if(userData != nil) {
//            print(userData)
//            print(userData!["user"]["_id"])
            let parameters : [String : AnyObject] = [
                "userId": userData!["user"]["_id"].stringValue,
                "limit": "10"
            ]
            
            let headers = [
                "Authorization": "Bearer " + (userAccessToken as! String),
                "Content-Type": "application/json"
            ]
        
            let endpoint = apiUrl + "/v1/stripe/history/"
            
            Alamofire.request(.POST, endpoint, parameters: parameters, encoding: .JSON, headers: headers)
                .validate().responseJSON { response in
                    // print(response)
                    switch response.result {
                    case .Success:
                        print("success")
                        if let value = response.result.value {
                            let data = JSON(value)
                            print("got stripe account history data")
                            // print(data)
                            var historyItemsArray = [History]()
                            let accountHistories = data["transactions"]["data"].arrayValue
//                             print(data["transactions"]["data"].arrayValue)
                            for jsonItem in accountHistories {
                                let amount = jsonItem["amount"].stringValue
                                print(amount)
                                let item = History(amount: amount)
                                historyItemsArray.append(item)
                            }
                            completionHandler(historyItemsArray, response.result.error)
                        }
                    case .Failure(let error):
                        print("failed to get account history")
                        print(error)
                    }
            }
        }
    }
}