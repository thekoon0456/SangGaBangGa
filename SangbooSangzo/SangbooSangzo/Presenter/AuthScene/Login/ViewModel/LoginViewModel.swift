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
            .withUnretained(self)
            .flatMap { (owner, login) -> Single<LoginResponse> in
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
        
        input.singInButtonTapped
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.coordinator?.pushToSignInView()
            }
            .disposed(by: disposeBag)
        
//        input.xbuttonTapped
//            .asDriver()
//            .drive(with: self) { owner, _ in
//                owner.coordinator?.navigationController.dismiss(animated: true)
//                owner.coordinator?.finish()
//            }
//            .disposed(by: disposeBag)
        
        return Output()
    }
}
