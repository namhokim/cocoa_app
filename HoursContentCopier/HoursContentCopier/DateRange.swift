//
//  DateRange.swift
//  HoursContentCopier
//
//  Created by namho.kim on 24/09/2019.
//  Copyright © 2019 namo. All rights reserved.
//

import Foundation

class DateRange {
    var begin: String
    var end: String
    
    init(targetDate: Date) {
        let fromDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: targetDate)!
        let endDate = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: targetDate)!
        
        begin = String(UInt64(floor(fromDate.timeIntervalSince1970)))
        end = String(UInt64(floor(endDate.timeIntervalSince1970)))
    }
}
