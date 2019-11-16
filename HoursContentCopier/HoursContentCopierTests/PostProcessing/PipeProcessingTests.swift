//
//  PipeProcessingTests.swift
//  HoursContentCopierTests
//
//  Created by namho.kim on 07/10/2019.
//  Copyright © 2019 namo. All rights reserved.
//
import XCTest

class PipeProcessingTests: XCTestCase, CompletePostProcessingDelegate {
    
    func processingCompleted(data: String) {
        // do nothing
    }
    
    func testRandomFilename() {
        // given
        let proc = PipeProcessing(delegate: self)
        
        // when
        let filename = proc.filename
        
        // then
        let isValidUuid = UUID(uuidString: filename)
        XCTAssert(isValidUuid != nil, filename)
    }
}
