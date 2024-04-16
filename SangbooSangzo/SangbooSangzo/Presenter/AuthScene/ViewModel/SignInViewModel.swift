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
        let joinButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        
    }
    
    // MARK: - Properties
    weak var coordinator: AuthCoordinator?
    private let userAPIManager = UserAPIManager.shared
    var disposeBag = DisposeBag()
    
    init(coordinator: AuthCoordinator? = nil) {
        self.coordinator = coordinator
    }
    
    func transform(_ input: Input) -> Output {
        
        let singInObservable = Observable.zip(input.email.asObservable(),
                                              input.password.asObservable(),
                                              input.nickname.asObservable(),
                                              input.phoneNumber.asObservable())
        input
            .joinButtonTapped
            .flatMap { singInObservable }
            .subscribe(with: self) { owner, login in
                owner.userAPIManager.join(query: UserJoinRequest(email: login.0,
                                                                 password: login.1,
                                                                 nick: login.2,
                                                                 phoneNum: login.3,
                                                                 birthDay: nil))
                .subscribe(with: self) { owner, _ in
                    owner.coordinator?.dismissViewController()
                }
                .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)
        
        
        
        return Output()
    }
}
