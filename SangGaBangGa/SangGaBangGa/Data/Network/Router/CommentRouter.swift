//
//  CommentRouter.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/17/24.
//

import Foundation

import Moya

enum CommentsRouter {
    case postComments(queryID: String, content: String)
    case deleteComment(queryID: String, commentID: String)
}

extension CommentsRouter: TargetType {
    
    var baseURL: URL {
        URL(string: APIKey.baseURL)!
    }
    
    var path: String {
        switch self {
        case .postComments(let postID, _):
            "/v1/posts/\(postID)/comments"
        case .deleteComment(let postID , let commentID):
            "/v1/posts/\(postID)/comments/\(commentID)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postComments:
                .post
        case .deleteComment:
                .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .postComments(_, let content):
            let params: [String: Any] = ["content": content]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .deleteComment:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .postComments:
            [HTTPHeader.authorization: UserDefaultsManager.shared.userData.accessToken ?? "",
             HTTPHeader.contentType: HTTPHeader.json,
             HTTPHeader.sesacKey: APIKey.sesacKey]
        case .deleteComment(queryID: let queryID, commentID: let commentID):
            [HTTPHeader.authorization: UserDefaultsManager.shared.userData.accessToken ?? "",
             HTTPHeader.sesacKey: APIKey.sesacKey]
        }
    }
}
