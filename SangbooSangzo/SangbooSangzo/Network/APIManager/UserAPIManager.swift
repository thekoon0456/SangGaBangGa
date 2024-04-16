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
    
//    let provider = MoyaProvider<UserRouter>(session: Session(interceptor: TokenInterceptor()))
    let logger = NetworkLoggerPlugin()
    lazy var provider = MoyaProvider<UserRouter>(plugins: [logger])
    private let disposeBag = DisposeBag()
    
    func join(query: UserJoinRequest) -> Single<UserJoinResponse> {
        provider.rx.request(.join(query: query))
            .map(UserJoinResponse.self)
    }
    
    func validationEmail(query: UserJoinEmailValidationRequest) -> Single<UserJoinEmailValidationResponse> {
        provider.rx.request(.validationEmail(query: query))
            .map(UserJoinEmailValidationResponse.self)
    }
    
    func login(query: LoginRequest) {
        provider.rx.request(.login(query: query))
            .debug()
            .map(LoginResponse.self)
            .subscribe { response in
                print("성공")
                print(response)
            } onFailure: { error in
                print("실패")
                print(error)
            }
            .disposed(by: disposeBag)

        
//        provider.request(.login(query: query)) { result in
//            switch result {
//            case .success(let response):
//                print(response.data)
//                
//            case .failure(let error):
//                print(error)
//            }
//        }
//        
//        return provider.rx.request(.login(query: query)).map(LoginResponse.self)
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


