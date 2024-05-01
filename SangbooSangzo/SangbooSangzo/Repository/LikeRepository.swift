//
//  LikeRepository.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 5/1/24.
//

import Foundation

import RxMoya
import RxSwift

final class LikeRepository {
    
    private let apiManager = LikeAPIManager()
    
    func postLike(queryID: String, status: Bool) -> Single<LikeEntity> {
        apiManager.postLike(queryID: queryID, status: status)
            .map { $0.toEntity }
    }
    
    func ReadLikePosts(query: LikePostQuery) -> Single<ReadPostsEntity> {
        apiManager.ReadLikePosts(query: query)
            .map { $0.toEntity }
    }
}
