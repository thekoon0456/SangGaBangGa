//
//  ProfileResponse.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/17/24.
//

import Foundation

struct ProfileResponse: Decodable, Hashable {
    let userID: String
    let email: String
    let nick: String?
    let phoneNum: String?
    let birthDay: String?
    let profileImage: String?
    let followers: [Follow]?
    let following: [Follow]?
    let posts: [String]?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email
        case nick
        case phoneNum
        case birthDay
        case profileImage
        case followers
        case following
        case posts
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userID = try container.decode(String.self, forKey: .userID)
        self.email = try container.decode(String.self, forKey: .email)
        self.nick = try container.decodeIfPresent(String.self, forKey: .nick)
        self.phoneNum = try container.decodeIfPresent(String.self, forKey: .phoneNum)
        self.birthDay = try container.decodeIfPresent(String.self, forKey: .birthDay)
        self.profileImage = try container.decodeIfPresent(String.self, forKey: .profileImage)
        self.followers = try container.decodeIfPresent([Follow].self, forKey: .followers)
        self.following = try container.decodeIfPresent([Follow].self, forKey: .following)
        self.posts = try container.decodeIfPresent([String].self, forKey: .posts)
    }
    
    init() {
        self.userID = ""
        self.email = ""
        self.nick = nil
        self.phoneNum = nil
        self.birthDay = nil
        self.profileImage = nil
        self.followers = nil
        self.following = nil
        self.posts = nil
    }
}

struct Follow: Decodable, Hashable {
    let userID: String
    let nick: String
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case nick
        case profileImage
    }
}
