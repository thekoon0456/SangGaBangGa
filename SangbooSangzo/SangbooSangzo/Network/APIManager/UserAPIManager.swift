//
//  APIManager.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/10/24.
//

import Foundation

import Moya
import RxMoya
import RxSwift

final class UserAPIManager {
    
    static let shared = UserAPIManager()
    
    private init() { }
    
    let logger = NetworkLoggerPlugin()
    lazy var provider = MoyaProvider<UserRouter>(session: Session(interceptor: TokenInterceptor()), plugins: [logger])
    
    func join(query: UserJoinRequest) -> Single<UserJoinResponse> {
        provider.rx.request(.join(query: query))
            .map(UserJoinResponse.self)
    }
    
    func validationEmail(query: UserJoinEmailValidationRequest) -> Single<UserJoinEmailValidationResponse> {
        provider.rx.request(.validationEmail(query: query))
            .map(UserJoinEmailValidationResponse.self)
    }
    
    func login(query: LoginRequest) -> Single<LoginResponse> {
        provider.rx.request(.login(query: query))
            .debug()
            .map(LoginResponse.self)
    }
    
    func refreshToken() -> Single<RefreshTokenResponse> {
        provider.rx.request(.refreshToken)
            .map(RefreshTokenResponse.self)
    }
    
    func withdraw() -> Single<WithdrawResponse> {
        provider.rx.request(.withdraw)
            .map(WithdrawResponse.self)
    }
}


