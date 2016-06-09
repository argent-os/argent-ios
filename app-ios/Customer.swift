//
//  Customer.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 5/3/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class Customer {
    
    let id: String
    let email: String?
    
    required init(id: String, email: String) {
        self.id = id
        self.email = email
    }
    
    class func createCustomer(dic: Dictionary<String, String>) {
        if(userAccessToken != nil) {
            User.getProfile({ (user, error) in
                if error != nil {
                    print(error)
                }
                
                let headers = [
                    "Authorization": "Bearer " + (userAccessToken as! String),
                    "Content-Type": "application/json"
                ]
                
                let cust_email = dic["customerEmailKey"]
                let cust_desc = dic["customerDescriptionKey"]
                let parameters : [String : AnyObject] = [
                    "email": cust_email!,
                    "description": cust_desc ?? "",
                ]
                
                let endpoint = API_URL + "/stripe/" + (user?.id)! + "/customers"
                
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
    
    class func getCustomerList(limit: String, starting_after: String, completionHandler: ([Customer]?,  NSError?) -> Void) {
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
                
                var endpoint = API_URL + "/stripe/" + user_id! + "/customers"
                if starting_after != "" {
                    endpoint = API_URL + "/stripe/" + user_id! + "/customers?limit=" + limit + "&starting_after=" + starting_after
                } else {
                    endpoint = API_URL + "/stripe/" + user_id! + "/customers?limit=" + limit
                }
                
                Alamofire.request(.GET, endpoint, parameters: parameters, encoding: .URL, headers: headers)
                    .validate().responseJSON { response in
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                let data = JSON(value)
                                // print(data)
                                var customerArray = [Customer]()
                                let customers = data["customers"]["data"].arrayValue
                                for customer in customers {
                                    let id = customer["id"].stringValue
                                    let email = customer["email"].stringValue
                                    
                                    let customerItem = Customer(id: id, email: email)
                                    customerArray.append(customerItem)
                                }

                                completionHandler(customerArray, response.result.error)
                            }
                        case .Failure(let error):
                            print(error)
                        }
                }
            })
        }
    }
    
    
    class func getSingleCustomer(cust_id: String, completionHandler: (Customer?, [Subscription],  NSError?) -> Void) {
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
                
                let endpoint = API_URL + "/stripe/" + user_id! + "/customers/" + cust_id
                
                Alamofire.request(.GET, endpoint, parameters: parameters, encoding: .URL, headers: headers)
                    .validate().responseJSON { response in
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                let data = JSON(value)
                                // print(data)
                                var subscriptionArray = [Subscription]()
                                let customer = data["customer"]
                                let id = customer["id"].stringValue
                                let email = customer["email"].stringValue
                                
                                let customerItem = Customer(id: id, email: email)
                                
                                let subscriptions = customer["subscriptions"]["data"].arrayValue
                                for subscription in subscriptions {
                                    let id = subscription["id"].stringValue
                                    let status = subscription["status"].stringValue
                                    let quantity = subscription["quantity"].intValue
                                    let plan_name = subscription["plan"]["name"].stringValue
                                    let plan_interval = subscription["plan"]["interval"].stringValue
                                    let plan_amount = subscription["plan"]["amount"].intValue
                                    //print(subscriptions)
                                    let subscriptionItem = Subscription(id: id, status: status, quantity: quantity, plan_name: plan_name, plan_interval: plan_interval, plan_amount: plan_amount)
                                    subscriptionArray.append(subscriptionItem)
                                }
                                
                                completionHandler(customerItem, subscriptionArray, response.result.error)
                            }
                        case .Failure(let error):
                            print(error)
                        }
                }
            })
        }
    }
    
    
    class func deleteCustomer(id: String, completionHandler: (Bool?, NSError?) -> Void) {
        
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
                
                let endpoint = API_URL + "/stripe/" + user_id! + "/customers/" + id
                print("deleting customer", endpoint)
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