//
//  DateRangeTests.swift
//  HoursContentCopierTests
//
//  Created by namho.kim on 24/09/2019.
//  Copyright © 2019 namo. All rights reserved.
//

import XCTest

class DateRangeTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDateRange() {
        // given
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier:"ko_KR")
        formatter.dateFormat = "yyyy-MM-dd"
        let dday = formatter.date(from: "2019-09-24")
        
        // when
        let dateRange = DateRange(targetDate: dday!)
        
        // then
        XCTAssert(dateRange.begin == "1569250800", dateRange.begin)
        XCTAssert(dateRange.end == "1569283200", dateRange.end)
    }

}
