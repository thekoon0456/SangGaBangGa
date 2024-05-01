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
}

final class CommentRepositoryImpl: CommentRepository {
    
    private let apiManager = CommentsAPIManager()
    
    func postComments(queryID: String, content: String) -> Single<PostCommentEntity> {
        apiManager.postComments(queryID: queryID, content: content)
            .map { $0.toEntity }
    }
}
