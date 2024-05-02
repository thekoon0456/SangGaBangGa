//
//  EditProfileViewModel.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/24/24.
//

import Foundation

import RxCocoa
import RxSwift

final class EditProfileViewModel: ViewModel {
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let password: ControlProperty<String>
        let nickname: ControlProperty<String>
        let phoneNumber: ControlProperty<String>
        let imageData: Observable<Data?>
        let editButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let userInfo: Driver<ProfileEntity>
        let buttonEnabled: Driver<Bool>
    }
    
    // MARK: - Properties
    weak var coordinator: InfoCoordinator?
    private let userInfo: ProfileEntity
    private let userAPIManager = UserAPIManager.shared
    private let profileRepository: ProfileRepository
    var disposeBag = DisposeBag()
    
    init(coordinator: InfoCoordinator?, profileRepository: ProfileRepository, userInfo: ProfileEntity) {
        self.coordinator = coordinator
        self.profileRepository = profileRepository
        self.userInfo = userInfo
    }
    
    func transform(_ input: Input) -> Output {
        
        let buttonRelay = PublishRelay<Bool>()
        let validationObservable = Observable.combineLatest(input.password.asObservable(),
                                                            input.nickname.asObservable(),
                                                            input.phoneNumber.asObservable(),
                                                            input.imageData)
        //버튼 enable
        validationObservable
            .map { !$0.0.isEmpty && !$0.1.isEmpty && !$0.2.isEmpty }
            .subscribe { value in
                buttonRelay.accept(value)
            }.disposed(by: disposeBag)
        
        //수정하기
        input
            .editButtonTapped
            .flatMap { validationObservable }
            .subscribe(with: self) { owner, login in
                owner
                    .profileRepository
                    .updateMyProfile(request: .init(nick: login.1,
                                                    phoneNum: login.2,
                                                    birthDay: nil,
                                                    profile: login.3))
                    .catchAndReturn(ProfileEntity.defaultData())
                    .subscribe(with: self) { owner, response in
                        owner.coordinator?.popViewController()
                    }
                    .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)
        
        let userInfo = input
            .viewWillAppear
            .withUnretained(self)
            .map { owner, _ in
                owner.userInfo
            }
            .asDriver(onErrorJustReturn: ProfileEntity.defaultData())
        
        return Output(userInfo: userInfo,
                      buttonEnabled: buttonRelay.asDriver(onErrorJustReturn: false))
    }
}
