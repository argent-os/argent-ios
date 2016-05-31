//
//  Bank.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 5/31/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class Bank {
    
    let id: String
    let object: String
    let account: String
    let account_holder_name: String
    let account_holder_type: String
    let bank_name: String
    let country: String
    let currency: String
    let default_for_currency: String
    let fingerprint: String
    let last4: String
    let metadata: String
    let routing_number: String
    let status: String
    let name: String
    
    required init(id: String,
     object: String,
     account: String,
     account_holder_name: String,
     account_holder_type: String,
     bank_name: String,
     country: String,
     currency: String,
     default_for_currency: String,
     fingerprint: String,
     last4: String,
     metadata: String,
     routing_number: String,
     status: String,
     name: String) {
        self.id = id
        self.object = object
        self.account = account
        self.account_holder_name = account_holder_name
        self.account_holder_type = account_holder_type
        self.bank_name = bank_name
        self.country = country
        self.currency = currency
        self.default_for_currency = default_for_currency
        self.fingerprint = fingerprint
        self.last4 = last4
        self.metadata = metadata
        self.routing_number = routing_number
        self.status = status
        self.name = name
    }
    
    class func getBankAccounts(completionHandler: ([Bank]?, NSError?) -> Void) {
        // request to api to get account data as json, put in list and table
        // curl -X GET -i -H "Content-Type: application/json" -d '{"access_token": "test_bofa"}' http://192.168.1.232:5001/v1/plaid/auth
        
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
                
                let endpoint = API_URL + "/v1/stripe/" + user_id! + "/external_account?type=bank"
                
                Alamofire.request(.GET, endpoint, parameters: parameters, encoding: .URL, headers: headers)
                    .responseJSON { response in
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                let data = JSON(value)
                                print(data)
                                var bankItemsArray = [Bank]()
                                let banks = data["external_accounts"]["data"].arrayValue
                                for bank in banks {
                                    let id = bank["id"].stringValue
                                    let object = bank["object"].stringValue
                                    let account = bank["account"].stringValue
                                    let account_holder_name = bank["account_holder_name"].stringValue
                                    let account_holder_type = bank["account_holder_type"].stringValue
                                    let bank_name = bank["bank_name"].stringValue
                                    let country = bank["country"].stringValue
                                    let currency = bank["currency"].stringValue
                                    let default_for_currency = bank["default_for_currency"].stringValue
                                    let fingerprint = bank["fingerprint"].stringValue
                                    let last4 = bank["last4"].stringValue
                                    let metadata = bank["metadata"].stringValue
                                    let routing_number = bank["routing_number"].stringValue
                                    let status = bank["status"].stringValue
                                    let name = bank["name"].stringValue
                                    
                                    let item = Bank(id: id, object: object, account: account, account_holder_name: account_holder_name, account_holder_type: account_holder_type, bank_name: bank_name, country: country, currency: currency, default_for_currency: default_for_currency, fingerprint: fingerprint, last4: last4, metadata: metadata, routing_number: routing_number, status: status, name: name)
                                    bankItemsArray.append(item)
                                }
                                completionHandler(bankItemsArray, response.result.error)
                            }
                        case .Failure(let error):
                            print(error)
                        }
                }
            })
        }
    }
}