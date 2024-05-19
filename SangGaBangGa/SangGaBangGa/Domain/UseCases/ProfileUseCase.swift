//
//  ProfileUseCase.swift
//  SangGaBangGa
//
//  Created by Deokhun KIM on 5/19/24.
//

import Foundation

import RxSwift

protocol ProfileUseCase {
    func getMyProfile() -> Single<ProfileEntity>
    func updateMyProfile(request: ProfileEditRequest) -> Single<ProfileEntity>
    func getOtherProfile(id: String) -> Single<ProfileEntity>
}

final class ProfileUseCaseImpl: ProfileUseCase {

    private let profileRepository: ProfileRepository
    
    init(profileRepository: ProfileRepository) {
        self.profileRepository = profileRepository
    }
    
    func getMyProfile() -> Single<ProfileEntity> {
        profileRepository.getMyProfile()
    }
    
    func updateMyProfile(request: ProfileEditRequest) -> Single<ProfileEntity> {
        profileRepository.updateMyProfile(request: request)
    }
    
    func getOtherProfile(id: String) -> Single<ProfileEntity> {
        profileRepository.getOtherProfile(id: id)
    }
}
