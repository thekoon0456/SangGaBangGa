//
//  FollowAPIManager.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/17/24.
//

import Foundation

import Moya
import RxMoya
import RxSwift

final class FollowAPIManager {
    
    static let shared = FollowAPIManager()
    
    private init() { }
    
    let logger = NetworkLoggerPlugin()
    lazy var provider = MoyaProvider<FollowRouter>(session: Session(interceptor: TokenInterceptor()),
                                                   plugins: [logger])
    
    func postLike(queryID: String) -> Single<FollowResponse> {
        provider.rx.request(.follow(queryID: queryID))
            .map(FollowResponse.self)
    }
    
    func ReadLikePosts(queryID: String) -> Single<FollowResponse> {
        provider.rx.request(.cancelFollow(queryID: queryID))
            .map(FollowResponse.self)
    }
}
