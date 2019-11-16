//
//  LogoutResponse.swift
//  HoursContentCopier
//
//  Created by namho.kim on 24/09/2019.
//  Copyright © 2019 namo. All rights reserved.
//

import Foundation

struct LogoutResponse : Codable {
    var status : String
    var error_code : Int
    var error_message : String
    var result : String
    
    static func fromJsonData(data : Data) -> LogoutResponse {
        return try! JSONDecoder().decode(LogoutResponse.self, from: data)
    }
    
    init (from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = (try? values.decode(String.self, forKey: .status)) ?? "unknown_status"
        error_code = (try? values.decode(Int.self, forKey: .error_code)) ?? 911
        error_message = (try? values.decode(String.self, forKey: .error_message)) ?? ""
        result = (try? values.decode(String.self, forKey: .result)) ?? ""
    }
}
