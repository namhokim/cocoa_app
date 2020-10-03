//
//  UrlDecompositionTests.swift
//  ContactTests
//
//  Created by 김남호 on 20-10-3.
//

import XCTest

class UrlDecompositionTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNormal() throws {
        // given
        let url = URL(fileURLWithPath: "/Users/namo/Desktop/tube/babyshow_45.mp4")
        
        // when
        let sut = UrlDecomposition(url)
        
        // then
        XCTAssert(sut.lastPart == "babyshow_45.mp4", "last part assertion")
        XCTAssert(sut.pathPart == "/Users/namo/Desktop/tube/", "path part assertion")
    }
    
    func testRootPathPart() throws {
        // given
        let url = URL(fileURLWithPath: "/babyshow_45.mp4")
        
        // when
        let sut = UrlDecomposition(url)
        
        // then
        XCTAssert(sut.lastPart == "babyshow_45.mp4", "last part assertion")
        XCTAssert(sut.pathPart == "/", sut.pathPart)
    }


}
