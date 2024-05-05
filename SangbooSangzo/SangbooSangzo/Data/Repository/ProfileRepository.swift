//
//  ProfileRepository.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 5/2/24.
//

import Foundation

import RxMoya
import RxSwift

protocol ProfileRepository {
    func getMyProfile() -> Single<ProfileEntity>
    func updateMyProfile(request: ProfileEditRequest) -> Single<ProfileEntity>
    func getOtherProfile(id: String) -> Single<ProfileEntity>
}

final class ProfileRepositoryImpl: ProfileRepository {
    
    private let apiService = ProfileAPIService()
    
    func getMyProfile() -> Single<ProfileEntity> {
        apiService.getMyProfile()
            .map { $0.toEntity }
    }
    
    func updateMyProfile(request: ProfileEditRequest) -> Single<ProfileEntity> {
        apiService.updateMyProfile(request: request)
            .map { $0.toEntity }
    }
    
    func getOtherProfile(id: String) -> Single<ProfileEntity> {
        apiService.getOtherProfile(id: id)
            .map { $0.toEntity }
    }
}
