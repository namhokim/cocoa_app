//
//  LoginRequestTests.swift
//  HoursContentCopierTests
//
//  Created by namho.kim on 24/09/2019.
//  Copyright © 2019 namo. All rights reserved.
//

import XCTest

class LoginRequestTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCreateRequestData() {
        // given
        let emailParam = "my-email"
        let passwordParam = "my-password"
        
        // when
        let request = LoginRequest(email: emailParam, password: passwordParam)
        
        // then
        XCTAssert(request.email == emailParam, "입력한 이메일과 같아야 한다.")
        XCTAssert(request.password == passwordParam, "입력한 비밀번호와 같아야 한다.")
        XCTAssert(request.deviceID == "web:\(emailParam)", "입력한 이메일에 web:이 접두어가 붙은 형태이다.")
        XCTAssert(request.devicename == "web:\(emailParam)", "입력한 이메일에 web:이 접두어가 붙은 형태이다.")
    }
    
    func testToJsonString() {
        // given
        let emailParam = "my-email"
        let passwordParam = "my-password"
        let request = LoginRequest(email: emailParam, password: passwordParam)
        
        // when
        let result = request.toJsonString()
        
        // then
        let expectedResult = ""
        XCTAssert(result == expectedResult)
    }

}
