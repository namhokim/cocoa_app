//
//  LoginResponse.swift
//  HoursContentCopier
//
//  Created by namho.kim on 24/09/2019.
//  Copyright © 2019 namo. All rights reserved.
//

import Foundation

struct LoginResponse : Codable {
    var status : String
    var error_code : Int
    var error_message : String
    var result : LoginResult
    
    static func fromJsonData(data : Data) -> LoginResponse {
        return try! JSONDecoder().decode(LoginResponse.self, from: data)
    }
    
    init (from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = (try? values.decode(String.self, forKey: .status)) ?? "unknown_status"
        error_code = (try? values.decode(Int.self, forKey: .error_code)) ?? 911
        error_message = (try? values.decode(String.self, forKey: .error_message)) ?? ""
        result = (try? values.decode(LoginResult.self, forKey: .result)) ?? LoginResult()
    }
}

struct LoginResult : Codable {
    var token : String
    
    init () {
        token = ""
    }
    
    init (from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        token = (try? values.decode(String.self, forKey: .token)) ?? ""
    }
}
