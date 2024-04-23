//
//  SettingViewModel.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/23/24.
//

import Foundation

import RxCocoa
import RxSwift

final class SettingViewModel: ViewModel {
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    // MARK: - Properties
    
    weak var coordinator: InfoCoordinator?
    var disposeBag = DisposeBag()
    
    init(coordinator: InfoCoordinator) {
        self.coordinator = coordinator
    }
    
    func transform(_ input: Input) -> Output {
        
        return Output()
    }
    
    
    
}
