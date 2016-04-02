//
//  Notification.swift
//  protonpay-ios
//
//  Created by Sinan Ulkuatam on 4/1/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class NotificationItem {
    
    let id: String
    let text: String
    let date: String
    let uid: String
    
    required init(id: String, text: String, date: String, uid: String) {
        self.id = text
        self.text = text
        self.date = text
        self.uid = text
    }
    
    class func endpointForNotifications() -> String {
        let endpoint = "http://192.168.1.232:5001/v1/notification/"
        return endpoint
    }
    
    class func getNotificationList(completionHandler: ([NotificationItem]?, NSError?) -> Void) {
        Alamofire.request(.GET, self.endpointForNotifications())
            .responseNotificationsItemsArray { response in
                completionHandler(response.result.value, response.result.error)
        }
    }
}

extension Alamofire.Request {
    func responseNotificationsItemsArray(completionHandler: Response<[NotificationItem], NSError> -> Void) -> Self {
        let serializer = ResponseSerializer<[NotificationItem], NSError> { request, response, data, error in
            guard let responseData = data else {
                let failureReason = "Image URL could not be serialized because input data was nil."
                let error = Error.errorWithCode(.DataSerializationFailed, failureReason: failureReason)
                return .Failure(error)
            }
            
            let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, responseData, error)
            
            switch result {
            case .Success(let value):
                let json = JSON(value)
                guard json.error == nil else {
                    print(json.error!)
                    return .Failure(json.error!)
                }
                
                var itemsArray = [NotificationItem]()
                let notifications = json.arrayValue
                for jsonItem in notifications {
                    let text = jsonItem["text"].stringValue
                    let id = jsonItem["_id"].stringValue
                    let uid = jsonItem["user_id"].stringValue
                    let date = jsonItem["date"].stringValue
                    let item = NotificationItem(id: id, text: text, date: date, uid: uid)
                    itemsArray.append(item)
                }
                
                return .Success(itemsArray)
            case .Failure(let error):
                return .Failure(error)
            }
        }
        
        return response(responseSerializer: serializer, completionHandler: completionHandler)
    }
}