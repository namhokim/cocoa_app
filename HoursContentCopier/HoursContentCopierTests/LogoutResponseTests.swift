//
//  LogoutResponseTests.swift
//  HoursContentCopierTests
//
//  Created by namho.kim on 24/09/2019.
//  Copyright © 2019 namo. All rights reserved.
//

import XCTest

class LogoutResponseTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFromJsonString__logout_success() {
        // given
        let responseJson = #"{"status":"ok","result":"Logged out."}"#
        
        // when
        let result = LogoutResponse.fromJsonData(data: responseJson.data(using: .utf8)!)
        
        // then
        XCTAssert(result.status == "ok")
        XCTAssert(result.result == "Logged out.")
    }
    
    func testFromJsonString__logout_fail() {
        // given
        let responseJson = #"{"status":"error","error_code":401,"error_message":"Login Required."}"#
        
        // when
        let result = LogoutResponse.fromJsonData(data: responseJson.data(using: .utf8)!)
        
        // then
        XCTAssert(result.status == "error")
        XCTAssert(result.error_code == 401)
        XCTAssert(result.error_message == "Login Required.")
    }

}
