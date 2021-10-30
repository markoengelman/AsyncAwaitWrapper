//
//  AsyncAwaitTests.swift
//  AsyncAwaitTests
//
//  Created by Marko Engelman on 30/10/2021.
//

import XCTest
@testable import AsyncAwait

class AsyncAwaitTests: XCTestCase {
    func test_loader_deliversEventually() {
        let loader = LocalUsersNamesLoader()
        let exp = expectation(description: "Waiting loader to deliver")
        
        var names: [String]?
        loader.load {
            names = try? $0.get()
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertNotNil(names)
    }
}
