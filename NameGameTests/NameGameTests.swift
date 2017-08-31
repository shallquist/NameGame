//
//  NameGameTests.swift
//  NameGameTests
//
//  Created by steig hallquist on 8/31/17.
//  Copyright © 2017 steig hallquist. All rights reserved.
//

import XCTest
@testable import NameGame

class NameGameTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        let expect = self.expectation(description: "Running")
        
        let wtProfiles = WTProfiles()
        
        wtProfiles.loadData(handler: {error in
            expect.fulfill()
        })
        
        
        self.wait(for: [expect], timeout: 60)
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
