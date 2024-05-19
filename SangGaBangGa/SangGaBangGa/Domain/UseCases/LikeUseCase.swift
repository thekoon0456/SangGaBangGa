//
//  LikeUseCase.swift
//  SangGaBangGa
//
//  Created by Deokhun KIM on 5/19/24.
//

import Foundation

import RxSwift

protocol LikeUseCase {
    func postLike(queryID: String, status: Bool) -> Single<LikeEntity>
    func ReadLikePosts(query: LikePostQuery) -> Single<ReadPostsEntity>
}

final class LikeUseCaseImpl: LikeUseCase {
    
    private let likeRepository: LikeRepository
    
    init(likeRepository: LikeRepository) {
        self.likeRepository = likeRepository
    }
    
    func postLike(queryID: String, status: Bool) -> Single<LikeEntity> {
        likeRepository.postLike(queryID: queryID, status: status)
    }
    
    func ReadLikePosts(query: LikePostQuery) -> Single<ReadPostsEntity> {
        likeRepository.readLikePosts(query: query)
    }
}
