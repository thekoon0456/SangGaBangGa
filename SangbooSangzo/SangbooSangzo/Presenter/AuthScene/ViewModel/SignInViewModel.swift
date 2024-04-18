//
//  SignInViewModel.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/15/24.
//

import Foundation

import RxCocoa
import RxSwift

final class SignInViewModel: ViewModel {
    
    struct Input {
        let email: ControlProperty<String>
        let password: ControlProperty<String>
        let nickname: ControlProperty<String>
        let phoneNumber: ControlProperty<String>
        let emailCheckButtonTapped: ControlEvent<Void>
        let signInButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let emailEnabled: Driver<Bool>
        let buttonEnabled: Driver<Bool>
    }
    
    // MARK: - Properties
    weak var coordinator: AuthCoordinator?
    private let userAPIManager = UserAPIManager.shared
    var disposeBag = DisposeBag()
    
    init(coordinator: AuthCoordinator? = nil) {
        self.coordinator = coordinator
    }
    
    func transform(_ input: Input) -> Output {
        
        let buttonRelay = PublishRelay<Bool>()
        let validationEmailRelay = BehaviorRelay<Bool>(value: true)
        let validationObservable = Observable.combineLatest(input.email.asObservable(),
                                                            input.password.asObservable(),
                                                            input.nickname.asObservable(),
                                                            input.phoneNumber.asObservable())
        //버튼 enable
        validationObservable
            .map { !$0.0.isEmpty && !$0.1.isEmpty && !$0.2.isEmpty && !$0.3.isEmpty }
            .subscribe { value in
                buttonRelay.accept(value)
            }.disposed(by: disposeBag)
        
        input
            .emailCheckButtonTapped
            .flatMap { input.email }
            .subscribe(with: self) { owner, email in
                owner
                    .userAPIManager
                    .validationEmail(query: UserJoinEmailValidationRequest(email: email))
                    .subscribe { result in
                        switch result {
                        case .success(let result):
                            print(result)
                            validationEmailRelay.accept(true)
                            print("성공")
                            owner.coordinator?
                                .showToast(.emailValidation(email: "사용 가능한 이메일입니다."))
                        case .failure(let error):
                            print(error)
                            validationEmailRelay.accept(false)
                            print("실패")
                            owner.coordinator?
                                .showToast(.emailValidation(email: "이미 가입한 이메일입니다."))
                        }
                    }
                    .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)
        
        //회원가입
        input
            .signInButtonTapped
            .flatMap { validationObservable }
            .subscribe(with: self) { owner, login in
                owner
                    .userAPIManager
                    .join(query: UserJoinRequest(email: login.0,
                                                 password: login.1,
                                                 nick: login.2,
                                                 phoneNum: login.3,
                                                 birthDay: nil))
                    .catchAndReturn(nil)
                    .subscribe(with: self) { owner, response in
                        guard let response else {
                            return
                        }
                        owner.coordinator?.dismissViewController()
                    }
                    .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)
        
        return Output(emailEnabled: validationEmailRelay.asDriver(onErrorJustReturn: true),
                      buttonEnabled: buttonRelay.asDriver(onErrorJustReturn: false))
    }
}
