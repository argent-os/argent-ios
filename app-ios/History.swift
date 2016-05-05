//
//  History.swift
//  argent-ios
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
        
        // check for token, get profile id based on token and make the request
        if(userAccessToken != nil) {
            User.getProfile({ (user, error) in
                if error != nil {
                    print(error)
                }
                
                let parameters : [String : AnyObject] = [:]
                
                let headers = [
                    "Authorization": "Bearer " + (userAccessToken as! String),
                    "Content-Type": "application/x-www-form-urlencoded"
                ]
                
                let limit = "100"
                let user_id = (user?.id)
                
                let endpoint = apiUrl + "/v1/stripe/" + user_id! + "/balance/transactions?limit=" + limit
                
                Alamofire.request(.GET, endpoint, parameters: parameters, encoding: .URL, headers: headers)
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
                                for history in accountHistories {
                                    let amount = history["amount"].stringValue
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
            })
        }
    }
}