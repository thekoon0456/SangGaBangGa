//
//  CommentEntity.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 5/1/24.
//

import Foundation

struct PostCommentEntity: Decodable, Hashable {
    let commentID: String
    let content: String
    let createdAt: String
    let creator: ProfileEntity
    
    static func defaultData() -> PostCommentEntity {
        PostCommentEntity(commentID: "",
                          content: "",
                          createdAt: "",
                          creator: ProfileEntity.defaultData())
    }
}
