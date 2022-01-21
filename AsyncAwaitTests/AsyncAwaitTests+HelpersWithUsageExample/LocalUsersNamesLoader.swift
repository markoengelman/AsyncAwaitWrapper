//
//  LocalUsersNamesLoader.swift
//  AsyncAwait
//
//  Created by Marko Engelman on 01/11/2021.
//

import Foundation

class LocalUsersNamesLoader: UsersNamesLoader {
    init() { }
    
    func load(completion: @escaping (Result<[String], Error>) -> Void) {
        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + 0.1) {
            completion(.success(["User"]))
        }
    }
}
