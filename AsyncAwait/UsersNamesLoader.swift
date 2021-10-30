//
//  UsersNamesLoader.swift
//  AsyncAwait
//
//  Created by Marko Engelman on 30/10/2021.
//

import Foundation

protocol UsersNamesLoader {
    func load(completion: @escaping (Result<[String], Error>) -> Void)
}

class LocalUsersNamesLoader: UsersNamesLoader {
    init() { }
    
    func load(completion: @escaping (Result<[String], Error>) -> Void) {
        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + 0.1) {
            completion(.success(["User"]))
        }
    }
}
