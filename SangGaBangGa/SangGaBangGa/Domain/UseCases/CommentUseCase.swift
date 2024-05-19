//
//  CommentUseCase.swift
//  SangGaBangGa
//
//  Created by Deokhun KIM on 5/19/24.
//

import Foundation

import RxSwift

protocol CommentUseCase {
    func postComments(queryID: String, content: String) -> Single<PostCommentEntity>
    func deleteComment(queryID: String, commentID: String)
}

final class CommentUseCaseImpl: CommentUseCase {
    
    private let commentRepository: CommentRepository
    
    init(commentRepository: CommentRepository) {
        self.commentRepository = commentRepository
    }
    
    func postComments(queryID: String, content: String) -> Single<PostCommentEntity> {
        commentRepository.postComments(queryID: queryID, content: content)
    }
    
    func deleteComment(queryID: String, commentID: String) {
        commentRepository.deleteComment(queryID: queryID, commentID: commentID)
    }
}
