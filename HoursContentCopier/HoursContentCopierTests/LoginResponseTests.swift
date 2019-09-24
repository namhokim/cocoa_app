//
//  LoginResponseTests.swift
//  HoursContentCopierTests
//
//  Created by namho.kim on 24/09/2019.
//  Copyright © 2019 namo. All rights reserved.
//

import XCTest

class LoginResponseTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFromJsonString__login_success() {
        // given
        let responseJson = """
{
"status": "ok",
"result": {
"username": "myname",
"email": "myname@icloud.com",
"guid": "7D698879-CBD1-45C2-890B-91954F59AA9B",
"trial_expires_timestamp": 1480809600,
"trial_expired": 1,
"plan_code": null,
"crowdfunder": 0,
"renewal_date": null,
"accountType": 2,
"freeTimerLimit": 11,
"identifiedAsTeamAdmin": 0,
"featureFlags": null,
"subscriptions": {
"user": {
"status": 0,
"legacy": false
},
"teams": []
},
"token": "B1A77F5C-99E9-4597-AC30-547FB24C15E9"
}
}
"""
        
        // when
        let result = LoginResponse.fromJsonData(data: responseJson.data(using: .utf8)!)
        
        // then
        XCTAssert(result.status == "ok")
        XCTAssert(result.result.token == "B1A77F5C-99E9-4597-AC30-547FB24C15E9")
    }
    
    func testFromJsonString__login_fail() {
        // given
        let responseJson = """
{"status":"error","error_code":401,"error_message":"Email or password invalid!"}
"""
        
        // when
        let result = LoginResponse.fromJsonData(data: responseJson.data(using: .utf8)!)
        
        // then
        XCTAssert(result.status == "error")
        XCTAssert(result.error_code == 401)
        XCTAssert(result.error_message == "Email or password invalid!")
        XCTAssert(result.result.token == "")
    }

}
