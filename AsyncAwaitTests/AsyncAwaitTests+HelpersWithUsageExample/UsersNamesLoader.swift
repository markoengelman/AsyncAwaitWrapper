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
