//
//  ProfileResponse.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/17/24.
//

import Foundation

struct ProfileResponse: Decodable {
    let userID: String
    let email: String?
    let nick: String
    let phoneNum: String?
    let birthDay: String?
    let profileImage: String?
    let followers: [Follow]
    let following: [Follow]
    let posts: [String]
}

struct Follow: Decodable {
    let userID: String
    let nick: String
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case nick
        case profileImage
    }
}
