//
//  LikeRouter.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/17/24.
//

import Foundation

import Moya

enum LikeRouter {
    case postLike(queryID: String, status: Bool)
    case ReadLikePosts(query: LikePostQuery)
}

extension LikeRouter: TargetType {
    
    var baseURL: URL {
        URL(string: APIKey.baseURL)!
    }
    
    var path: String {
        switch self {
        case .postLike(let postId, _):
            "/v1/posts/\(postId)/like"
        case .ReadLikePosts:
            "/v1/posts/likes/me"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postLike:
                .post
        case .ReadLikePosts:
                .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .postLike(_, let status):
            let params: [String: Any] = ["like_status": status]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .ReadLikePosts(query: let query):
            let params: [String: Any] = [
                "next": query.next ?? "",
                "limit": query.limit ?? "",
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .postLike, .ReadLikePosts:
            [HTTPHeader.authorization: UserDefaultsManager.shared.userToken.accessToken ?? "",
             HTTPHeader.sesacKey: APIKey.sesacKey]
        }
    }
}

