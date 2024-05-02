//
//  CreatorEntity.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 5/2/24.
//

import Foundation

struct ProfileEntity: Decodable, Hashable {
    let userID: String
    let email: String?
    let nick: String
    let phoneNum: String
    let profileImage: String?
    let followers: [Follow]
    let following: [Follow]
    let posts: [String]
    
    static func defaultData() -> ProfileEntity {
        ProfileEntity(userID: "", email: nil, nick: "", phoneNum: "", profileImage: nil, followers: [], following: [], posts: [])
    }
}
