//
//  PipeProcessingTests.swift
//  HoursContentCopierTests
//
//  Created by namho.kim on 07/10/2019.
//  Copyright © 2019 namo. All rights reserved.
//
import XCTest

class PipeProcessingTests: XCTestCase {
    func testRandomFilename() {
        // given
        let proc = PipeProcessing()
        
        // when
        let filename = proc.filename
        
        // then
        let isValidUuid = UUID(uuidString: filename)
        XCTAssert(isValidUuid != nil, filename)
    }
}
