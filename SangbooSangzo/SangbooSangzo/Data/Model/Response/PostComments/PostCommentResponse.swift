//
//  PostCommentResponse.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/17/24.
//

import Foundation

struct PostCommentResponse: Decodable {
    let commentID: String
    let content: String
    let createdAt: String?
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
        self.createdAt = try container.decodeIfPresent(String.self, forKey: .createAt) ?? ""
        self.creator = try container.decode(CommentCreatorResponse.self, forKey: .creator)
    }
    
    init() {
        self.commentID = ""
        self.content = ""
        self.createdAt = nil
        self.creator = CommentCreatorResponse()
    }
    
    var toEntity: PostCommentEntity {
        PostCommentEntity(commentID: commentID,
                          content: content,
                          createdAt: createdAt ?? "",
                          creator: creator.toEntity)
    }
}

struct CommentCreatorResponse: Decodable {
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
    
    var toEntity: CommentCreatorEntity {
        CommentCreatorEntity(userID: userID,
                             nick: nick,
                             profileImage: profileImage ?? "")
    }
}

