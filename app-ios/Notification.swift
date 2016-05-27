//
//  History.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 4/22/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class NotificationItem {
    
    let id: String
    let type: String
    let created: String
    
    required init(id: String, type: String, created: String) {
        self.id = id
        self.type = type
        self.created = created
    }
    
    class func getNotificationList(completionHandler: ([NotificationItem]?, NSError?) -> Void) {
        // request to api to get data as json, put in list and table
        
        // check for token, get profile id based on token and make the request
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
                
                let limit = "100"
                let user_id = (user?.id)
                
                let endpoint = API_URL + "/v1/stripe/" + user_id! + "/events?limit=" + limit
                
                Alamofire.request(.GET, endpoint, parameters: parameters, encoding: .URL, headers: headers)
                    .validate().responseJSON { response in
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                let data = JSON(value)
                                var notificationItemsArray = [NotificationItem]()
                                let events = data["events"]["data"].arrayValue
                                for event in events {
                                    let id = event["id"].stringValue
                                    let type = event["type"].stringValue
                                    let created = event["created"].stringValue
                                    let item = NotificationItem(id: id, type: type, created: created)
                                    notificationItemsArray.append(item)
                                }
                                completionHandler(notificationItemsArray, response.result.error)
                            }
                        case .Failure(let error):
                            print(error)
                        }
                }
            })
        }
    }
}