//
//  User.swift
//  protonpay-ios
//
//  Created by Sinan Ulkuatam on 4/1/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class User {
    
    let plaidAccessToken: String
    
    required init(plaidAccessToken: String) {
        self.plaidAccessToken = plaidAccessToken
    }
    
    class func endpointForUser() -> String {
        let endpoint = apiUrl + "/v1/profile/"
        return endpoint
    }
    
    class func getUser(completionHandler: ([User]?, NSError?) -> Void) {
        Alamofire.request(.GET, self.endpointForUser())
            .responseGetUserProfile { response in
                completionHandler(response.result.value, response.result.error)
        }
    }
    
    class func updateUser(completionHandler: ([User]?, NSError?) -> Void) {
        Alamofire.request(.POST, self.endpointForUser())
            .responseUpdateUserProfile { response in
                completionHandler(response.result.value, response.result.error)
        }
    }
}

extension Alamofire.Request {
    func responseGetUserProfile(completionHandler: Response<[User], NSError> -> Void) -> Self {
        let serializer = ResponseSerializer<[User], NSError> { request, response, data, error in
            guard let responseData = data else {
                let failureReason = "Error"
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
                
                var user = [User]()
                let userObj = json.arrayValue
                for jsonItem in userObj {
                    let text = jsonItem["text"].stringValue
                    let id = jsonItem["_id"].stringValue
                    let uid = jsonItem["user_id"].stringValue
                    let date = jsonItem["date"].stringValue
//                    let item = UserItem()
//                    user.append(item)
                }
                
                return .Success(user)
            case .Failure(let error):
                return .Failure(error)
            }
        }
        
        return response(responseSerializer: serializer, completionHandler: completionHandler)
    }
    
    func responseUpdateUserProfile(completionHandler: Response<[User], NSError> -> Void) -> Self {
        let serializer = ResponseSerializer<[User], NSError> { request, response, data, error in
            guard let responseData = data else {
                let failureReason = "Error"
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
                
                var userObj = [User]()
                let user = json.arrayValue
                for jsonItem in user {
                    let plaidToken = jsonItem[""].stringValue
//                    let item = User(id: id)
//                    userObj.append(item)
                }
                
                return .Success(userObj)
            case .Failure(let error):
                return .Failure(error)
            }
        }
        
        return response(responseSerializer: serializer, completionHandler: completionHandler)
    }
}