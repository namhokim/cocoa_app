//
//  TimersResponseTests.swift
//  HoursContentCopierTests
//
//  Created by namho.kim on 25/09/2019.
//  Copyright © 2019 namo. All rights reserved.
//

import XCTest

class TimersResponseTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFromJsonData_success_withTimeEntries() {
        // given
        let timerReponse = #"{"status":"ok","result":{"timestamp":1569339998,"timers":[{"archived":0,"guid":"5115A5D9-79E7-4006-91C4-B6095672E864","date_last_used":1569339604,"sort_order":0,"project_name":"\ud65c\ub3d9","project_guid":"FF3EF687-CD7A-4B7F-A952-C462BCA8E01D","project_color":4,"client_name":null,"client_guid":null,"task_name":"\uc774\ub3d9\uc2dc\uac04","task_guid":"24CAF053-A65C-48D3-A7E7-C2E5A10FA983","time_duration":0,"extra_duration":0,"duration":0,"running":0,"note":null},{"archived":0,"guid":"4E5B2B88-FC57-495F-BCA5-9BA1B18837A1","date_last_used":1569336118,"sort_order":1,"project_name":"\uc0dd\uc874","project_guid":"CCA2440E-86E3-4E47-A35C-C12FE8F17DBC","project_color":2,"client_name":null,"client_guid":null,"task_name":"\uc2dd\uc0ac","task_guid":"2DF85A3F-7142-4C26-8AD3-C6D75BD10EC5","time_duration":0,"extra_duration":0,"duration":0,"running":0,"note":null},{"archived":0,"guid":"A6567F27-C1AB-41AE-9454-E91212987E59","date_last_used":1569339618,"sort_order":2,"project_name":"\uc9c1\uc7a5","project_guid":"750F04EB-455B-440A-A98F-EA595132A891","project_color":5,"client_name":null,"client_guid":null,"task_name":"\uc5c5\ubb34\uac04 \ud734\uc2dd","task_guid":"F3CAA1FF-7A5A-4819-89C1-D4D12C08A620","time_duration":272,"extra_duration":0,"duration":272,"running":0,"note":null},{"archived":0,"guid":"3E7E0345-9B17-46A4-9C12-A42CD6478C9E","date_last_used":1569339998,"sort_order":3,"project_name":"\uc57c\ub180\uc790","project_guid":"1D5BA4D8-A535-4E8C-BADE-7443C800355F","project_color":0,"client_name":null,"client_guid":null,"task_name":"\uc5c5\ubb34","task_guid":"F6767A55-B8A4-4B20-9C1C-9F30E663F558","time_duration":15739,"extra_duration":0,"duration":15739,"running":1,"note":null}],"time_entries":[{"guid":"CFA0467F-5130-4710-B613-53C86D49B1F8","note_text":"Xcode: Data range","duration":14538,"date_entry":1569323986,"date_end":1569338524,"ready_for_reports":0,"users_id":85727,"running":0,"user_name":"tester","user_guid":"7D698879-CBD1-45C2-890B-91954F59AA9B","is_static":0,"timer_guid":"3E7E0345-9B17-46A4-9C12-A42CD6478C9E","project_name":"\uc57c\ub180\uc790","project_guid":"1D5BA4D8-A535-4E8C-BADE-7443C800355F","project_color":0,"client_name":null,"client_guid":null,"task_name":"\uc5c5\ubb34","task_guid":"F6767A55-B8A4-4B20-9C1C-9F30E663F558"},{"guid":"511555C2-157F-49C6-8208-AB76429122EF","note_text":"","duration":272,"date_entry":1569338524,"date_end":1569338796,"ready_for_reports":0,"users_id":85727,"running":0,"user_name":"tester","user_guid":"7D698879-CBD1-45C2-890B-91954F59AA9B","is_static":0,"timer_guid":"A6567F27-C1AB-41AE-9454-E91212987E59","project_name":"\uc9c1\uc7a5","project_guid":"750F04EB-455B-440A-A98F-EA595132A891","project_color":5,"client_name":null,"client_guid":null,"task_name":"\uc5c5\ubb34\uac04 \ud734\uc2dd","task_guid":"F3CAA1FF-7A5A-4819-89C1-D4D12C08A620"},{"guid":"0EC32A0C-5446-4BD9-9391-FA1E75CC3E45","note_text":"Xcode: Data range reponse \uad6c\ud604","duration":1201,"date_entry":1569338796,"date_end":false,"ready_for_reports":0,"users_id":85727,"running":1,"user_name":"tester","user_guid":"7D698879-CBD1-45C2-890B-91954F59AA9B","is_static":0,"timer_guid":"3E7E0345-9B17-46A4-9C12-A42CD6478C9E","project_name":"\uc57c\ub180\uc790","project_guid":"1D5BA4D8-A535-4E8C-BADE-7443C800355F","project_color":0,"client_name":null,"client_guid":null,"task_name":"\uc5c5\ubb34","task_guid":"F6767A55-B8A4-4B20-9C1C-9F30E663F558"}],"extra_times":[]}}"#
        
