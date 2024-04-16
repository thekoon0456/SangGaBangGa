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
//        let viewWillAppear: ControlEvent<Void>
//        let cellSelected: Observable<(index: Int, model: UploadContentResponse)>
        let addButtonTapped: ControlEvent<Void>
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
        
        input
            .addButtonTapped
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.coordinator?.pushToPost()
        }
        .disposed(by: disposeBag)
        
        return Output()
    }
    
    
}
