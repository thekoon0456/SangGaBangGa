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
        
    }
    
    struct Output {
        
    }
    
    weak var coordinator: InfoCoordinator?
    var disposeBag = DisposeBag()
    
    init(coordinator: InfoCoordinator) {
        self.coordinator = coordinator
    }
    
    func transform(_ input: Input) -> Output {
        
        return Output()
    }
    
}
