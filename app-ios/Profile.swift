//
//  Profile.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 3/19/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import UIKit

final class Profile {
    
    static let sharedInstance = Profile()
    
    var image: UIImage?
    var firstName: String?
    var lastName: String?
    var username: String?
    var email: String?
    var birthDay: NSDate?
    var introduction: String?
    var moreInformation = true
    var ssn: String?
    var ein: String?
    var pin: String?
    var businessAddressLine1: String?
    var businessAddressLine2: String?
    var businessAddressCity: String?
    var businessAddressState: String?
    var businessAddressCountry: String?
    var businessAddressZip: String?
    var businessName: String?
    var businessType: String?
    var phoneNumber: String?
    
    let state = [ "AK",
                  "AL",
                  "AR",
                  "AZ",
                  "CA",
                  "CO",
                  "CT",
                  "DC",
                  "DE",
                  "FL",
                  "GA",
                  "HI",
                  "IA",
                  "ID",
                  "IL",
                  "IN",
                  "KS",
                  "KY",
                  "LA",
                  "MA",
                  "MD",
                  "ME",
                  "MI",
                  "MN",
                  "MO",
                  "MS",
                  "MT",
                  "NC",
                  "ND",
                  "NE",
                  "NH",
                  "NJ",
                  "NM",
                  "NV",
                  "NY",
                  "OH",
                  "OK",
                  "OR",
                  "PA",
                  "PR",
                  "RI",
                  "SC",
                  "SD",
                  "TN",
                  "TX",
                  "UT",
                  "VA",
                  "VT",
                  "WA",
                  "WI",
                  "WV",
                  "WY",
    ]
}