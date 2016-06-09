//
//  Auth.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 5/11/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Crashlytics

class Auth {
    
    let username: String
    let email: String
    let password: String
    
    required init(username: String, email: String, password: String) {
        self.username = username
        self.email = email
        self.password = password
    }
    
    
    class func login(email: String, username: String, password: String, completionHandler: (String, Bool, String, NSError) -> ()) {
        
        // check for empty fields
        if(email.isEmpty) {
            // display alert message
            return;
        } else if(password.isEmpty) {
            return;
        }
        
        Alamofire.request(.POST, API_URL + "/login", parameters: [
            "username": username,
            "email":email,
            "password":password
            ],
            encoding:.JSON)
            .progress { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
                // print(totalBytesWritten)
                // print(totalBytesExpectedToWrite)
                
                // This closure is NOT called on the main queue for performance
                // reasons. To update your ui, dispatch to the main queue.
                dispatch_async(dispatch_get_main_queue()) {
                    // print("Total bytes written on main queue: \(totalBytesWritten)")
                }
            }
            .responseJSON { response in
                // go to main view
                if(response.response?.statusCode == 200) {
                    NSUserDefaults.standardUserDefaults().setBool(true,forKey:"userLoggedIn")
                    NSUserDefaults.standardUserDefaults().synchronize()
                } else {
                    // display error
                }
                
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let data = JSON(value)
                        
                        // completion handler here for apple watch
                        
                        let token = data["token"].stringValue
                        if response.result.error != nil {
                            completionHandler(token, false, username, response.result.error!)
                        } else {
                            completionHandler(token, true, username, NSError(domain: "nil", code: 000, userInfo: [:]))
                        }
                        
                        NSUserDefaults.standardUserDefaults().setValue(token, forKey: "userAccessToken")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        
                        Answers.logLoginWithMethod("Access",
                            success: true,
                            customAttributes: nil)
                        // go to main view from completion handler
                        // self.performSegueWithIdentifier("homeView", sender: self);
                        
                        
                    }
                case .Failure(let error):
                    print(error)
                    Answers.logLoginWithMethod("Access",
                        success: false,
                        customAttributes: nil)
                    // display error
                }
        }
        
    }
}