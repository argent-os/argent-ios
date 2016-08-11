//
//  User.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 4/6/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import Crashlytics

class User {
    
    let id: String
    let tenant_id: String
    let username: String
    let email: String
    let first_name: String
    let last_name: String
    let business_name: String
    let picture: String
    let phone: String
    let country: String
    let plaid_access_token: String
    
    required init(id: String, tenant_id: String, username: String, email: String, first_name: String, last_name: String, business_name: String, picture: String, phone: String, country: String, plaid_access_token: String) {
        self.id = id
        self.tenant_id = tenant_id
        self.username = username
        self.email = email
        self.first_name = first_name
        self.last_name = last_name
        self.business_name = business_name
        self.picture = picture
        self.phone = phone
        self.country = country
        self.plaid_access_token = plaid_access_token
    }
    
    class func getProfile(completionHandler: (User?, NSError?) -> Void) {
        // request to api to get account data as json, put in list and table
        // curl -X GET -i -H "Content-Type: application/json" -d '{"access_token": ""}' http://192.168.1.232:5001/v1/profile

        if(userAccessToken != nil) {
            
            let parameters : [String : AnyObject] = [:]
            
            let headers = [
                "Authorization": "Bearer " + (userAccessToken as! String),
                "Content-Type": "application/x-www-form-urlencoded"
            ]
            
            let endpoint = API_URL + "/profile"
            
            Alamofire.request(.GET, endpoint, parameters: parameters, encoding: .URL, headers: headers)
                .responseJSON { response in
                    switch response.result {
                    case .Success:
                        if let value = response.result.value {
                            let data = JSON(value)
                            if(data["message"] == "No token supplied") {
                                print("no token")
                                HomeViewController().logout()  
                            }
                            let profile = data
                                let id = profile["_id"].stringValue
                                let tenant_id = profile["tenant_id"].stringValue
                                let username = profile["username"].stringValue
                                let email = profile["email"].stringValue
                                let first_name = profile["first_name"].stringValue
                                let last_name = profile["last_name"].stringValue
                                let business_name = profile["business"]["name"].stringValue
                                let picture = profile["picture"]["secure_url"].stringValue
                                let phone = profile["phone_number"].stringValue
                                let country = profile["country"].stringValue
                                let plaid_access_token = profile["plaid"]["access_token"].stringValue
                            Answers.logCustomEventWithName("Profile GET success",
                                customAttributes: [
                                    "user": username
                                ])
                            let item = User(id: id, tenant_id: tenant_id, username: username, email: email, first_name: first_name, last_name: last_name, business_name: business_name, picture: picture, phone: phone, country: country, plaid_access_token: plaid_access_token)
                                completionHandler(item, response.result.error)
                        }
                    case .Failure(let error):
                        print(error)
                        Answers.logCustomEventWithName("Profile GET failed",
                            customAttributes: [
                                "error": error.localizedDescription
                            ])
                    }
            }
        }
    }
    
    class func saveProfile(dic: Dictionary<String, AnyObject>, completionHandler: (User?, Bool, NSError?) -> Void) {
        // request to api to get account data as json, put in list and table
        // curl -X PUT -i -H "Content-Type: application/json" -d '{"access_token": ""}' http://192.168.1.232:5001/v1/profile
        
        if(userAccessToken != nil) {

            let parameters : [String : AnyObject] = dic
            
            let headers = [
                "Authorization": "Bearer " + (userAccessToken as! String),
                "Content-Type": "application/json"
            ]
                        
            let endpoint = API_URL + "/profile"
            
            print(parameters)
            
            Alamofire.request(.PUT, endpoint, parameters: parameters, encoding: .JSON, headers: headers)
                .responseJSON { response in
                    switch response.result {
                    case .Success:
                        if let value = response.result.value {
                            let data = JSON(value)
                            let profile = data
                            let id = profile["_id"].stringValue
                            let tenant_id = profile["tenant_id"].stringValue
                            let username = profile["username"].stringValue
                            let email = profile["email"].stringValue
                            let first_name = profile["first_name"].stringValue
                            let last_name = profile["last_name"].stringValue
                            let business_name = profile["business"]["name"].stringValue
                            let picture = profile["picture"]["secure_url"].stringValue
                            let phone = profile["phone_number"].stringValue
                            let country = profile["country"].stringValue
                            let plaid_access_token = profile["plaid"]["access_token"].stringValue
                            let item = User(id: id, tenant_id: tenant_id, username: username, email: email, first_name: first_name, last_name: last_name, business_name: business_name, picture: picture, phone: phone, country: country, plaid_access_token: plaid_access_token)
                            Answers.logCustomEventWithName("Profile update success",
                                customAttributes: [
                                    "user": username
                                ])
                            completionHandler(item, true, response.result.error)
                        }
                    case .Failure(let error):
                        print(error)
                        Answers.logCustomEventWithName("Profile update failed",
                            customAttributes: [
                                "error": error.localizedDescription
                            ])
                    }
            }
        }
    }
    
    class func getUserAccounts(completionHandler: ([User]?, NSError?) -> Void) {
        // request to api to get account data as json, put in list and table
        // curl -X GET -i -H "Content-Type: application/json" -d '{"access_token": ""}' http://192.168.1.232:5001/v1/users/list
        
        let parameters : [String : AnyObject] = [:]
        
        let headers : [String : String] = [:]
        
        let endpoint = API_URL + "/user/list"
        
        Alamofire.request(.GET, endpoint, parameters: parameters, encoding: .URL, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let data = JSON(value)
                        var userItemsArray = [User]()
                        let users = data["users"].arrayValue
                        for user in users {
                            let id = ""
                            let tenant_id = ""
                            let username = user["username"].stringValue
                            let email = ""
                            let first_name = user["first_name"].stringValue
                            let last_name = user["last_name"].stringValue
                            let business_name = user["business_name"].stringValue
                            let picture = user["picture"].stringValue
                            let country = user["country"].stringValue
                            let phone = ""
                            let plaid_access_token = ""
                            let item = User(id: id, tenant_id: tenant_id, username: username, email: email, first_name: first_name, last_name: last_name, business_name: business_name, picture: picture, phone: phone, country: country, plaid_access_token: plaid_access_token)
                            userItemsArray.append(item)
                        }
                        completionHandler(userItemsArray, response.result.error)
                    }
                case .Failure(let error):
                    print(error)
                }
        }
    }
}