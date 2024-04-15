//
//  FeedViewModel.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/15/24.
//

import Foundation

import RxCocoa
import RxSwift

final class FeedViewModel: ViewModel {

    struct Input {
        
    }
    
    struct Output {
        
    }
    
    // MARK: - Properties
    
    weak var coordinator: FeedCoordinator?
    var disposeBag = DisposeBag()
    
    init(coordinator: FeedCoordinator?) {
        self.coordinator = coordinator
    }
    
    func transform(_ input: Input) -> Output {
        
        return Output()
    }
    
    
}
