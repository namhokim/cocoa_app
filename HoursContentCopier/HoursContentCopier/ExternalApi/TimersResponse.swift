//
//  TimersResponse.swift
//  HoursContentCopier
//
//  Created by namho.kim on 25/09/2019.
//  Copyright © 2019 namo. All rights reserved.
//

import Foundation

struct TimersResponse : Codable {
    var status : String
    var result :TimersResult
    var error_code : Int
    var error_message : String
    
    static func fromJsonData(data : Data) -> TimersResponse {
        if (data.count == 0) {
            return TimersResponse()
        }
        return try! JSONDecoder().decode(TimersResponse.self, from: data)
    }
    
    init() {
        status = "no data"
        result = TimersResult()
        error_code = -1
        error_message = ""
    }
    
    init (from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = (try? values.decode(String.self, forKey: .status)) ?? "unknown_status"
        result = (try? values.decode(TimersResult.self, forKey: .result)) ?? TimersResult()
        error_code = (try? values.decode(Int.self, forKey: .error_code)) ?? -1
        error_message = (try? values.decode(String.self, forKey: .error_message)) ?? "unknown_error_message"
    }
}

struct TimersResult : Codable {
    var timestamp: Int
    var timers: [Timers]
    var time_entries: [TimeEntries]
    
    init() {
        timestamp = Int(floor(Date().timeIntervalSince1970))
        timers = [Timers]()
        time_entries = [TimeEntries]()
    }
    
    init (from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        timestamp = (try? values.decode(Int.self, forKey: .timestamp)) ?? Int(floor(Date().timeIntervalSince1970))
        timers = (try? values.decode([Timers].self, forKey: .timers)) ?? [Timers]()
        time_entries = (try? values.decode([TimeEntries].self, forKey: .time_entries)) ?? [TimeEntries]()
    }
    
}

struct Timers : Codable {
    var task_guid: String   // 작업 ID
    var sort_order: Int     // 정렬 순서
    var task_name: String   // 작업 표시 이름
    var time_duration: Int  // 작업 시간
    
    init (from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        task_guid = (try? values.decode(String.self, forKey: .task_guid)) ?? ""
        sort_order = (try? values.decode(Int.self, forKey: .sort_order)) ?? -1
        task_name = (try? values.decode(String.self, forKey: .task_name)) ?? "empty task"
        time_duration = (try? values.decode(Int.self, forKey: .time_duration)) ?? -1
    }
}

struct TimeEntries :Codable {
    var date_entry: Int     // 시작시간
    var date_end: Int       // 종료시간 (running이 1이면 false 임)
    var duration: Int       // 경과시간
    var running: Int        // 현재 작업 여부 - 0: No, 1: Yes
    var task_guid: String   // 작업 ID
    var task_name: String   // 작업 이름
    var note_text: String   // 작업 노트
    
    init (from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        date_entry = (try? values.decode(Int.self, forKey: .date_entry)) ?? Int(floor(Date().timeIntervalSince1970))
        date_end = (try? values.decode(Int.self, forKey: .date_end)) ?? Int(floor(Date().timeIntervalSince1970))
        duration = (try? values.decode(Int.self, forKey: .duration)) ?? 0
        running = (try? values.decode(Int.self, forKey: .running)) ?? 9
        task_guid = (try? values.decode(String.self, forKey: .task_guid)) ?? ""
        task_name = (try? values.decode(String.self, forKey: .task_name)) ?? "empty task"
        note_text = (try? values.decode(String.self, forKey: .note_text)) ?? ""
    }
}
