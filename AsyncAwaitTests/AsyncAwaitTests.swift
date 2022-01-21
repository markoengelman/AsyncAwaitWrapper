//
//  AsyncAwaitTests.swift
//  AsyncAwaitTests
//
//  Created by Marko Engelman on 30/10/2021.
//

import XCTest
@testable import AsyncAwait

class AsyncAwaitTests: XCTestCase {
    func test_wrapper_async_load_deliversResultEventually() throws {
        let (sut, _) = makeSUT()
        let exp = expectation(description: "Waiting AsyncAwaitWrapper to deliver")
        expect(exp, when: {
            _ = try await sut.load().get()
        })
    }

    func test_wrapper_async_load_deliversResourceEventually() throws {
        let (sut, _) = makeSUT()
        let exp = expectation(description: "Waiting AsyncAwaitWrapper to deliver")
        expect(exp, when: {
            let _: [String] = try await sut.load()
        })
    }
    
    func test_wrapper_async_load_throwsError_onLoaderError() throws {
        let (sut, loader) = makeSUT()
        loader.complete(with: .failure(NSError(domain: "", code: -1, userInfo: nil)))
        let exp = expectation(description: "Waiting AsyncAwaitWrapper to throw")
        expect(exp, when: {
            var capturedError: Error?
            do {
                let _: [String] = try await sut.load()
            } catch {
                capturedError = error
                XCTAssertNotNil(capturedError)
            }
        })
    }
    
    func test_wrappedLoader_deliversEventually() {
        let (sut, _) = makeSUT()
        let exp = expectation(description: "Waiting wrapped loader to deliver")
        var names: [String]?
        expect(exp, when: {
            sut.load {
                names = try? $0.get()
                XCTAssertNotNil(names)
            }
        })
    }
}

// MARK: - Private
private extension AsyncAwaitTests {
    func makeSUT() -> (AsyncAwaitWrapper<[String], Error>, LocalUsersNamesLoader) {
        let loader = LocalUsersNamesLoader()
        return (AsyncAwaitWrapper(loader: loader.load), loader)
    }
    
    func expect(_ exp: XCTestExpectation, when action: @escaping () async throws -> Void) {
        Task {
            try await action()
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
}
