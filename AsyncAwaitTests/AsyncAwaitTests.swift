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
        let (_, loader) = makeSUT()
        let exp = expectation(description: "Waiting loader to deliver")
        
        var names: [String]?
        loader.load {
            names = try? $0.get()
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertNotNil(names)
    }
    
    func test_wrapper_async_load_deliversResultEventually() throws {
        let (sut, _) = makeSUT()
        let exp = expectation(description: "Waiting AsyncAwaitWrapper to deliver")
        Task.init {
            _ = try await sut.load().get()
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_wrapper_async_load_deliversResourceEventually() throws {
        let (sut, _) = makeSUT()
        let exp = expectation(description: "Waiting AsyncAwaitWrapper to deliver")
        Task.init {
            let _: [String] = try await sut.load()
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_wrapper_async_load_throwsError_onLoaderError() throws {
        let (sut, loader) = makeSUT()
        loader.complete(with: .failure(NSError(domain: "", code: -1, userInfo: nil)))
        let exp = expectation(description: "Waiting AsyncAwaitWrapper to throw")
        Task.init {
            do {
                let _: [String] = try await sut.load()
            } catch {
                exp.fulfill()
            }
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_wrappedLoader_deliversEventually() {
        let (sut, _) = makeSUT()
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

// MARK: - Private
private extension AsyncAwaitTests {
    func makeSUT() -> (AsyncAwaitWrapper<[String], Error>, LocalUsersNamesLoader) {
        let loader = LocalUsersNamesLoader()
        return (AsyncAwaitWrapper(loader: loader.load), loader)
    }
}
