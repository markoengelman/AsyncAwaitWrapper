//
//  LocalUsersNamesLoader.swift
//  AsyncAwait
//
//  Created by Marko Engelman on 01/11/2021.
//

import Foundation

class LocalUsersNamesLoader: UsersNamesLoader {
    private var result: Result<[String], Error>?
    
    init() { }
    
    func load(completion: @escaping (Result<[String], Error>) -> Void) {
        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + 0.1) {
            let result = self.result ?? .success(["User"])
            completion(result)
        }
    }
    
    func complete(with result: Result<[String], Error>) {
        self.result = result
    }
}
