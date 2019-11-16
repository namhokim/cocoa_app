//
//  LoginData.swift
//  HoursContentCopier
//
//  Created by namho.kim on 24/09/2019.
//  Copyright © 2019 namo. All rights reserved.
//

import Foundation

struct LoginRequest : Codable {
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
    
    /// Data로 바꾸기 위해서는 아래와 같이 사용한다.
    /// jsonString?.data(using: .utf8, allowLossyConversion: false)
    func toJsonString() -> String {
        let encoder = JSONEncoder()
        let loginJson = try? encoder.encode(self)
        let jsonString = String(data: loginJson!, encoding: .utf8)
        return jsonString!
    }
}


