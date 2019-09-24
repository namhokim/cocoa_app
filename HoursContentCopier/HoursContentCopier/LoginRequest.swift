//
//  LoginData.swift
//  HoursContentCopier
//
//  Created by namho.kim on 24/09/2019.
//  Copyright © 2019 namo. All rights reserved.
//

import Foundation

public struct LoginRequest : Codable {
    var email : String
    var password : String
    var deviceID : String
    var devicename : String
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
        self.deviceID = "web:\(email)"
        self.devicename = "web:\(email)"
    }
    
    func toJsonString() -> String {
        return ""
    }
}

struct LoginResponse : Codable {
    var status : String
    var result : LoginResult
}

struct LoginResult : Codable {
    var token : String
}
