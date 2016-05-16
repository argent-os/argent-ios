//
//  Charge.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 5/9/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class Charge {
    
    let interval: Optional<String>
    
    let id: String
    
    required init(id: String, interval: String) {
        self.interval = interval
        self.id = id
    }
    
    class func createCharge(dic: Dictionary<String, String>) {
        if(userAccessToken != nil) {
            User.getProfile({ (user, error) in
                if error != nil {
                    print(error)
                }
                
                // Post plan using Alamofire
                let plan_id = dic["planIdKey"]
                let plan_name = dic["planNameKey"]
                let plan_currency = dic["planCurrencyKey"]
                let plan_amount = dic["planAmountKey"]
                let plan_interval = dic["planIntervalKey"]
                let plan_trial_period = dic["planTrialPeriodKey"]
                let plan_statement_desc = dic["planStatementDescriptionKey"]
                
                let headers = [
                    "Authorization": "Bearer " + (userAccessToken as! String),
                    "Content-Type": "application/json"
                ]
                let parameters : [String : AnyObject] = [
                    "id": plan_id!,
                    "amount": plan_amount!,
                    "interval": plan_interval!,
                    "name": plan_name!,
                    "currency": plan_currency!
                ]
                
                let endpoint = apiUrl + "/v1/stripe/" + (user?.id)! + "/plans"
                
                Alamofire.request(.POST, endpoint,
                    parameters: parameters,
                    encoding:.JSON,
                    headers: headers)
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
            })
        }
    }
    
    class func getPlanList(completionHandler: ([Plan]?, NSError?) -> Void) {
        // request to api to get data as json, put in list and table
        
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
                
                let endpoint = apiUrl + "/v1/stripe/" + user_id! + "/plans?limit=" + limit
                
                Alamofire.request(.GET, endpoint, parameters: parameters, encoding: .URL, headers: headers)
                    .validate().responseJSON { response in
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                let data = JSON(value)
                                var plansArray = [Plan]()
                                let plans = data["plans"]["data"].arrayValue
                                for plan in plans {
                                    let id = plan["id"].stringValue
                                    let item = Plan(id: id, interval: "", currency: "")
                                    plansArray.append(item)
                                }
                                completionHandler(plansArray, response.result.error)
                            }
                        case .Failure(let error):
                            print(error)
                        }
                }
            })
        }
    }
}