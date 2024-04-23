//
//  LoginViewModel.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/15/24.
//

import Foundation

import RxCocoa
import RxSwift

final class LoginViewModel: ViewModel {
    
    struct Input {
        let email: ControlProperty<String>
        let password: ControlProperty<String>
        let loginButtonTapped: ControlEvent<Void>
        let singInButtonTapped: ControlEvent<Void>
        let xbuttonTapped: ControlEvent<Void>
    }
    
    struct Output {
        //validation 추가
    }
    
    // MARK: - Properties
    
    weak var coordinator: AuthCoordinator?
    private let userAPIManager = UserAPIManager.shared
    var disposeBag = DisposeBag()
    
    init(coordinator: AuthCoordinator?) {
        self.coordinator = coordinator
    }
    
    func transform(_ input: Input) -> Output {
        
        let loginInfo = Observable.zip(
            input.email.asObservable(),
            input.password.asObservable()
        )
        
        input.loginButtonTapped
            .flatMap { loginInfo }
            .debug()
            .subscribe(with: self) { owner, login in
                owner
                    .userAPIManager
                    .login(query: LoginRequest(email: login.0, password: login.1))
                    .catch { [weak self] error in
                        guard let self else {
                            return Single<LoginResponse>.never()
                        }
                        coordinator?.showToast(.loginFail)
                        return Single<LoginResponse>.never()
                    }
                    .subscribe {result in
                        switch result {
                        case .success(let response):
                            UserDefaultsManager.shared.userData = UserData(userID: response.userID,
                                accessToken: response.accessToken,
                                                                             refreshToken: response.refreshToken)
                            owner.coordinator?.showToast(.loginSuccess)
                            owner.coordinator?.navigationController?.dismiss(animated: true)
                        case .failure(let error):
                            print(error)
                            owner.coordinator?.showToast(.loginFail)
                        }
                    }
                    .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)
        
        input.singInButtonTapped
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.coordinator?.pushToSignInView()
            }
            .disposed(by: disposeBag)
        
        input.xbuttonTapped
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.coordinator?.navigationController?.dismiss(animated: true)
                owner.coordinator?.finish()
            }
            .disposed(by: disposeBag)
        
        return Output()
    }
}
