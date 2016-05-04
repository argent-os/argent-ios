//
//  Plan.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 5/3/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class Plan {
    
    let id: String
    
    required init(id: String) {
        self.id = id
    }
    
    class func getPlanList(completionHandler: ([Plan]?, NSError?) -> Void) {
        // request to api to get data as json, put in list and table
        print("in get plan list")
        
        // check for token, get profile id based on token and make the request
        if(userAccessToken != nil) {
            User.getProfile({ (user, error) in
                if error != nil {
                    print(error)
                }
                
                let parameters : [String : AnyObject] = [
                    "userId": (user?.id)!,
                    "limit": "100"
                ]
                
                let headers = [
                    "Authorization": "Bearer " + (userAccessToken as! String),
                    "Content-Type": "application/json"
                ]
                
                let endpoint = apiUrl + "/v1/stripe/plans/list"
                
                Alamofire.request(.POST, endpoint, parameters: parameters, encoding: .JSON, headers: headers)
                    .validate().responseJSON { response in
                        print(response)
                        switch response.result {
                        case .Success:
                            print("success")
                            if let value = response.result.value {
                                let data = JSON(value)
                                print(data)
                                print("got plan list data")
                                // print(data)
                                var plansArray = [Plan]()
                                let plans = data["plans"]["data"].arrayValue
                                for plan in plans {
                                    let id = plan["id"].stringValue
                                    let item = Plan(id: id)
                                    plansArray.append(item)
                                }
                                completionHandler(plansArray, response.result.error)
                            }
                        case .Failure(let error):
                            print("failed to get plan list")
                            print(error)
                        }
                }
            })
        }
    }
}