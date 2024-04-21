//
//  UserRouter.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/10/24.
//

import Foundation

import Moya

enum UserRouter {
    case join(query: UserJoinRequest)
    case validationEmail(query: UserJoinEmailValidationRequest)
    case login(query: LoginRequest)
    case refreshToken
    case withdraw
}

extension UserRouter: TargetType {
    
    var baseURL: URL {
        URL(string: APIKey.baseURL)!
    }
    
    var path: String {
        switch self {
        case .join:
            "/v1/users/join"
        case .validationEmail:
            "/v1/validation/email"
        case .login:
            "/v1/users/login"
        case .refreshToken:
            "/v1/auth/refresh"
        case .withdraw:
            "/v1/users/withdraw"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .join:
                .post
        case .validationEmail:
                .post
        case .login:
                .post
        case .refreshToken:
                .get
        case .withdraw:
                .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .join(let query):
            let params = [
                "email": query.email,
                "password": query.password,
                "nick": query.nick,
                "phoneNum": query.phoneNum ?? "",
                "birthDay": query.birthDay ?? ""
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .validationEmail(let query):
            let param = [
                "email": query.email
            ]
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
        case .login(let query):
            let params: [String: String] = [
                "email": query.email,
                "password": query.password
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .refreshToken:
            return .requestPlain
        case .withdraw:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .join, .validationEmail, .login:
            [HTTPHeader.contentType: HTTPHeader.json,
             HTTPHeader.sesacKey: APIKey.sesacKey]
        case .refreshToken:
            [HTTPHeader.authorization: UserDefaultsManager.shared.userData.accessToken ?? "",
             HTTPHeader.sesacKey: APIKey.sesacKey,
             HTTPHeader.refresh: UserDefaultsManager.shared.userData.refreshToken ?? ""]
        case .withdraw:
            [HTTPHeader.authorization: UserDefaultsManager.shared.userData.accessToken ?? "",
             HTTPHeader.sesacKey: APIKey.sesacKey]
        }
    }
}

extension TargetType {
    
    var validationType: ValidationType {
          return .successCodes
      }
}
