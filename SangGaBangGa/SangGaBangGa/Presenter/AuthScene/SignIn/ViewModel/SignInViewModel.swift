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
    
    init(coordinator: AuthCoordinator?) {
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
            .withLatestFrom(input.email)
            .subscribe(with: self) { owner, email in
                guard email.isEmpty == false,
                      email.contains("@"),
                      email.contains(".") else {
                    owner.coordinator?
                        .showToast(.emailFormValidationFail)
                    return
                }
                owner
                    .userAPIManager
                    .validationEmail(query: UserJoinEmailValidationRequest(email: email))
                    .subscribe { result in
                        switch result {
                        case .success:
                            validationEmailRelay.accept(true)
                            print("성공")
                            owner.coordinator?
                                .showToast(.emailValidation(email: email))
                        case .failure(let error):
                            print(error)
                            validationEmailRelay.accept(false)
                            print("실패")
                            owner.coordinator?
                                .showToast(.emailValidationFail(email: email))
                        }
                    }
                    .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)
        
        //회원가입
        input
            .signInButtonTapped
            .flatMap { validationObservable }
            .withUnretained(self)
            .flatMap { owner, login in
                owner
                    .userAPIManager
                    .join(query: UserJoinRequest(email: login.0,
                                                 password: login.1,
                                                 nick: login.2 + " / " + login.3,
                                                 phoneNum: login.3,
                                                 birthDay: nil))
                    .catch { error in
                        DispatchQueue.main.async {
                            guard let coordinator = owner.coordinator else { return }
                            coordinator.showToast(.loginFail)
                        }
                        
                        return Single<UserJoinResponse?>.never()
                    }
            }
            .flatMap { _ in validationObservable }
            .withUnretained(self)
            .flatMap { owner, login -> Single<LoginResponse> in
                owner
                    .userAPIManager
                    .login(query: LoginRequest(email: login.0, password: login.1))
                    .catch { error in
                        DispatchQueue.main.async {
                            owner.coordinator?.showToast(.loginFail)
                        }
                        
                        return Single<LoginResponse>.never()
                    }
            }
            .subscribe(with: self) { owner, result in
                guard let coordinator = owner.coordinator else { return }
                UserDefaultsManager.shared.userData = UserData(userID: result.userID,
                                                               accessToken: result.accessToken,
                                                               refreshToken: result.refreshToken)
                coordinator.showToast(.loginSuccess) {
                    coordinator.didFinish(childCoordinator: coordinator)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(emailEnabled: validationEmailRelay.asDriver(onErrorJustReturn: true),
                      buttonEnabled: buttonRelay.asDriver(onErrorJustReturn: false))
    }
}
