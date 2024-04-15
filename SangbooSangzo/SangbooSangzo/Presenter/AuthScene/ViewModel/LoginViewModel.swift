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
        
    }
    
    struct Output {
        
    }
    
    // MARK: - Properties
    
    weak var coordinator: AuthCoordinator?
    var disposeBag = DisposeBag()
    
    init(coordinator: AuthCoordinator?) {
        self.coordinator = coordinator
    }
    
    func transform(_ input: Input) -> Output {
        
        return Output()
    }
    
}
