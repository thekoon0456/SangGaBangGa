//
//  PostCommentResponse.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/17/24.
//

import Foundation

struct PostCommentResponse: Decodable {
    let commentID: String?
    let content: String?
    let createAt: String?
    let creator: CommentCreatorResponse
    
    enum CodingKeys: String, CodingKey {
        case commentID = "commnet_id"
        case content
        case createAt
        case creator
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.commentID = try container.decodeIfPresent(String.self, forKey: .commentID) ?? ""
        self.content = try container.decodeIfPresent(String.self, forKey: .content) ?? ""
        self.createAt = try container.decodeIfPresent(String.self, forKey: .createAt) ?? ""
        self.creator = try container.decodeIfPresent(CommentCreatorResponse.self, forKey: .creator)
    }
}

struct CommentCreatorResponse: Decodable {
    let userID: String?
    let nick: String?
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case nick
        case profileImage
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userID = try container.decodeIfPresent(String.self, forKey: .userID) ?? ""
        self.nick = try container.decodeIfPresent(String.self, forKey: .nick) ?? ""
        self.profileImage = try container.decodeIfPresent(String.self, forKey: .profileImage) ?? ""
    }
}
