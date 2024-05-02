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
    let nick: String
    let profileImage: String?
    let followers: [Follow]
    let following: [Follow]
    let posts: [String]
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email
        case nick
        case profileImage
        case followers
        case following
        case posts
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userID = try container.decode(String.self, forKey: .userID)
        self.email = try container.decode(String.self, forKey: .email)
        self.nick = try container.decode(String.self, forKey: .nick)
        self.profileImage = try container.decodeIfPresent(String.self, forKey: .profileImage)
        self.followers = try container.decode([Follow].self, forKey: .followers)
        self.following = try container.decode([Follow].self, forKey: .following)
        self.posts = try container.decode([String].self, forKey: .posts)
    }
    
    init() {
        self.userID = ""
        self.email = ""
        self.nick = ""
        self.profileImage = nil
        self.followers = []
        self.following = []
        self.posts = []
    }
    
    var toEntity: ProfileEntity {
        let nickName = nick.components(separatedBy: " / ").first ?? ""
        let phoneNum = nick.components(separatedBy: " / ").last ?? ""
        
        return ProfileEntity(userID: userID,
                             email: email,
                             nick: nickName,
                             phoneNum: phoneNum,
                             profileImage: profileImage,
                             followers: followers,
                             following: following,
                             posts: posts)
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
