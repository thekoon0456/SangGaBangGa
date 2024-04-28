//
//  UserJoinRequest.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/12/24.
//

import Foundation

struct UserJoinRequest: Encodable {
    let email: String
    let password: String
    let nick: String
    let phoneNum: String?
    let birthDay: String?
    
    enum CodingKeys: CodingKey {
        case email
        case password
        case nick
        case phoneNum
        case birthDay
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.email, forKey: .email)
        try container.encode(self.password, forKey: .password)
        try container.encode(self.nick, forKey: .nick)
        try container.encodeIfPresent(self.phoneNum, forKey: .phoneNum)
        try container.encodeIfPresent(self.birthDay, forKey: .birthDay)
    }
}
