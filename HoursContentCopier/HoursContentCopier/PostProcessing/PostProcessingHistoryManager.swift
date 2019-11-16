//
//  PostProcessingHistoryManager.swift
//  HoursContentCopier
//
//  Created by 김남호 on 19-11-16.
//  Copyright © 2019 namo. All rights reserved.
//

import Foundation

struct HistoryItemByUserDefaults {
    static let KEY = "postCommandHistories"
    
    static func load() -> Array<String> {
        if let data = UserDefaults.standard.object(forKey: KEY) {
            return data as! Array<String>
        }
        return []
    }
    
    static func save(data: Array<String>) {
        UserDefaults.standard.set(data, forKey: KEY)
    }
}
