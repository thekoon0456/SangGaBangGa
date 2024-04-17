//
//  FollowRouter.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/17/24.
//

import Foundation

import Moya

enum FollowRouter {
    case follow(queryID: String)
    case cancelFollow(queryID: String)
}

extension FollowRouter: TargetType {
    
    var baseURL: URL {
        URL(string: APIKey.baseURL)!
    }
    
    var path: String {
        switch self {
        case .follow(let userID):
            "/v1/follow/\(userID)"
        case .cancelFollow(let userID):
            "/v1/follow/\(userID)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .follow:
                .post
        case .cancelFollow:
                .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .follow, .cancelFollow:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .follow, .cancelFollow:
            [HTTPHeader.authorization: UserDefaultsManager.shared.userToken.accessToken ?? "",
             HTTPHeader.sesacKey: APIKey.sesacKey]
        }
    }
}


    
