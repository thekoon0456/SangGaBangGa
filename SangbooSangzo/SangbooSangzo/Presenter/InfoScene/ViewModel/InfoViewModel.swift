//
//  InfoViewModel.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/15/24.
//

import Foundation

import RxCocoa
import RxSwift

final class InfoViewModel: ViewModel {
    
    struct Input {
        let viewWillAppear: Observable<Void>
    }
    
    struct Output {
        let userProfile: Driver<ProfileResponse>
    }
    
    weak var coordinator: InfoCoordinator?
    private let profileAPIManager = ProfileAPIManager.shared
    var disposeBag = DisposeBag()
    
    init(coordinator: InfoCoordinator) {
        self.coordinator = coordinator
    }
    
    func transform(_ input: Input) -> Output {
        
        let userProfile = input
            .viewWillAppear
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.profileAPIManager.getMyProfile()
            }
            .asDriver(onErrorJustReturn: ProfileResponse())
        
        return Output(userProfile: userProfile)
    }
    
}
