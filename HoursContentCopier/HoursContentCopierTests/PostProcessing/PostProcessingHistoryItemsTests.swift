//
//  PostProcessingHistoryItemsTests.swift
//  HoursContentCopierTests
//
//  Created by 김남호 on 19-11-16.
//  Copyright © 2019 namo. All rights reserved.
//

import XCTest

class PostProcessingHistoryItemsTests: XCTestCase {

    func testInitializedDataReturnsSizeIsZero() {
        let sut = PostProcessingHistoryItems()
        
        XCTAssert(sut.size() == 0, "Initialized Data size will be 0.")
    }
    
    func testInitializedWithDataReturnsSizeIsZero() {
        let items = ["grep first"]
        
        let sut = PostProcessingHistoryItems(initItems: items)
        
        XCTAssert(sut.size() == 1, "Initialized One Data size will be 1.")
    }
    
    func testInitializedWithSixDataReturnsSizeIsFive() {
        let items = ["1", "2", "3", "4", "5", "6"]
        
        let sut = PostProcessingHistoryItems(initItems: items)
        
        XCTAssert(sut.size() == 5, "Initialized One Data size will be 5.")
    }
    
    func testAddOneItemReturnsOneSize() {
        var sut = PostProcessingHistoryItems()
        
        sut.add(command: "grep break")
        
        XCTAssert(sut.size() == 1, "Add one item then size will returns 1.")
    }
    
    func testAddTwoItemReturnsTwoSize() {
        var sut = PostProcessingHistoryItems()
        
        sut.add(command: "grep break")
        sut.add(command: "grep hint")
        
        XCTAssert(sut.size() == 2, "Add one item then size will returns 2.")
    }
    
    func testAddSixItemReturnsOnlyFiveSize() {
        var sut = PostProcessingHistoryItems()
        
        sut.add(command: "grep 1")
        sut.add(command: "grep 2")
        sut.add(command: "grep 3")
        sut.add(command: "grep 4")
        sut.add(command: "grep 5")
        sut.add(command: "grep 6")
        
        XCTAssert(sut.size() == 5, "Add one item then size will returns 5.")
    }
    
    func testAddSameValueMultipleReturnsOnlyOneSize() {
        var sut = PostProcessingHistoryItems()
        
        sut.add(command: "grep 1")
        sut.add(command: "grep 1")
        sut.add(command: "grep 1")
        
        XCTAssert(sut.size() == 1, "Add one item then size will returns 1.")
    }

}
