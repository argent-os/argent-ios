////
////  Account.swift
////  app-ios
////
////  Created by Sinan Ulkuatam on 5/22/16.
////  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
////
//
//import Foundation
//import SwiftyJSON
//import Alamofire
//
//class Account {
//    
//    let id: String
//    let business_name: String
//    let charges_enabled: Bool
//    let country: String
//    let email: String
//    let legal_entity: Dictionary<String, AnyObject>
//    let additional_owners: Array<String, String>
//    let address: Dictionary<String, AnyObject>
//    let business_name: String
//    let dob: Dictionary<String, Int>
//    let first_name: String
//    let last_name: String
//    let ssn_last_4: Int
//    let transfers_enabled: Bool
//    let transfer_schedule: Dictionary<String, AnyObject>
//    let verification: Dictionary<String, AnyObject>
//
//    required init(id: String) {
//        self.id = id
//    }
//    
//    class func getStripeAccount(completionHandler: (Account?, NSError?) -> Void) {
//        if(userAccessToken != nil) {
//            User.getProfile({ (user, error) in
//                if error != nil {
//                    print(error)
//                }
//                
//                let parameters : [String : AnyObject] = [:]
//                
//                let headers = [
//                    "Authorization": "Bearer " + (userAccessToken as! String),
//                    "Content-Type": "application/x-www-form-urlencoded"
//                ]
//                
//                let user_id = (user?.id)
//                
//                let endpoint = apiUrl + "/v1/stripe/" + user_id! + "/account"
//                
//                Alamofire.request(.GET, endpoint, parameters: parameters, encoding: .URL, headers: headers)
//                    .responseJSON { response in
//                        switch response.result {
//                        case .Success:
//                            if let value = response.result.value {
//                                
//                                let data = JSON(value)
//                                print(data)
//                                let account = Account(id: id)
//                                completionHandler(Account(id: ""), response.result.error)
//                            }
//                        case .Failure(let error):
//                            print(error)
//                        }
//                }
//            })
//        }
//    }
//    
//    class func saveStripeAccount(dic: Dictionary<String, AnyObject>, completionHandler: (User?, Bool, NSError?) -> Void) {
//        if(userAccessToken != nil) {
//            User.getProfile({ (user, error) in
//                if error != nil {
//                    print(error)
//                }
//                
//                let parameters : [String : AnyObject] = dic
//                
//                let headers = [
//                    "Authorization": "Bearer " + (userAccessToken as! String),
//                    "Content-Type": "application/json"
//                ]
//                
//                let user_id = (user?.id)
//                
//                let endpoint = apiUrl + "/v1/stripe/" + user_id! + "/account"
//                
//                Alamofire.request(.POST, endpoint, parameters: parameters, encoding: .JSON, headers: headers)
//                    .responseJSON { response in
//                        switch response.result {
//                        case .Success:
//                            if let value = response.result.value {
//                                
//                                let data = JSON(value)
//                                print(data)
//                                let account = Account(id: id)
//                                completionHandler(Account(id: ""), response.result.error)
//                            }
//                        case .Failure(let error):
//                            print(error)
//                        }
//                }
//            })
//        }
//    }
//    
//    class func getUserAccounts(completionHandler: ([User]?, NSError?) -> Void) {
//        // request to api to get account data as json, put in list and table
//        // curl -X GET -i -H "Content-Type: application/json" -d '{"access_token": ""}' http://192.168.1.232:5001/v1/users/list
//        
//        let parameters : [String : AnyObject] = [:]
//        
//        let headers : [String : String] = [:]
//        
//        let endpoint = apiUrl + "/v1/user/list"
//        
//        Alamofire.request(.GET, endpoint, parameters: parameters, encoding: .URL, headers: headers)
//            .responseJSON { response in
//                switch response.result {
//                case .Success:
//                    if let value = response.result.value {
//                        let data = JSON(value)
//                        var userItemsArray = [User]()
//                        let accounts = data["users"].arrayValue
//                        for account in accounts {
//                            let id = ""
//                            let username = account["username"].stringValue
//                            let email = account["email"].stringValue
//                            let first_name = account["first_name"].stringValue
//                            let last_name = account["last_name"].stringValue
//                            let picture = account["picture"].stringValue
//                            let phone = ""
//                            let plaid_access_token = ""
//                            let item = User(id: id, username: username, email: email, first_name: first_name, last_name: last_name, picture: picture, phone: phone, plaid_access_token: plaid_access_token)
//                            userItemsArray.append(item)
//                        }
//                        completionHandler(userItemsArray, response.result.error)
//                    }
//                case .Failure(let error):
//                    print(error)
//                }
//        }
//    }
//}