        // when
        let result = TimersResponse.fromJsonData(data: timerReponse.data(using: .utf8)!)
        
        // then
        XCTAssert(result.status == "ok")
        XCTAssert(result.result.timestamp == 1569339998)
        XCTAssert(result.result.timers.count == 4)
        XCTAssert(result.result.time_entries.count == 3)
    }
    
    func testFromJsonData_success_withoutTimeEntries() {
        // given
        let timerReponse = #"{"status":"ok","result":{"timestamp":1569339987,"timers":[{"archived":0,"guid":"5115A5D9-79E7-4006-91C4-B6095672E864","date_last_used":1569339604,"sort_order":0,"project_name":"\ud65c\ub3d9","project_guid":"FF3EF687-CD7A-4B7F-A952-C462BCA8E01D","project_color":4,"client_name":null,"client_guid":null,"task_name":"\uc774\ub3d9\uc2dc\uac04","task_guid":"24CAF053-A65C-48D3-A7E7-C2E5A10FA983","time_duration":0,"extra_duration":0,"duration":0,"running":0,"note":null},{"archived":0,"guid":"4E5B2B88-FC57-495F-BCA5-9BA1B18837A1","date_last_used":1569336118,"sort_order":1,"project_name":"\uc0dd\uc874","project_guid":"CCA2440E-86E3-4E47-A35C-C12FE8F17DBC","project_color":2,"client_name":null,"client_guid":null,"task_name":"\uc2dd\uc0ac","task_guid":"2DF85A3F-7142-4C26-8AD3-C6D75BD10EC5","time_duration":0,"extra_duration":0,"duration":0,"running":0,"note":null},{"archived":0,"guid":"A6567F27-C1AB-41AE-9454-E91212987E59","date_last_used":1569340527,"sort_order":2,"project_name":"\uc9c1\uc7a5","project_guid":"750F04EB-455B-440A-A98F-EA595132A891","project_color":5,"client_name":null,"client_guid":null,"task_name":"\uc5c5\ubb34\uac04 \ud734\uc2dd","task_guid":"F3CAA1FF-7A5A-4819-89C1-D4D12C08A620","time_duration":0,"extra_duration":0,"duration":0,"running":0,"note":null},{"archived":0,"guid":"3E7E0345-9B17-46A4-9C12-A42CD6478C9E","date_last_used":1569339998,"sort_order":3,"project_name":"\uc57c\ub180\uc790","project_guid":"1D5BA4D8-A535-4E8C-BADE-7443C800355F","project_color":0,"client_name":null,"client_guid":null,"task_name":"\uc5c5\ubb34","task_guid":"F6767A55-B8A4-4B20-9C1C-9F30E663F558","time_duration":0,"extra_duration":0,"duration":0,"running":0,"note":null}],"time_entries":[],"extra_times":[]}}"#
        
        // when
        let result = TimersResponse.fromJsonData(data: timerReponse.data(using: .utf8)!)
        
        // then
        XCTAssert(result.status == "ok")
        XCTAssert(result.result.timestamp == 1569339987)
        XCTAssert(result.result.timers.count == 4)
        XCTAssert(result.result.time_entries.count == 0)
    }
}
