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
        let sut = makeSUT()
        let exp = expectation(description: "Waiting loader to deliver")
        
        var names: [String]?
        sut.load {
            names = try? $0.get()
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertNotNil(names)
    }
}

// MARK: - Private
private extension AsyncAwaitTests {
    func makeSUT() -> UsersNamesLoader {
        let loader = LocalUsersNamesLoader()
        return loader
    }
}
