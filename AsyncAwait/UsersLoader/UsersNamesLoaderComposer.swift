//
//  UsersNamesLoaderComposer.swift
//  AsyncAwait
//
//  Created by Marko Engelman on 31/10/2021.
//

import Foundation

final class UsersNamesLoaderComposer {
    static func makeLoader() -> UsersNamesLoader {
        let loader = LocalUsersNamesLoader()
        return AsyncAwaitWrapper(usersLoader: loader)
    }
    
    static func makeAsyncAwaitLoader() -> () async -> Result<[String], Error> {
        let loader = LocalUsersNamesLoader()
        let asyncLoader = AsyncAwaitWrapper(usersLoader: loader)
        return asyncLoader.load
    }
}

extension AsyncAwaitWrapper: UsersNamesLoader where Resource == [String], ResourceError == Error {
    func load(completion: @escaping (Result<[String], Error>) -> Void) {
        loader() { completion($0) }
    }
}

private extension AsyncAwaitWrapper where Resource == [String], ResourceError == Error {
    convenience init(usersLoader: UsersNamesLoader) {
        self.init(loader: usersLoader.load)
    }
}
