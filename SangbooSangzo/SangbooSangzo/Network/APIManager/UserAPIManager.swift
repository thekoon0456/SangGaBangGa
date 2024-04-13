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
    
    let provider = MoyaProvider<UserRouter>(session: Session(interceptor: TokenInterceptor()))
    
    func join(query: UserJoinRequest) -> Single<UserJoinResponse> {
        provider.rx.request(.join(query: query))
            .map(UserJoinResponse.self)
            .catch { error -> Single<UserJoinResponse> in
                print("join 에러 발생: \(error)")
                throw error
            }
    }
    
    func validationEmail(query: UserJoinEmailValidationRequest) -> Single<UserJoinEmailValidationResponse> {
        provider.rx.request(.validationEmail(query: query))
            .map(UserJoinEmailValidationResponse.self)
            .catch { error -> Single<UserJoinEmailValidationResponse> in
                print("validationEmail 에러 발생: \(error)")
                throw error
            }
    }
    
    func login(query: LoginRequest) -> Single<LoginResponse> {
        provider.rx.request(.login(query: query))
            .map(LoginResponse.self)
            .catch { error -> Single<LoginResponse> in
                print("login 에러 발생: \(error)")
                throw error
            }
    }
    
    func refreshToken() -> Single<RefreshTokenResponse> {
        provider.rx.request(.refreshToken)
            .map(RefreshTokenResponse.self)
            .catch { error -> Single<RefreshTokenResponse> in
                print("refreshToken 에러 발생: \(error)")
                throw error
            }
    }
    
    func withdraw() -> Single<WithdrawResponse> {
        provider.rx.request(.withdraw)
            .map(WithdrawResponse.self)
            .catch { error -> Single<WithdrawResponse> in
                print("refreshToken 에러 발생: \(error)")
                throw error
            }
    }
}


