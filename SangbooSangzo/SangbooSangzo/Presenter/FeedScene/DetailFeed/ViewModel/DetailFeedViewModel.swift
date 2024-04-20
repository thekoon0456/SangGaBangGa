//
//  DetailFeedViewModel.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/19/24.
//

import Foundation

import RxCocoa
import RxSwift

final class DetailFeedViewModel: ViewModel {
    
    struct Input {
        let viewDidLoad: ControlEvent<Void>
    }
    
    struct Output {
        let data: Driver<UploadContentResponse>
    }
    
    private weak var coordinator: Coordinator?
//    private let data: UploadContentResponse
    private let dataRelay = BehaviorRelay<UploadContentResponse>(value: UploadContentResponse())
    var disposeBag = DisposeBag()
    
    init(coordinator: Coordinator?, data: UploadContentResponse) {
        self.coordinator = coordinator
//        self.data = data
        dataRelay.accept(data)
    }
    
    func transform(_ input: Input) -> Output {
        
//        let dataRelay = BehaviorRelay<UploadContentResponse>(value: data)
        return Output(data: dataRelay.asDriver(onErrorJustReturn: UploadContentResponse()))
    }
}

