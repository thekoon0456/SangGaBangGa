//
//  CommentsAPIManager.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/17/24.
//

import Foundation

import Moya
import RxMoya
import RxSwift

final class CommentsAPIManager {
    
    static let shared = CommentsAPIManager()
    
    private init() { }
    
    let logger = NetworkLoggerPlugin()
    lazy var provider = MoyaProvider<CommentsRouter>(session: Session(interceptor: TokenInterceptor()), plugins: [logger])
    
    func postComments(queryID: String) -> Single<UserJoinResponse> {
        provider.rx.request(.postComments(queryID: queryID))
            .map(UserJoinResponse.self)
    }
}

