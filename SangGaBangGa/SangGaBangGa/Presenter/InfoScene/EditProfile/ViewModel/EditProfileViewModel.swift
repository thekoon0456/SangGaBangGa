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
    private let profileUseCase: ProfileUseCase
    var disposeBag = DisposeBag()
    
    init(
        coordinator: InfoCoordinator?,
        profileUseCase: ProfileUseCase,
        userInfo: ProfileEntity
    ) {
        self.coordinator = coordinator
        self.profileUseCase = profileUseCase
        self.userInfo = userInfo
    }
    
    func transform(_ input: Input) -> Output {
        
        let nickNameRelay = BehaviorRelay(value: "")
        let phoneRelay = BehaviorRelay(value: "")
        let buttonRelay = PublishRelay<Bool>()
        
        let validationObservable = Observable.combineLatest(
            nickNameRelay.asObservable(),
            phoneRelay.asObservable(),
            input.imageData
        )
        
        input
            .nickname
            .subscribe { value in
                nickNameRelay.accept(value)
            }
            .disposed(by: disposeBag)
        
        input
            .phoneNumber
            .subscribe { value in
                phoneRelay.accept(value)
            }
            .disposed(by: disposeBag)
        
        let userInfo = input
            .viewWillAppear
            .withUnretained(self)
            .map { owner, _ in
                owner.userInfo
            }
            .do { value in
                nickNameRelay.accept(value.nick)
                phoneRelay.accept(value.phoneNum)
            }
            .asDriver(onErrorJustReturn: ProfileEntity.defaultData())
        
        //버튼 enable
        validationObservable
            .map { !$0.0.isEmpty && !$0.1.isEmpty }
            .subscribe { value in
                buttonRelay.accept(value)
            }.disposed(by: disposeBag)
        
        //수정하기
        input
            .editButtonTapped
            .flatMap { validationObservable }
            .withUnretained(self)
            .flatMap { owner, login in
                owner
                    .profileUseCase
                    .updateMyProfile(request: .init(nick: login.0 + " / " + login.1,
                                                    phoneNum: "",
                                                    birthDay: nil,
                                                    profile: login.2))
            }
            .asDriver(onErrorJustReturn: ProfileEntity.defaultData())
            .drive(with: self) { owner, response in
                owner.coordinator?.showToast(.updateUserData) {
                    owner.coordinator?.popViewController()
                }
            }
            .disposed(by: disposeBag)
        
        return Output(userInfo: userInfo,
                      buttonEnabled: buttonRelay.asDriver(onErrorJustReturn: false))
    }
}
