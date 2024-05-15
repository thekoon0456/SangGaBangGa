//
//  FollowResponse.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/17/24.
//

import Foundation

struct FollowResponse: Decodable {
    let nick: String?
    let opponentNick: String?
    let followingStatus: Bool
    
    enum CodingKeys: String, CodingKey {
        case nick
        case opponentNick = "opponent_nick"
        case followingStatus = "following_status"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.nick = try container.decodeIfPresent(String.self, forKey: .nick) ?? ""
        self.opponentNick = try container.decodeIfPresent(String.self, forKey: .opponentNick) ?? ""
        self.followingStatus = try container.decode(Bool.self, forKey: .followingStatus)
    }
}
