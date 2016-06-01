//
//  Subscription.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 6/1/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class Subscription {
    
    static let sharedInstance = Subscription(id: "", name: "", interval: "", currency: "", amount: "", statement_desc: "")
    
//    "id": "sub_8OMVmpK49XZW1n",
//    "object": "subscription",
//    "application_fee_percent": null,
//    "cancel_at_period_end": false,
//    "canceled_at": null,
//    "created": 1462405921,
//    "current_period_end": 1465084321,
//    "current_period_start": 1462405921,
//    "customer": "cus_8OMUpXvsmp2Tcu",
//    "discount": null,
//    "ended_at": null,
//    "plan": {
//        "id": "platinum-expert-302",
//        "object": "plan",
//        "amount": 999,
//        "created": 1462405911,
//        "currency": "usd",
//        "interval": "month",
//        "interval_count": 1,
//        "livemode": false,
//        "name": "Platinum Expert",
//        "statement_descriptor": null,
//        "trial_period_days": null
//    },
//    "quantity": 1,
//    "start": 1462405921,
//    "status": "active",
//    "tax_percent": null,
//    "trial_end": null,
//    "trial_start": null
    
    let id: Optional<String>
    let name: Optional<String>
    let interval: Optional<String>
    let currency: Optional<String>
    let amount: Optional<String>
    let statement_desc: Optional<String>
    
    required init(id: String, name: String, interval: String, currency: String, amount: String, statement_desc: String) {
        self.id = id
        self.name = name
        self.interval = interval
        self.currency = currency
        self.amount = amount
        self.statement_desc = statement_desc
    }
    
    class func createSubscription(dic: Dictionary<String, String>, completionHandler: (Bool, String) -> Void) {
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
    
    class func getSubscriptionList(completionHandler: ([Subscription]?, NSError?) -> Void) {
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
                
                let endpoint = API_URL + "/v1/stripe/" + user_id! + "/subscriptions?limit=" + limit
                
                print("get got")
                Alamofire.request(.GET, endpoint, parameters: parameters, encoding: .URL, headers: headers)
                    .validate().responseJSON { response in
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                print(response)
                                let data = JSON(value)
                                print(data)
                                var subscriptionsArray = [Subscription]()
                                let subscriptions = data["subscriptions"]["data"].arrayValue
                                for subscription in subscriptions {
                                    let id = subscription["id"].stringValue
                                    let amount = subscription["amount"].stringValue
                                    let name = subscription["name"].stringValue
                                    let interval = subscription["interval"].stringValue
                                    let statement_desc = subscription["statement_descriptor"].stringValue
                                    let item = Subscription(id: id, name: name, interval: interval, currency: "", amount: amount, statement_desc: statement_desc)
                                    subscriptionsArray.append(item)
                                }
                                completionHandler(subscriptionsArray, response.result.error)
                            }
                        case .Failure(let error):
                            print(error)
                        }
                }
            })
        }
    }
    
    class func getDelegatedPlanList(delegatedUsername: String, completionHandler: ([Plan]?, NSError?) -> Void) {
        // request to api to get data as json, put in list and table
        
        // check for token, get profile id based on token and make the request
        
        let parameters : [String : AnyObject] = [:]
        
        let headers = [
            "Authorization": "Bearer " + (userAccessToken as! String),
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        let limit = "100"
        let delegated_username = delegatedUsername
        
        let endpoint = API_URL + "/v1/stripe/plans/" + delegated_username + "?limit=" + limit
        
        Alamofire.request(.GET, endpoint, parameters: parameters, encoding: .URL, headers: headers)
            .validate().responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let data = JSON(value)
                        var plansArray = [Plan]()
                        let plans = data["subscriptions"]["data"].arrayValue
                        for plan in plans {
                            let id = plan["id"].stringValue
                            let amount = plan["amount"].stringValue
                            let name = plan["name"].stringValue
                            let interval = plan["interval"].stringValue
                            let statement_desc = plan["statement_descriptor"].stringValue
                            let item = Plan(id: id, name: name, interval: interval, currency: "", amount: amount, statement_desc: statement_desc)
                            plansArray.append(item)
                        }
                        completionHandler(plansArray, response.result.error)
                    }
                case .Failure(let error):
                    print(error)
                }
        }
    }
    
}