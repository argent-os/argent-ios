//
//  Profile.swift
//  paykloud-ios
//
//  Created by Sinan Ulkuatam on 3/19/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import UIKit

final class Profile {
    
    static let sharedInstance = Profile()
    
    var image: UIImage?
    var name: String?
    var gender: String?
    var birthDay: NSDate?
    var introduction: String?
    var moreInformation = false
    var nickname: String?
    var location: String?
    var phoneNumber: String?
    var job: String?
}