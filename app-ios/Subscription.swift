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
    
    static let sharedInstance = Subscription(id: "", name: "", status: "", quantity: "", plan_name: "", plan_interval: "", plan_amount: "")
    
    let id: Optional<String>
    let name: Optional<String>
    let status: Optional<String>
    let quantity: Optional<String>
    let plan_name: Optional<String>
    let plan_interval: Optional<String>
    let plan_amount: Optional<String>
    
    required init(id: String, name: String, status: String, quantity: String, plan_name: String, plan_interval: String, plan_amount: String) {
        self.id = id
        self.name = name
        self.status = status
        self.quantity = quantity
        self.plan_name = plan_name
        self.plan_interval = plan_interval
        self.plan_amount = plan_amount
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
                
                Alamofire.request(.GET, endpoint, parameters: parameters, encoding: .URL, headers: headers)
                    .validate().responseJSON { response in
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                // print(response)
                                let data = JSON(value)
                                var subscriptionsArray = [Subscription]()
                                let subscriptions = data["subscriptions"]["data"].arrayValue
                                for subscription in subscriptions {
                                    let id = subscription["id"].stringValue
                                    let name = subscription["name"].stringValue
                                    let status = subscription["status"].stringValue
                                    let quantity = subscription["quantity"].stringValue
                                    
                                    let sub_plan = subscription["plan"]
                                    let plan_name = sub_plan["name"].stringValue
                                    let plan_interval = sub_plan["interval"].stringValue
                                    let plan_amount = sub_plan["amount"].stringValue

                                    let item = Subscription(id: id, name: name, status: status, quantity: quantity, plan_name: plan_name, plan_interval: plan_interval, plan_amount: plan_amount)
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
    
    class func deleteSubscription(id: String, completionHandler: (Bool?, NSError?) -> Void) {
        
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
                
                let endpoint = API_URL + "/v1/stripe/" + user_id! + "/subscriptions/" + id
                
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