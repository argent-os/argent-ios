//
//  Bitcoin.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 5/5/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class Bitcoin {
    
    let id: String
    let amount: Float80
    let uri: String
    let filled: Bool
    
    required init(id: String, amount: Float80, uri: String, filled: Bool) {
        self.id = id
        self.amount = amount
        self.uri = uri
        self.filled = filled
    }
    
    class func createBitcoinReceiver(amount: Int, completionHandler: (Bitcoin?, NSError?) -> ()) {
        if(userAccessToken != nil) {
            User.getProfile({ (user, error) in
                if error != nil {
                    print(error)
                }
                
                let headers = [
                    "Authorization": "Bearer " + (userAccessToken as! String),
                    "Content-Type": "application/json"
                ]
                let parameters : [String : AnyObject] = [
                    "amount": amount,
                ]
                
                let endpoint = API_URL + "/v1/stripe/" + (user?.id)! + "/bitcoin"
                
                Alamofire.request(.POST, endpoint,
                    parameters: parameters,
                    encoding:.JSON,
                    headers: headers)
                    .responseJSON { response in
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                let data = JSON(value)
                                let receiver = data["receiver"]
                                let id = receiver["id"].stringValue
                                let uri = receiver["bitcoin_uri"].stringValue
                                let amount = Float80(receiver["bitcoin_amount"].floatValue)
                                let filled = receiver["filled"].boolValue
                                let bitcoin = Bitcoin(id: id, amount: amount, uri: uri, filled: filled)
                                completionHandler(bitcoin, response.result.error)
                            }
                        case .Failure(let error):
                            print(error)
                        }
                }
            })
        }
    }
    
    class func getBitcoinReceiver(id: String, completionHandler: (Bitcoin?, NSError?) -> Void) {
        if(userAccessToken != nil) {
            User.getProfile({ (user, error) in
                if error != nil {
                    print(error)
                }
                
                let parameters = [:] 
                
                let headers = [
                    "Authorization": "Bearer " + (userAccessToken as! String),
                    "Content-Type": "application/x-www-form-urlencoded"
                ]
                
                let endpoint = API_URL + "/v1/stripe/" + (user?.id)! + "/bitcoin/" + id
                
                Alamofire.request(.GET, endpoint,
                    parameters: parameters as! [String : AnyObject],
                    encoding:.URL,
                    headers: headers)
                    .responseJSON { response in
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                let data = JSON(value)
                                print(data)
                                let receiver = data["receiver"]
                                let id = receiver["id"].stringValue
                                let uri = receiver["bitcoin_uri"].stringValue
                                let amount = Float80(receiver["bitcoin_amount"].floatValue)
                                let filled = receiver["filled"].boolValue
                                let bitcoin = Bitcoin(id: id, amount: amount, uri: uri, filled: filled)
                                completionHandler(bitcoin, response.result.error)
                            }
                        case .Failure(let error):
                            print(error)
                        }
                }
            })
        }
    }
}