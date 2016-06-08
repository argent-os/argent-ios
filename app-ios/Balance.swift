//
//  Balance.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 5/4/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class Balance {
    
    let pending: Float
    let available: Float
    
    required init(pending: Float, available: Float) {
        self.pending = pending
        self.available = available
    }
    
    class func getStripeBalance(completionHandler: (Balance?, NSError?) -> Void) {
        // request to api to get data as json, put in list and table
        
        // check for token, get profile id based on token and make the request
        if(userAccessToken != nil) {
            User.getProfile({ (user, error) in
                // check for token, get profile id based on token and make the request
                if error != nil {
                    print(error)
                }
                
                let parameters : [String : AnyObject] = [:]
                
                let headers = [
                    "Authorization": "Bearer " + (userAccessToken as! String),
                    "Content-Type": "application/x-www-url-formencoded"
                ]
                
                let endpoint = API_URL + "/stripe/" + (user?.id)! + "/balance"
                
                Alamofire.request(.GET, endpoint, parameters: parameters, encoding: .URL, headers: headers)
                    .validate().responseJSON { response in
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                let data = JSON(value)
                                let balance = data["balance"]
                                let pending = balance["pending"][0]["amount"].floatValue
                                let available = balance["available"][0]["amount"].floatValue
                                let balanceObject = Balance.init(pending: pending, available: available)
                                completionHandler(balanceObject, response.result.error)
                            }
                        case .Failure(let error):
                            print(error)
                        }
                }
            })
        }
    }
}