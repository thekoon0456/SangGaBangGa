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
        let viewWillAppear: Observable<Void>
        let heartButtonTapped: Observable<Bool>
    }
    
    struct Output {
        let data: Driver<UploadContentResponse>
        let heartButtonStatus: Driver<Bool>
        let heartCount: Driver<String>
    }
    
    private weak var coordinator: Coordinator?
    private let data: UploadContentResponse
    private let postAPIManager = PostsAPIManager.shared
    private let likeAPIManager = LikeAPIManager.shared
    var disposeBag = DisposeBag()
    
    init(coordinator: Coordinator?, data: UploadContentResponse) {
        self.coordinator = coordinator
        self.data = data
        print("data:", data)
    }
    
    func transform(_ input: Input) -> Output {
            let buttonStatus = BehaviorRelay(value: data.likes.contains { $0 == UserDefaultsManager.shared.userData.userID} )
        let heartCount = BehaviorRelay(value: data.likes.count)
        
        let data = input
            .viewWillAppear
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.postAPIManager.readPost(queryID: owner.data.postID)
            }
            .asDriver(onErrorJustReturn: UploadContentResponse())
        
        input
            .heartButtonTapped
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .flatMap { owner, value in
                if value == true {
                    owner.likeAPIManager.postLike(queryID: owner.data.postID, status: false)
                } else {
                    owner.likeAPIManager.postLike(queryID: owner.data.postID, status: true)
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
        
        return Output(data: data,
                      heartButtonStatus: buttonStatus.asDriver(onErrorJustReturn: false),
                      heartCount: heartCount.map { String($0) }.asDriver(onErrorJustReturn: "")
        )
    }
}

