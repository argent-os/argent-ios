//
//  Root.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 3/30/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
let ENVIRONMENT = "PROD"

class Root {
    
    class var API_URL: String {
        var apiurl = ""
        print("setting api url")
        if ENVIRONMENT == "DEV" {
            apiurl = "http://192.168.1.182:5001"
        } else if ENVIRONMENT == "PROD" {
            print("set api url")
            apiurl = "https://api.argent.cloud"
        }
        print(apiurl)
        return apiurl
    }
}