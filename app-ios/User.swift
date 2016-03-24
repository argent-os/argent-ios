//
//  User.swift
//  protonpay-ios
//
//  Created by Sinan Ulkuatam on 2/29/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Argo
import Runes

class User {
    let id: Int
    let name: String
    let email: String?
    let role: RoleType
    let companyName: String
    let vendors: [User]
    
    init (id: Int, name: String, email: String?, role: RoleType, companyName: String, vendors: [User]) {
        self.id = id
        self.name = name
        self.email = email
        self.role = role
        self.companyName = companyName
        self.vendors = vendors
    }
}

extension User: Decodable {
    static func create(id: Int)(name: String)(email: String?)(role: RoleType)(companyName: String)(vendors: [User]) -> User {
        return User(id: id, name: name, email: email, role: role, companyName: companyName, vendors: vendors)
    }
    
    static func decode(j: JSON) -> Decoded<User> {
        return User.create
            <^> j <| "id"
            <*> j <| "name"
            <*> j <|? "email" // Use ? for parsing optional values
            <*> j <| "role" // Custom types that also conform to Decodable just work
            <*> j <| ["company", "name"] // Parse nested objects
            <*> j <|| "vendors" // Parse arrays of objects
    }
}

enum RoleType: String {
    case Admin = "Admin"
    case User = "User"
}

extension RoleType: Decodable {
    static func decode(j: JSON) -> Decoded<RoleType> {
        switch j {
        case let .String(s): return .fromOptional(RoleType(rawValue: s))
        default: return .Failure(.TypeMismatch(expected: "String", actual: "\(j)")) // Provide an Error message for a string type mismatch
        }
    }
}