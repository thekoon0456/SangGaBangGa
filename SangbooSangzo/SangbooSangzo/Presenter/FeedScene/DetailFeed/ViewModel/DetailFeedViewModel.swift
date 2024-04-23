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
        let heartButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let data: Driver<UploadContentResponse>
        let heartButtonStatus: Driver<Bool>
        let heartCount: Driver<String>
    }
    
    private weak var coordinator: Coordinator?
    //    private let data: UploadContentResponse
    private let dataRelay = BehaviorRelay<UploadContentResponse>(value: UploadContentResponse())
    
    private let likeAPIManager = LikeAPIManager.shared
    var disposeBag = DisposeBag()
    
    init(coordinator: Coordinator?, data: UploadContentResponse) {
        self.coordinator = coordinator
        //        self.data = data
        dataRelay.accept(data)
    }
    
    func transform(_ input: Input) -> Output {
        
        let buttonStatus = BehaviorRelay(value: false)
        let heartCount = BehaviorRelay(value: 0)
        
        dataRelay.subscribe(with: self) { owner, data in
            guard let likes = data.likes else { return }
            heartCount.accept(likes.count)
            buttonStatus.accept(likes.contains { $0 == UserDefaultsManager.shared.userData.userID} ? true : false)
            
        }
        .disposed(by: disposeBag)
        
        input
            .heartButtonTapped
            .withUnretained(self)
            .flatMap { owner, value in
                if buttonStatus.value == true {
                    owner.likeAPIManager.postLike(queryID: owner.dataRelay.value.postID ?? "", status: false)
                } else {
                    owner.likeAPIManager.postLike(queryID: owner.dataRelay.value.postID ?? "", status: true)
                }
            }
            .subscribe { value in
                guard let bool = value.element?.likeStatus else { return }
                buttonStatus.accept(bool)
                bool == true
                ? heartCount.accept(heartCount.value + 1)
                : heartCount.accept(heartCount.value - 1)
            }
            .disposed(by: disposeBag)
        
        return Output(data: dataRelay.asDriver(onErrorJustReturn: UploadContentResponse()),
                      heartButtonStatus: buttonStatus.asDriver(onErrorJustReturn: false),
                      heartCount: heartCount.map { String($0) }.asDriver(onErrorJustReturn: "")
        )
    }
}

