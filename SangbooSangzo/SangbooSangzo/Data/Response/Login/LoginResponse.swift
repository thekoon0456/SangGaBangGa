//
//  LoginResponse.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/12/24.
//

import Foundation

struct LoginResponse: Decodable, Hashable {
    let userID: String?
    let email: String?
    let nick: String?
    let profileImage: String?
    let phoneNum: String?
    let accessToken: String?
    let refreshToken: String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email
        case nick
        case profileImage
        case phoneNum
        case accessToken
        case refreshToken
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userID = try container.decodeIfPresent(String.self, forKey: .userID)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.nick = try container.decodeIfPresent(String.self, forKey: .nick)
        self.profileImage = try container.decodeIfPresent(String.self, forKey: .profileImage)
        self.phoneNum = try container.decodeIfPresent(String.self, forKey: .phoneNum)
        self.accessToken = try container.decodeIfPresent(String.self, forKey: .accessToken)
        self.refreshToken = try container.decodeIfPresent(String.self, forKey: .refreshToken)
    }
    
    init() {
        self.userID = nil
        self.email = nil
        self.nick = nil
        self.profileImage = nil
        self.phoneNum = nil
        self.accessToken = nil
        self.refreshToken = nil
    }
    
    var toEntity: LoginEntity {
        LoginEntity(userID: userID ?? "",
                    email: email ?? "",
                    nick: nick ?? "",
                    profileImage: profileImage,
                    phoneNum: phoneNum ?? "",
                    accessToken: accessToken ?? "",
                    refreshToken: refreshToken ?? "")
    }
}

struct LoginEntity: Decodable, Hashable {
    let userID: String
    let email: String
    let nick: String
    let profileImage: String?
    let phoneNum: String?
    let accessToken: String
    let refreshToken: String
}
