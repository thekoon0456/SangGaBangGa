//
//  ProfileAPIManager.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/17/24.
//

import Foundation

import Moya
import RxMoya
import RxSwift

final class ProfileAPIManager {
    
    let logger = NetworkLoggerPlugin()
    lazy var provider = MoyaProvider<ProfileRouter>(session: Session(interceptor: TokenInterceptor()),
                                                    plugins: [logger])
    
    func getMyProfile() -> Single<ProfileResponse> {
        provider.rx.request(.getMyProfile)
            .map(ProfileResponse.self)
    }
    
    func updateMyProfile(request: ProfileEditRequest) -> Single<ProfileResponse> {
        provider.rx.request(.updateMyProfile(request: request))
            .map(ProfileResponse.self)
    }
    
    func getOtherProfile(id: String) -> Single<ProfileResponse> {
        provider.rx.request(.getOtherProfile(id: id))
            .map(ProfileResponse.self)
    }
}
