////
////  Charge.swift
////  app-ios
////
////  Created by Sinan Ulkuatam on 5/9/16.
////  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
////
//
//import Foundation
//import SwiftyJSON
//import Alamofire
//
//class POS {
//    
//    class func createCharge(token: String, amount: Float, completionHandler: (Bool, NSError) -> Void) {
//        User.getProfile { (user, NSError) in
//            
//            let url = API_URL + "/v1/stripe/" + (user?.id)! + "/charge/"
//            
//            let headers = [
//                "Authorization": "Bearer " + String(userAccessToken),
//                "Content-Type": "application/json"
//            ]
//            let parameters : [String : AnyObject] = [
//                "token": String(token) ?? "",
//                "amount": amount
//            ]
//            
//            print(token)
//            
//            // for invalid character 0 be sure the content type is application/json and enconding is .JSON
//            Alamofire.request(.POST, url,
//                parameters: parameters,
//                encoding:.JSON,
//                headers: headers)
//                .responseJSON { response in
//                    switch response.result {
//                    case .Success:
//                        if let value = response.result.value {
//                            let json = JSON(value)
//                            // print(json)
//                        }
//                    case .Failure(let error):
//                        print(error)
//                    }
//            }
//        }
//    }
//}