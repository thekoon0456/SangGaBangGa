//
//  CommentRouter.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/17/24.
//

import Foundation

import Moya

enum CommentsRouter {
    case postComments(queryID: String)
}

extension CommentsRouter: TargetType {
    
    var baseURL: URL {
        URL(string: APIKey.baseURL)!
    }
    
    var path: String {
        switch self {
        case .postComments(let postId):
            "/v1/posts/\(postId)/comments"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postComments:
                .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .postComments:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .postComments:
            [HTTPHeader.authorization: UserDefaultsManager.shared.userData.accessToken ?? "",
             HTTPHeader.contentType: HTTPHeader.json,
             HTTPHeader.sesacKey: APIKey.sesacKey]
        }
    }
}
