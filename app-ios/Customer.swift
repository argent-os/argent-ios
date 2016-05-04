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
    
    class func getCustomerList(completionHandler: ([Customer]?, NSError?) -> Void) {
        // request to api to get data as json, put in list and table
        print("in get customers list")
        
        // check for token, get profile id based on token and make the request
        if(userAccessToken != nil) {
            User.getProfile({ (user, error) in
                if error != nil {
                    print(error)
                }
                
                let parameters : [String : AnyObject] = [
                    "userId": (user?.id)!,
                    "limit": "100"
                ]
                
                let headers = [
                    "Authorization": "Bearer " + (userAccessToken as! String),
                    "Content-Type": "application/json"
                ]
                
                let endpoint = apiUrl + "/v1/stripe/customers/list"
                
                Alamofire.request(.POST, endpoint, parameters: parameters, encoding: .JSON, headers: headers)
                    .validate().responseJSON { response in
                        print(response)
                        switch response.result {
                        case .Success:
                            print("success")
                            if let value = response.result.value {
                                let data = JSON(value)
                                print(data)
                                print("got customers list data")
                                // print(data)
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
                            print("failed to get customer list")
                            print(error)
                        }
                }
            })
        }
    }
}