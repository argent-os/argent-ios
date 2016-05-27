//
//  Plan.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 5/3/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class Plan {
    
    static let sharedInstance = Plan(id: "", interval: "", currency: "")

    let interval: Optional<String>
    let currency: Optional<String>
    
    let id: String
    
    required init(id: String, interval: String, currency: String) {
        self.interval = interval
        self.currency = currency
        self.id = id
    }
    
    class func createPlan(dic: Dictionary<String, String>, completionHandler: (Bool, String) -> Void) {
        if(userAccessToken != nil) {
            User.getProfile({ (user, error) in
                if error != nil {
                    print(error)
                }
                
                if let plan_id = dic["planIdKey"], plan_name = dic["planNameKey"], plan_currency = dic["planCurrencyKey"], plan_amount = dic["planAmountKey"], plan_interval = dic["planIntervalKey"] {
                    
                    let headers = [
                        "Authorization": "Bearer " + (userAccessToken as! String),
                        "Content-Type": "application/json"
                    ]
                    let parameters : [String : AnyObject] = [
                        "id": plan_id,
                        "amount": plan_amount,
                        "interval": plan_interval,
                        "interval_count": 1,
                        "name": plan_name,
                        "currency": plan_currency
                    ]
                    
                    let endpoint = API_URL + "/v1/stripe/" + (user?.id)! + "/plans"
                    
                    Alamofire.request(.POST, endpoint,
                        parameters: parameters,
                        encoding:.JSON,
                        headers: headers)
                        .responseJSON { response in
                            switch response.result {
                            case .Success:
                                if let value = response.result.value {
                                    let data = JSON(value)
                                    if (response.response?.statusCode == 200) {
                                        completionHandler(true, "")
                                    } else {
                                        let err = data["error"]["message"].stringValue
                                        completionHandler(false, err)
                                    }
                                }
                            case .Failure(let error):
                                print(error)
                            }
                    }
                    
                    // if optional parameters are entered
                    if let plan_trial_period_days = dic["planTrialPeriodKey"], plan_statement_descriptor = dic["planStatementDescriptionKey"] {
                        print("set optional data")

                        let headers = [
                            "Authorization": "Bearer " + (userAccessToken as! String),
                            "Content-Type": "application/json"
                        ]
                        let parameters : [String : AnyObject] = [
                            "id": plan_id,
                            "amount": plan_amount,
                            "interval": plan_interval,
                            "interval_count": 1,
                            "name": plan_name,
                            "currency": plan_currency,
                            "trial_period_days": plan_trial_period_days,
                            "statement_descriptor": plan_statement_descriptor
                        ]
                        
                        let endpoint = API_URL + "/v1/stripe/" + (user?.id)! + "/plans"
                        
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
                
                let endpoint = API_URL + "/v1/stripe/" + user_id! + "/plans?limit=" + limit
                
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