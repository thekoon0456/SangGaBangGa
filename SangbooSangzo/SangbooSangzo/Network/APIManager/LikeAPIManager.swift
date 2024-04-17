//
//  LikeAPIManager.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/17/24.
//

import Foundation

import Moya
import RxMoya
import RxSwift

final class LikeAPIManager {
    
    static let shared = LikeAPIManager()
    
    private init() { }
    
    let logger = NetworkLoggerPlugin()
    lazy var provider = MoyaProvider<LikeRouter>(session: Session(interceptor: TokenInterceptor()), plugins: [logger])
    
    func postLike(queryID: String, status: Bool) -> Single<LikeStatusResponse> {
        provider.rx.request(.postLike(queryID: queryID, status: status))
            .map(LikeStatusResponse.self)
    }
    
    func ReadLikePosts(query: LikePostQuery) -> Single<ReadPostsResponse> {
        provider.rx.request(.ReadLikePosts(query: query))
            .map(ReadPostsResponse.self)
    }
}

