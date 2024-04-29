//
//  Repository.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/15/24.
//

import Foundation

//TODO: - Repository 프로토콜 개선

protocol Repository {
    associatedtype T
    
    func createItem(_: T)
    func fetch() -> Array<T>
    func update(_: T)
    func delete(_: T)
    func deleteAll(_: T)
}
