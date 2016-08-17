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
import Crashlytics

class Plan {
    
    static let sharedInstance = Plan(id: "", name: "", interval: "", interval_count: 1, currency: "", amount: "", statement_desc: "")

    let id: Optional<String>
    let name: Optional<String>
    let interval: Optional<String>
    let interval_count: Optional<Int>
    let currency: Optional<String>
    let amount: Optional<String>
    let statement_desc: Optional<String>
    
    required init(id: String, name: String, interval: String, interval_count: Int, currency: String, amount: String, statement_desc: String) {
        self.id = id
        self.name = name
        self.interval = interval
        self.interval_count = interval_count
        self.currency = currency
        self.amount = amount
        self.statement_desc = statement_desc
    }
    
    class func createPlan(dic: Dictionary<String, AnyObject>, completionHandler: (Bool, String) -> Void) {
        if(userAccessToken != nil) {
            User.getProfile({ (user, error) in
                if error != nil {
                    print(error)
                }
                
                let headers = [
                    "Authorization": "Bearer " + (userAccessToken as! String),
                    "Content-Type": "application/json"
                ]
                let parameters : [String : AnyObject] = dic
                
                let endpoint = API_URL + "/stripe/" + (user?.id)! + "/plans"
                
                Alamofire.request(.POST, endpoint,
                    parameters: parameters,
                    encoding:.JSON,
                    headers: headers)
                    .responseJSON { response in
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                // let data = JSON(value)
                                // TODO: Update plan handling, response with success and error status codes
                                let data = JSON(value)
                                
                                if data["error"]["message"].stringValue != "" {
                                    completionHandler(false, data["error"]["message"].stringValue)
                                    Answers.logCustomEventWithName("Recurring Billing Creation failure",
                                        customAttributes: dic)
                                } else {
                                    completionHandler(true, String(response.result.error))
                                    Answers.logCustomEventWithName("Recurring Billing Creation Plan Success",
                                        customAttributes: dic)
                                }
                            }
                        case .Failure(let error):
                            print(error)
                            completionHandler(false, error.localizedDescription)
                            Answers.logCustomEventWithName("Recurring Billing Plan Error",
                                customAttributes: [
                                    "error": error.localizedDescription
                                ])
                        }
                }
            })
        }
    }

    class func getPlanList(limit: String, starting_after: String, completionHandler: ([Plan]?, NSError?) -> Void) {
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
                
                let limit = limit
                let starting_after = starting_after
                let user_id = (user?.id)
                
                var endpoint = API_URL + "/stripe/" + user_id! + "/plans"
                if starting_after != "" {
                    endpoint = API_URL + "/stripe/" + user_id! + "/plans?limit=" + limit + "&starting_after=" + starting_after
                } else {
                    endpoint = API_URL + "/stripe/" + user_id! + "/plans?limit=" + limit
                }
                
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
                                    let amount = plan["amount"].stringValue
                                    let name = plan["name"].stringValue
                                    let interval = plan["interval"].stringValue
                                    let interval_count = plan["interval_count"].intValue
                                    let statement_desc = plan["statement_descriptor"].stringValue
                                    let item = Plan(id: id, name: name, interval: interval, interval_count: interval_count, currency: "", amount: amount, statement_desc: statement_desc)
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
    
    class func getPlan(id: String, completionHandler: (JSON?, NSError?) -> Void) {
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
                
                let user_id = (user?.id)
                
                var endpoint = API_URL + "/stripe/" + user_id! + "/plans/" + id
                
                Alamofire.request(.GET, endpoint, parameters: parameters, encoding: .URL, headers: headers)
                    .validate().responseJSON { response in
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                let data = JSON(value)
                                let plan = data["plan"]
                                    let id = plan["id"].stringValue
                                    let amount = plan["amount"].stringValue
                                    let name = plan["name"].stringValue
                                    let interval = plan["interval"].stringValue
                                    let interval_count = plan["interval_count"].intValue
                                    let statement_desc = plan["statement_descriptor"].stringValue
                                    let item = Plan(id: id, name: name, interval: interval, interval_count: interval_count, currency: "", amount: amount, statement_desc: statement_desc)
                                completionHandler(plan, response.result.error)
                            }
                        case .Failure(let error):
                            print(error)
                        }
                }
            })
        }
    }
    
    class func updatePlan(id: String, dic: Dictionary<String, AnyObject>, completionHandler: (Bool?, NSError?) -> Void) {
        // request to api to get data as json, put in list and table
        
        // check for token, get profile id based on token and make the request
        if(userAccessToken != nil) {
            User.getProfile({ (user, error) in
                if error != nil {
                    print(error)
                }
                
                let parameters : [String : AnyObject] = dic
                
                let headers = [
                    "Authorization": "Bearer " + (userAccessToken as! String),
                    "Content-Type": "application/json"
                ]
                
                let user_id = (user?.id)
                
                let endpoint = API_URL + "/stripe/" + user_id! + "/plans/" + id
                
                Alamofire.request(.PUT, endpoint, parameters: parameters, encoding: .JSON, headers: headers)
                    .validate().responseJSON { response in
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                let data = JSON(value)
                                if data["error"]["message"].stringValue != "" {
                                    let err: NSError = NSError(domain: data["error"]["message"].stringValue, code: 13, userInfo: nil)
                                    completionHandler(false, err)
                                    Answers.logCustomEventWithName("Recurring Billing update failure",
                                        customAttributes: [:])
                                } else {
                                    Answers.logCustomEventWithName("Recurring Billing update success",
                                        customAttributes: [:])
                                    completionHandler(true, response.result.error)
                                }
                            }
                        case .Failure(let error):
                            print(error)
                        }
                }
            })
        }
    }
    

    class func getDelegatedPlanList(delegatedUsername: String, limit: String, starting_after: String, completionHandler: ([Plan]?, NSError?) -> Void) {
        // request to api to get data as json, put in list and table
        
        // check for token, get profile id based on token and make the request
        
        let parameters : [String : AnyObject] = [:]
        
        let headers = [
            "Authorization": "Bearer " + (userAccessToken as! String),
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        let limit = limit
        let delegated_username = delegatedUsername
        let starting_after = starting_after
        
        var endpoint = API_URL + "/stripe/plans/" + delegated_username
        if starting_after != "" {
            endpoint = API_URL + "/stripe/plans/" + delegated_username + "?limit=" + limit + "&starting_after=" + starting_after
        } else {
            endpoint = API_URL + "/stripe/plans/" + delegated_username + "?limit=" + limit
        }
        
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
                            let amount = plan["amount"].stringValue
                            let name = plan["name"].stringValue
                            let interval = plan["interval"].stringValue
                            let interval_count = plan["interval_count"].intValue
                            let statement_desc = plan["statement_descriptor"].stringValue
                            let item = Plan(id: id, name: name, interval: interval, interval_count: interval_count, currency: "", amount: amount, statement_desc: statement_desc)
                            Answers.logCustomEventWithName("Viewing Merchant Recurring Billing Plans",
                                customAttributes: [:])
                            plansArray.append(item)
                        }
                        completionHandler(plansArray, response.result.error)
                    }
                case .Failure(let error):
                    print(error)
                }
        }
    }
    
    class func deletePlan(id: String, completionHandler: (Bool?, NSError?) -> Void) {
        
        // check for token, get profile id based on token and make the request
        if(userAccessToken != nil) {
            User.getProfile({ (user, error) in
                if error != nil {
                    print(error)
                }
                
                let user_id = (user?.id)
                
                let parameters : [String : AnyObject] = [:]
                
                let headers = [
                    "Authorization": "Bearer " + (userAccessToken as! String),
                    "Content-Type": "application/json"
                ]
                
                let endpoint = API_URL + "/stripe/" + user_id! + "/plans/" + id
                
                Alamofire.request(.DELETE, endpoint, parameters: parameters, encoding: .URL, headers: headers)
                    .responseJSON { response in
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                //let data = JSON(value)
                                
                                completionHandler(true, response.result.error)
                            }
                        case .Failure(let error):
                            print(error)
                        }
                }
            })
        }
    }

}