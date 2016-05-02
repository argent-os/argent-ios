//
//  Bank.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 4/6/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class Bank {
    
    let id: String
    let routing: String
    let account: String
    let wire_routing: String
    let institution_type: String
    let account_name: String
    let account_number: String
    let account_sub_type: String
    let account_type: String
    let account_balance_current: String
    let account_balance_available: String
    
    required init(id: String, routing: String, account: String, wire_routing: String, institution_type: String, account_name: String, account_number: String, account_sub_type: String, account_type: String, account_balance_current: String, account_balance_available: String) {
        self.id = id
        self.routing = routing
        self.account = account
        self.wire_routing = wire_routing
        self.institution_type = institution_type
        self.account_name = account_name
        self.account_number = account_number
        self.account_sub_type = account_sub_type
        self.account_type = account_type
        self.account_balance_current = account_balance_current
        self.account_balance_available = account_balance_available
    }
    
    class func getBankAccounts(completionHandler: ([Bank]?, NSError?) -> Void) {
        // request to api to get account data as json, put in list and table
        // curl -X GET -i -H "Content-Type: application/json" -d '{"access_token": "test_bofa"}' http://192.168.1.232:5001/v1/plaid/auth
        
        let parameters : [String : AnyObject] = [
            "access_token" : "test_bofa"
        ]
        
        let headers = [
            "Authorization": "Bearer " + (userAccessToken as! String),
            "Content-Type": "application/json"
        ]
        
        let endpoint = apiUrl + "/v1/plaid/auth"
        
        Alamofire.request(.GET, endpoint, parameters: parameters, encoding: .URL, headers: headers)
            .responseJSON { response in
                print(response)
                switch response.result {
                case .Success:
                    print("success")
                    if let value = response.result.value {
                        let data = JSON(value)
//                        print("got plaid data")
//                        print(data)
                        var bankItemsArray = [Bank]()
                        let accounts = data["response"]["accounts"].arrayValue
                        print(data["response"]["accounts"].arrayValue)
                        for jsonItem in accounts {
                            let id = jsonItem["_id"].stringValue
                            let routing = jsonItem["numbers"]["routing"].stringValue
                            let account = jsonItem["numbers"]["account"].stringValue
                            let wire_routing = jsonItem["numbers"]["wireRouting"].stringValue
                            let institution_type = jsonItem["instiution"].stringValue
                            let account_name = jsonItem["meta"]["name"].stringValue
                            let account_number = jsonItem["meta"]["number"].stringValue
                            let account_sub_type = jsonItem["subtype"].stringValue
                            let account_type = jsonItem["type"].stringValue
                            let account_balance_current = jsonItem["balance"]["current"].stringValue
                            let account_balance_available = jsonItem["balance"]["available"].stringValue
                            let item = Bank(id: id, routing: routing, account: account, wire_routing: wire_routing, institution_type: institution_type, account_name: account_name, account_number: account_number, account_sub_type: account_sub_type, account_type: account_type, account_balance_current: account_balance_current, account_balance_available: account_balance_available)
                            bankItemsArray.append(item)
                        }
                        completionHandler(bankItemsArray, response.result.error)
                    }
                case .Failure(let error):
                    print(error)
                }
        }
    }
}