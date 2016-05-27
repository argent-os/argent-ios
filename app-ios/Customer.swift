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
    
    let email: String
    
    required init(email: String) {
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
                
                let endpoint = API_URL + "/v1/stripe/" + (user?.id)! + "/customers"
                
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
    
    class func getCustomerList(completionHandler: ([Customer]?, NSError?) -> Void) {
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
                
                let endpoint = API_URL + "/v1/stripe/" + user_id! + "/customers"
                
                Alamofire.request(.GET, endpoint, parameters: parameters, encoding: .URL, headers: headers)
                    .validate().responseJSON { response in
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                let data = JSON(value)
                                var customerArray = [Customer]()
                                let customers = data["customers"]["data"].arrayValue
                                for customer in customers {
                                    let email = customer["email"].stringValue
                                    let item = Customer(email: email)
                                    customerArray.append(item)
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
}