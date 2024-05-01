//
//  Withdraw.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/11/24.
//

import Foundation

struct WithdrawResponse: Decodable {
    let userID: String
    let email: String
    let nick: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email
        case nick
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userID = try container.decode(String.self, forKey: .userID)
        self.email = try container.decode(String.self, forKey: .email)
        self.nick = try container.decode(String.self, forKey: .nick)
    }
}
