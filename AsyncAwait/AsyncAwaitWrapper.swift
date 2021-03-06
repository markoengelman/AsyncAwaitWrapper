//
//  AsyncAwaitWrapper.swift
//  AsyncAwait
//
//  Created by Marko Engelman on 30/10/2021.
//

import Foundation

class AsyncAwaitWrapper<Resource, ResourceError> where ResourceError: Error {
    typealias ResourceLoader = (_ completion: @escaping (Result<Resource, ResourceError>) -> Void) -> Void
    let loader: ResourceLoader
    
    init(loader: @escaping ResourceLoader) {
        self.loader = loader
    }
    
    func load() async -> Result<Resource, ResourceError> {
        return await withCheckedContinuation { continuation in
            loader() { result in
                continuation.resume(returning: result)
            }
        }
    }
    
    func load() async throws -> Resource {
        try await withCheckedThrowingContinuation { continuation in
            loader() { result in
                switch result {
                case let .success(resource):
                    continuation.resume(returning: resource)
                    
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
