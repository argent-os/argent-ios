//
//  Account.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 5/22/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class Account {
    
    let id: String
    let legal_entity: Dictionary<String, AnyObject>

    required init(id: String, legal_entity: Dictionary<String, AnyObject>) {
        self.id = id
        self.legal_entity = legal_entity
    }
    
    class func getStripeAccount(completionHandler: (Account?, NSError?) -> Void) {
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
                
                let endpoint = apiUrl + "/v1/stripe/" + user_id! + "/account"
                
                Alamofire.request(.GET, endpoint, parameters: parameters, encoding: .URL, headers: headers)
                    .responseJSON { response in
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                
                                let data = JSON(value)
                                let acct = data["account"]
                                let id = acct["id"].stringValue
                                let legal_entity = acct["legal_entity"]
                                
                                print(acct)
                                print(id)
                                
                                let account = Account(id: id, legal_entity: Dictionary<String, AnyObject>())
                                
                                //print(account)
                                completionHandler(account, response.result.error)
                            }
                        case .Failure(let error):
                            print(error)
                        }
                }
            })
        }
    }
    
    class func saveStripeAccount(dic: [String: AnyObject], completionHandler: (Account?, Bool, NSError?) -> Void) {
        if(userAccessToken != nil) {
            User.getProfile({ (user, error) in
                if error != nil {
                    print(error)
                }
                
                let parameters = dic
                
                let headers = [
                    "Authorization": "Bearer " + (userAccessToken as! String),
                    "Content-Type": "application/json"
                ]
                
                let user_id = (user?.id)
                
                let endpoint = apiUrl + "/v1/stripe/" + user_id! + "/account"
                
                Alamofire.request(.PUT, endpoint, parameters: parameters, encoding: .JSON, headers: headers)
                    .responseJSON { response in
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                
                                let data = JSON(value)
                                print(data)
                                
                                let acct = data["account"]
                                let id = acct["id"].stringValue
                                let legal_entity = acct["legal_entity"]
                                
                                let account = Account(id: id, legal_entity: Dictionary<String, AnyObject>())
                                completionHandler(account, true, response.result.error)
                            }
                        case .Failure(let error):
                            print(error)
                        }
                }
            })
        }
    }
}