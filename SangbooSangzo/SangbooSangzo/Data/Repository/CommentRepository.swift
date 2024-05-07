//
//  CommentRepository.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 5/1/24.
//

import Foundation

import RxMoya
import RxSwift

protocol CommentRepository {
    func postComments(queryID: String, content: String) -> Single<PostCommentEntity>
    func deleteComment(queryID: String, commentID: String)
}

final class CommentRepositoryImpl: CommentRepository {
    
    private let apiService = CommentsAPIService()
    
    func postComments(queryID: String, content: String) -> Single<PostCommentEntity> {
        apiService.postComments(queryID: queryID, content: content)
            .map { $0.toEntity }
    }
    
    func deleteComment(queryID: String, commentID: String) {
        apiService.deleteComment(queryID: queryID, commentID: commentID)
    }
}
