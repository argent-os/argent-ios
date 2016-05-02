//
//  Card.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 4/7/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class Card {
    
    let brand: String
    let country: String
    let currency: String
    let cvc_check: String
    let exp_month: Int
    let exp_year: Int
    let fingerprint: String
    let funding: String
    let last4: String

    required init(brand: String, country: String, currency: String, cvc_check: String, exp_month: Int, exp_year: Int, fingerprint: String, funding: String, last4: String) {
        self.brand = brand
        self.country = country
        self.currency = currency
        self.cvc_check = cvc_check
        self.exp_month = exp_month
        self.exp_year = exp_year
        self.fingerprint = fingerprint
        self.funding = funding
        self.last4 = last4
    }
    
    class func getCreditCards(completionHandler: ([Card]?, NSError?) -> Void) {
        // request to api to get account data as json, put in list and table
        let parameters : [String : AnyObject] = [
            "accountId" : userData!["stripe"]["accountId"].stringValue
        ]
        
        let headers = [
            "Authorization": "Bearer " + (userAccessToken as! String),
            "Content-Type": "application/json"
        ]
        
        let endpoint = apiUrl + "/v1/stripe/account/cards/list"
        
        print(parameters)
        
        Alamofire.request(.POST, endpoint, parameters: parameters, encoding: .JSON, headers: headers)
            .validate().responseJSON { response in
                print(response)
                switch response.result {
                case .Success:
                    print("success")
                    if let value = response.result.value {
                        let data = JSON(value)
                        print("got credit card data")
                        // print(data)
                        var cardItemsArray = [Card]()
                        let cards = data["cards"]["data"].arrayValue
                        print(data["cards"]["data"].arrayValue)
                        for jsonItem in cards {
                            let brand = jsonItem["brand"].stringValue
                            let country = jsonItem["country"].stringValue
                            let currency = jsonItem["currency"].stringValue
                            let cvc_check = jsonItem["cvc_check"].stringValue
                            let exp_month = jsonItem["exp_month"].int
                            let exp_year = jsonItem["exp_year"].int
                            let fingerprint = jsonItem["fingerprint"].stringValue
                            let funding = jsonItem["funding"].stringValue
                            let last4 = jsonItem["last4"].stringValue

                            let item = Card(brand: brand, country: country, currency: currency, cvc_check: cvc_check, exp_month: exp_month!, exp_year: exp_year!, fingerprint: fingerprint, funding: funding, last4: last4)
                            cardItemsArray.append(item)
                        }
                        completionHandler(cardItemsArray, response.result.error)
                    }
                case .Failure(let error):
                    print(error)
                }
        }
    }
}