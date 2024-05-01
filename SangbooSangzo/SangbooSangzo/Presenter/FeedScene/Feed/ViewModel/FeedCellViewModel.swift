//
//  FeedCellViewModel.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/22/24.
//

import Foundation

import RxCocoa
import RxSwift

final class FeedCellViewModel: ViewModel {
    
    struct Input {
        let inputData: Observable<ContentEntity>
        let heartButtonTapped: Observable<Bool>
    }
    
    struct Output {
        let heartButtonStatus: Driver<Bool>
        let heartCount: Driver<String>
    }
    
    private let likeRepository: LikeRepository
    var disposeBag = DisposeBag()
    
    init(likeRepository: LikeRepository) {
        self.likeRepository = likeRepository
    }
    
    func transform(_ input: Input) -> Output {
        var inputData = ContentEntity.defaultData()
        let buttonStatus = BehaviorRelay(value: false)
        let heartCount = BehaviorRelay(value: 0)
        
        input
            .inputData
            .do { data in
                inputData = data
                heartCount.accept(data.likes.count)
            }
            .map { data in
                return data.likes.contains { $0 == UserDefaultsManager.shared.userData.userID }
            }
            .subscribe { value in
                buttonStatus.accept(value)
            }
            .disposed(by: disposeBag)
        
        input
            .heartButtonTapped
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .flatMap { owner, value in
                if value == true {
                    owner.likeRepository.postLike(queryID: inputData.postID, status: false)
                } else {
                    owner.likeRepository.postLike(queryID: inputData.postID, status: true)
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
        
        return Output(heartButtonStatus: buttonStatus.asDriver(onErrorJustReturn: false),
                      heartCount: heartCount.map { String($0) }.asDriver(onErrorJustReturn: ""))
    }
}


