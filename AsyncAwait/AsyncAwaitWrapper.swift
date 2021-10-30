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
}
