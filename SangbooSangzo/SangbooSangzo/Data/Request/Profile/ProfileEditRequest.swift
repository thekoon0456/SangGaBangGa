//
//  ProfileEditRequest.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/24/24.
//

import Foundation

struct ProfileEditRequest: Encodable {
    let nick: String?
    let phoneNum: String?
    let birthDay: String?
    let profile: Data?
    
    enum CodingKeys: CodingKey {
        case nick
        case phoneNum
        case birthDay
        case profile
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.nick, forKey: .nick)
        try container.encodeIfPresent(self.phoneNum, forKey: .phoneNum)
        try container.encodeIfPresent(self.birthDay, forKey: .birthDay)
        try container.encodeIfPresent(self.profile, forKey: .profile)
    }
    
    init(nick: String?, phoneNum: String?, birthDay: String?, profile: Data?) {
        self.nick = nick
        self.phoneNum = phoneNum
        self.birthDay = birthDay
        self.profile = profile
    }
}
