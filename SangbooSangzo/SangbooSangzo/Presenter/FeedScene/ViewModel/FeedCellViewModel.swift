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
        let inputData: Observable<UploadContentResponse>
        let heartButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let heartButtonStatus: Driver<Bool>
        let heartCount: Driver<String>
    }
    
    private let likeAPIManager = LikeAPIManager.shared
    var disposeBag = DisposeBag()
    
    func transform(_ input: Input) -> Output {
        let postID = BehaviorRelay(value: "")
        let buttonStatus = BehaviorRelay(value: false)
        let heartCount = BehaviorRelay(value: 0)
        
        input
            .inputData
            .do { data in
                postID.accept(data.postID ?? "")
                heartCount.accept(data.likes?.count ?? 0)
            }
            .map { data in
                guard let like = data.likes else { return false }
                return like.contains { $0 == UserDefaultsManager.shared.userData.userID }
            }
            .subscribe { value in
                buttonStatus.accept(value)
            }
            .disposed(by: disposeBag)
        
        input
            .heartButtonTapped
            .withUnretained(self)
            .flatMap { owner, value in
                if buttonStatus.value == true {
                    owner.likeAPIManager.postLike(queryID: postID.value, status: false)
                } else {
                    owner.likeAPIManager.postLike(queryID: postID.value, status: true)
                }
            }
            .subscribe { value in
                guard let bool = value.element?.likeStatus else { return }
                buttonStatus.accept(bool)
                if bool == true {
                    let newCount = (heartCount.value + 1)
                    heartCount.accept(newCount)
                } else {
                    let newCount = (heartCount.value - 1)
                    heartCount.accept(newCount)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(heartButtonStatus: buttonStatus.asDriver(onErrorJustReturn: false),
                      heartCount: heartCount.map { String($0) }.asDriver(onErrorJustReturn: ""))
    }
}


