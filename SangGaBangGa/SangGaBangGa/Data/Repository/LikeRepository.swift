//
//  LikeRepository.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 5/1/24.
//

import Foundation

import RxMoya
import RxSwift

protocol LikeRepository {
    func postLike(queryID: String, status: Bool) -> Single<LikeEntity>
    func readLikePosts(query: LikePostQuery) -> Single<ReadPostsEntity>
}

final class LikeRepositoryImpl: LikeRepository {
    
    private let apiService = LikeAPIService()
    
    func postLike(queryID: String, status: Bool) -> Single<LikeEntity> {
        apiService.postLike(queryID: queryID, status: status)
            .map { $0.toEntity }
    }
    
    func readLikePosts(query: LikePostQuery) -> Single<ReadPostsEntity> {
        apiService.readLikePosts(query: query)
            .map { $0.toEntity }
    }
}
