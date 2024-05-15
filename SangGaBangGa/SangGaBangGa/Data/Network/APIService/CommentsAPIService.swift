//
//  CommentsAPIService.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/17/24.
//

import Foundation

import Moya
import RxMoya
import RxSwift

final class CommentsAPIService {
    
    private let disposeBag = DisposeBag()
    let logger = NetworkLoggerPlugin()
    lazy var provider = MoyaProvider<CommentsRouter>(session: Session(interceptor: TokenInterceptor()),
                                                     plugins: [logger])
    
    func postComments(queryID: String, content: String) -> Single<PostCommentResponse> {
        provider.rx.request(.postComments(queryID: queryID, content: content))
            .map(PostCommentResponse.self)
    }
    
    func deleteComment(queryID: String, commentID: String) {
        provider.rx.request(.deleteComment(queryID: queryID, commentID: commentID))
            .subscribe().disposed(by: disposeBag)
    }
}

