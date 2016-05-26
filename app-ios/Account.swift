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
    let business_name: String
    let business_tax_id: String
    let address_line1: String
    let address_city: String
    let address_state: String
    let address_postal_code: String
    let address_country: String
    let ssn_last_4: String
    let type: String
    let legal_entity: Dictionary<String, AnyObject>

    required init(id: String, business_name: String, business_tax_id: String, address_line1: String, address_city: String, address_state: String, address_country: String, address_postal_code: String, ssn_last_4: String, type: String, legal_entity: Dictionary<String, AnyObject>) {
        self.id = id
        self.business_name = business_name
        self.business_tax_id = business_tax_id
        self.address_line1 = address_line1
        self.address_city = address_city
        self.address_state = address_state
        self.address_country = address_country
        self.address_postal_code = address_postal_code
        self.ssn_last_4 = ssn_last_4
        self.type = type
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
                                let business_name = acct["business_name"].stringValue

                                let legal_entity = acct["legal_entity"]
                                let business_tax_id = legal_entity["business_tax_id"].stringValue
                                let address_line1 = legal_entity["address"]["line1"].stringValue
                                let address_city = legal_entity["address"]["city"].stringValue
                                let address_state = legal_entity["address"]["state"].stringValue
                                let address_country = legal_entity["address"]["country"].stringValue
                                let address_postal_code = legal_entity["address"]["postal_code"].stringValue
                                let ssn_last_4 = legal_entity["ssn_last_4_provided"].stringValue
                                let type = legal_entity["type"].stringValue
                                
                                let account = Account(id: id, business_name: business_name, business_tax_id: business_tax_id, address_line1: address_line1, address_city: address_city, address_state: address_state, address_country: address_country, address_postal_code: address_postal_code, ssn_last_4: ssn_last_4, type: type, legal_entity: Dictionary<String, AnyObject>())
                                
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
                                
                                let acct = data["account"]
                                let id = acct["id"].stringValue
                                let business_name = acct["business_name"].stringValue
                                
                                let legal_entity = acct["legal_entity"]
                                let business_tax_id = legal_entity["business_tax_id"].stringValue
                                let address_line1 = legal_entity["address"]["line1"].stringValue
                                let address_city = legal_entity["address"]["city"].stringValue
                                let address_state = legal_entity["address"]["state"].stringValue
                                let address_country = legal_entity["address"]["country"].stringValue
                                let address_postal_code = legal_entity["address"]["postal_code"].stringValue
                                let ssn_last_4 = legal_entity["ssn_last_4_provided"].stringValue
                                let type = legal_entity["type"].stringValue
                                
                                let account = Account(id: id, business_name: business_name, business_tax_id: business_tax_id, address_line1: address_line1, address_city: address_city, address_state: address_state, address_country: address_country, address_postal_code: address_postal_code, ssn_last_4: ssn_last_4, type: type, legal_entity: Dictionary<String, AnyObject>())
                                
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