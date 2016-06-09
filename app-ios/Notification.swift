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
    
    class func getNotificationList(limit: String, starting_after: String, completionHandler: ([NotificationItem]?, NSError?) -> Void) {
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
                
                let limit = limit
                let user_id = (user?.id)
                let starting_after = starting_after
                
                var endpoint = API_URL + "/stripe/" + user_id! + "/events"
                if starting_after != "" {
                    endpoint = API_URL + "/stripe/" + user_id! + "/events?limit=" + limit + "&starting_after=" + starting_after
                } else {
                    endpoint = API_URL + "/stripe/" + user_id! + "/events?limit=" + limit
                }
                
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