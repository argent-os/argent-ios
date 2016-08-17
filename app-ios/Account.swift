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
    let business_first_name: String
    let business_last_name: String
    let business_email: String
    let business_name: String
    let business_tax_id: String
    let address_line1: String
    let address_city: String
    let address_state: String
    let address_postal_code: String
    let address_country: String
    let ssn_last_4: String
    let pin: Bool
    let ein: String
    let type: String
    let legal_entity: Dictionary<String, AnyObject>
    
    let transfers_enabled: Bool
    let verification_fields_needed: [String]
    let verification_disabled_reason: String

    required init(id: String, business_first_name: String, business_last_name: String, business_email: String, business_name: String, business_tax_id: String, address_line1: String, address_city: String, address_state: String, address_country: String, address_postal_code: String, ssn_last_4: String, pin: Bool, ein: String, type: String, legal_entity: Dictionary<String, AnyObject>, transfers_enabled: Bool, verification_fields_needed: [String], verification_disabled_reason: String) {
        self.id = id
        self.business_first_name = business_first_name
        self.business_last_name = business_last_name
        self.business_email = business_email
        self.business_name = business_name
        self.business_tax_id = business_tax_id
        self.address_line1 = address_line1
        self.address_city = address_city
        self.address_state = address_state
        self.address_country = address_country
        self.address_postal_code = address_postal_code
        self.ssn_last_4 = ssn_last_4
        self.pin = pin
        self.ein = ein
        self.type = type
        self.legal_entity = legal_entity
        self.transfers_enabled = transfers_enabled
        self.verification_fields_needed = verification_fields_needed
        self.verification_disabled_reason = verification_disabled_reason
    }
    
    class func getStripeAccount(completionHandler: (Account?, NSError?) -> Void) {
        if userAccessToken != nil {
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
                
                let endpoint = API_URL + "/stripe/" + user_id! + "/account"
                
                Alamofire.request(.GET, endpoint, parameters: parameters, encoding: .URL, headers: headers)
                    .responseJSON { response in
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                
                                let data = JSON(value)
                                
                                if data["error"]["message"].stringValue != "" {
                                    let data = JSON(value)
                                    let err: NSError = NSError(domain: data["error"]["message"].stringValue, code: 11, userInfo: nil)
                                    completionHandler(nil, err)
                                } else {
                                    
                                    let acct = data["account"]
                                    let id = acct["id"].stringValue
                                    let business_name = acct["business_name"].stringValue
                                    let business_email = acct["email"].stringValue

                                    let legal_entity = acct["legal_entity"]
                                    let business_tax_id = legal_entity["business_tax_id"].stringValue
                                    let business_first_name = legal_entity["first_name"].stringValue
                                    let business_last_name = legal_entity["last_name"].stringValue
                                    let address_line1 = legal_entity["address"]["line1"].stringValue
                                    let address_city = legal_entity["address"]["city"].stringValue
                                    let address_state = legal_entity["address"]["state"].stringValue
                                    let address_country = legal_entity["address"]["country"].stringValue
                                    let address_postal_code = legal_entity["address"]["postal_code"].stringValue
                                    let ssn_last_4 = legal_entity["ssn_last_4_provided"].stringValue
                                    let pin = legal_entity["personal_id_number_provided"].boolValue
                                    let ein = legal_entity["business_tax_id"].stringValue
                                    let type = legal_entity["type"].stringValue
                                    
                                    let transfers_enabled = acct["transfers_enabled"].boolValue
                                    let verification_disabled_reason = acct["verification"]["disabled_reason"].stringValue
                                    
                                    let _ = acct["verification"]["fields_needed"].arrayObject.map { (unwrappedOptionalArray) -> Void in
                                        // print(unwrappedOptionalArray)
                                        
                                        let account = Account(id: id, business_first_name: business_first_name, business_last_name: business_last_name, business_email: business_email, business_name: business_name,  business_tax_id: business_tax_id, address_line1: address_line1, address_city: address_city, address_state: address_state, address_country: address_country, address_postal_code: address_postal_code, ssn_last_4: ssn_last_4, pin: pin, ein: ein, type: type, legal_entity: Dictionary<String, AnyObject>(), transfers_enabled: transfers_enabled, verification_fields_needed: unwrappedOptionalArray as! [String], verification_disabled_reason: verification_disabled_reason)
                                        
                                        completionHandler(account, response.result.error)

                                    }
                                }
                            
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
                
                let endpoint = API_URL + "/stripe/" + user_id! + "/account"
                
                Alamofire.request(.PUT, endpoint, parameters: parameters, encoding: .JSON, headers: headers)
                    .responseJSON { response in
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                
                                let data = JSON(value)

                                if data["error"]["message"].stringValue != "" {
                                    let data = JSON(value)
                                    let err: NSError = NSError(domain: data["error"]["message"].stringValue, code: 11, userInfo: nil)
                                    completionHandler(nil, false, err)
                                } else {
                                    
                                    let acct = data["account"]
                                    let id = acct["id"].stringValue
                                    let business_name = acct["business_name"].stringValue
                                    let business_email = acct["email"].stringValue
                                    
                                    let legal_entity = acct["legal_entity"]
                                    let business_tax_id = legal_entity["business_tax_id"].stringValue
                                    let business_first_name = legal_entity["first_name"].stringValue
                                    let business_last_name = legal_entity["last_name"].stringValue
                                    let address_line1 = legal_entity["address"]["line1"].stringValue
                                    let address_city = legal_entity["address"]["city"].stringValue
                                    let address_state = legal_entity["address"]["state"].stringValue
                                    let address_country = legal_entity["address"]["country"].stringValue
                                    let address_postal_code = legal_entity["address"]["postal_code"].stringValue
                                    let ssn_last_4 = legal_entity["ssn_last_4_provided"].stringValue
                                    let ein = legal_entity["business_tax_id"].stringValue
                                    let pin = legal_entity["personal_id_number_provided"].boolValue
                                    let type = legal_entity["type"].stringValue
                                    
                                    let transfers_enabled = acct["transfers_enabled"].boolValue
                                    let verification_disabled_reason = acct["verification"]["disabled_reason"].stringValue
                                    
                                    let verification_fields_needed = [String(acct["verification"]["fields_needed"].arrayObject)]
                                    
                                    let account = Account(id: id, business_first_name: business_first_name, business_last_name: business_last_name, business_email: business_email, business_name: business_name, business_tax_id: business_tax_id, address_line1: address_line1, address_city: address_city, address_state: address_state, address_country: address_country, address_postal_code: address_postal_code, ssn_last_4: ssn_last_4, pin: pin, ein: ein, type: type, legal_entity: Dictionary<String, AnyObject>(), transfers_enabled: transfers_enabled, verification_fields_needed: verification_fields_needed, verification_disabled_reason: verification_disabled_reason)
                                    
                                    completionHandler(account, true, response.result.error)
                                }
                
                            }
                        case .Failure(let error):
                            print(error)
                        }
                }
            })
        }
    }
}