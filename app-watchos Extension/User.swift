//
//  User.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 6/3/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import WatchKit
import WatchConnectivity
import Foundation
import Alamofire
import SwiftyJSON

class User {
    
    let id: String
    let username: String
    let email: String
    let first_name: String
    let last_name: String
    let picture: String
    let phone: String
    let country: String
    let plaid_access_token: String
    
    required init(id: String, username: String, email: String, first_name: String, last_name: String, picture: String, phone: String, country: String, plaid_access_token: String) {
        self.id = id
        self.username = username
        self.email = email
        self.first_name = first_name
        self.last_name = last_name
        self.picture = picture
        self.phone = phone
        self.country = country
        self.plaid_access_token = plaid_access_token
    }
    
    class func getProfile(token: String, completionHandler: (User?, NSError?) -> Void) {
        // request to api to get account data as json, put in list and table
        // curl -X GET -i -H "Content-Type: application/json" -d '{"access_token": ""}' http://192.168.1.232:5001/v1/profile
        
        if token != "" {
            
            let parameters : [String : AnyObject] = [:]
            
            let headers = [
                "Authorization": "Bearer " + (token),
                "Content-Type": "application/x-www-form-urlencoded"
            ]
            
            let endpoint = Root.API_URL + "/v1/profile"
            
            Alamofire.request(.GET, endpoint, parameters: parameters, encoding: .URL, headers: headers)
                .responseJSON { response in
                    switch response.result {
                    case .Success:
                        if let value = response.result.value {
                            let data = JSON(value)
                            if(data["message"] == "No token supplied") {
                                print("no token")
                            }
                            let profile = data
                            let id = profile["_id"].stringValue
                            let username = profile["username"].stringValue
                            let email = profile["email"].stringValue
                            let first_name = profile["first_name"].stringValue
                            let last_name = profile["last_name"].stringValue
                            let picture = profile["picture"]["secure_url"].stringValue
                            let phone = profile["phone_number"].stringValue
                            let country = profile["country"].stringValue
                            let plaid_access_token = profile["plaid"]["access_token"].stringValue
                            let item = User(id: id, username: username, email: email, first_name: first_name, last_name: last_name, picture: picture, phone: phone, country: country, plaid_access_token: plaid_access_token)
                            completionHandler(item, response.result.error)
                        }
                    case .Failure(let error):
                        print(error)
                    }
            }
        }
    }
}