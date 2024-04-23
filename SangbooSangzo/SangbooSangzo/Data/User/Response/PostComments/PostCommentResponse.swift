//
//  PostCommentResponse.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/17/24.
//

import Foundation

struct PostCommentResponse: Decodable, Hashable {
    let commentID: String
    let content: String
    let createAt: String?
    let creator: CommentCreatorResponse
    
    enum CodingKeys: String, CodingKey {
        case commentID = "comment_id"
        case content
        case createAt
        case creator
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.commentID = try container.decode(String.self, forKey: .commentID)
        self.content = try container.decode(String.self, forKey: .content)
        self.createAt = try container.decodeIfPresent(String.self, forKey: .createAt) ?? ""
        self.creator = try container.decode(CommentCreatorResponse.self, forKey: .creator)
    }
    
    init() {
        self.commentID = ""
        self.content = ""
        self.createAt = nil
        self.creator = CommentCreatorResponse()
    }
}

struct CommentCreatorResponse: Decodable, Hashable {
    let userID: String
    let nick: String
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case nick
        case profileImage
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userID = try container.decode(String.self, forKey: .userID)
        self.nick = try container.decode(String.self, forKey: .nick)
        self.profileImage = try container.decodeIfPresent(String.self, forKey: .profileImage) ?? ""
    }
    
    init() {
        self.userID = ""
        self.nick = ""
        self.profileImage = nil
    }
}
