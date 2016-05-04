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
        print("in get notifications/events")
        
        // check for token, get profile id based on token and make the request
        if(userAccessToken != nil) {
            User.getProfile({ (item, error) in
                if error != nil {
                    print(error)
                }
                
                let parameters : [String : AnyObject] = [
                    "userId": (item?.id)!,
                    "limit": "100"
                ]
                
                let headers = [
                    "Authorization": "Bearer " + (userAccessToken as! String),
                    "Content-Type": "application/json"
                ]
                
                let endpoint = apiUrl + "/v1/stripe/events"
                
                Alamofire.request(.POST, endpoint, parameters: parameters, encoding: .JSON, headers: headers)
                    .validate().responseJSON { response in
                        // print(response)
                        switch response.result {
                        case .Success:
                            print("success")
                            if let value = response.result.value {
                                let data = JSON(value)
                                print("got stripe events data")
                                // print(data)
                                var notificationItemsArray = [NotificationItem]()
                                let events = data["events"]["data"].arrayValue
                                //                             print(data["transactions"]["data"].arrayValue)
                                for event in events {
                                    let id = event["id"].stringValue
                                    let type = event["type"].stringValue
                                    let created = event["created"].stringValue
                                    print(event)
                                    let item = NotificationItem(id: id, type: type, created: created)
                                    notificationItemsArray.append(item)
                                }
                                completionHandler(notificationItemsArray, response.result.error)
                            }
                        case .Failure(let error):
                            print("failed to get notifications/events")
                            print(error)
                        }
                }
            })
        }
    }
}