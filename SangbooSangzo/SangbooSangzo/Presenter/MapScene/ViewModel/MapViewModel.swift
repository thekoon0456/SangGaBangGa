//
//  MapViewModel.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/15/24.
//

import Foundation

import RxCocoa
import RxSwift

final class MapViewModel: ViewModel {
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    // MARK: - Properties
    
    weak var coordinator: MapCoordinator?
    var disposeBag = DisposeBag()
    
    init(coordinator: MapCoordinator? = nil) {
        self.coordinator = coordinator
    }
    
    func transform(_ input: Input) -> Output {
        
        return Output()
    }
    
    
}
