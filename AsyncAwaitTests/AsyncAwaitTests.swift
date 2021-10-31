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
    
    func test_wrapper_async_load_deliversEventually() throws {
        let sut = AsyncAwaitWrapper(loader: makeSUT().load)
        let exp = expectation(description: "Waiting AsyncAwaitWrapper to deliver")
        Task.init {
            _ = try await sut.load().get()
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_wrappedLoader_deliversEventually() {
        let sut: UsersNamesLoader = AsyncAwaitWrapper(loader: makeSUT().load)
        let exp = expectation(description: "Waiting wrapped loader to deliver")
        
        var names: [String]?
        sut.load {
            names = try? $0.get()
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertNotNil(names)
    }
}

extension AsyncAwaitWrapper: UsersNamesLoader where Resource == [String], ResourceError == Error {
    public func load(completion: @escaping (Result<[String], Error>) -> Void) {
        loader() { completion($0) }
    }
}

// MARK: - Private
private extension AsyncAwaitTests {
    func makeSUT() -> UsersNamesLoader {
        let loader = LocalUsersNamesLoader()
        return loader
    }
}
