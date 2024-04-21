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
        let viewWillAppear: Observable<Void>
        let segmentTapped: ControlProperty<Int>
        let cellTapped: ControlEvent<UploadContentResponse>
    }
    
    struct Output {
        let userProfile: Driver<ProfileResponse>
        let underBarIndex: Driver<Int>
        let feeds: Driver<[UploadContentResponse]>
    }
    
    weak var coordinator: InfoCoordinator?
    private let postAPIManager = PostsAPIManager.shared
    private let likeAPIManager = LikeAPIManager.shared
    private let profileAPIManager = ProfileAPIManager.shared
    var disposeBag = DisposeBag()
    
    init(coordinator: InfoCoordinator) {
        self.coordinator = coordinator
    }
    
    func transform(_ input: Input) -> Output {
        let userProfileRelay = BehaviorRelay<ProfileResponse>(value: ProfileResponse())
        let updateBar = PublishRelay<Int>()
        
        let userProfile = input
            .viewWillAppear
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.profileAPIManager.getMyProfile()
            }
            .do { value in
                userProfileRelay.accept(value)
            }
            .asDriver(onErrorJustReturn: ProfileResponse())
        
        let feeds = input
            .segmentTapped
            .withUnretained(self)
            .do { owner, index in
                updateBar.accept(index)
            }
            .flatMap { owner, index in
                if index == 0 {
                    owner.likeAPIManager.ReadLikePosts(query: .init(next: "",
                                                                    limit: "20"))
                } else {
                    owner.postAPIManager.readUserPosts(queryID: userProfileRelay.value.userID,
                                                       query: ReadPostsQuery(next: "",
                                                                             limit: "20",
                                                                             productID: "SangbooSangzo"))
                }
            }
            .compactMap { $0.data }
            .asDriver(onErrorJustReturn: [UploadContentResponse]())
        
        input
            .cellTapped
            .asDriver()
            .drive(with: self) { owner, value in
                owner.coordinator?.pushToDetail(data: value)
            }
            .disposed(by: disposeBag)
        
        return Output(userProfile: userProfile,
                      underBarIndex: updateBar.asDriver(onErrorJustReturn: 0),
                      feeds: feeds)
    }
}
