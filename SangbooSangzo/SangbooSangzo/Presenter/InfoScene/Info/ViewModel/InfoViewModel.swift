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
        let settingTapped: ControlEvent<Void>
        let cellTapped: ControlEvent<ContentEntity>
    }
    
    struct Output {
        let userProfile: Driver<ProfileResponse>
        let underBarIndex: Driver<Int>
        let feeds: Driver<[ContentEntity]>
    }
    
    weak var coordinator: InfoCoordinator?
    private let postRepository: PostRepository
    private let likeRepository: LikeRepository
    private let profileAPIManager = ProfileAPIManager.shared
    var disposeBag = DisposeBag()
    
    init(
        coordinator: InfoCoordinator,
        postRepository: PostRepository,
        likeRepository: LikeRepository
    ) {
        self.coordinator = coordinator
        self.postRepository = postRepository
        self.likeRepository = likeRepository
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
        
        let feeds = Observable.combineLatest(input.viewWillAppear,
                                             input.segmentTapped)
            .withUnretained(self)
            .do { owner, index in
                updateBar.accept(index.1)
            }
            .flatMap { owner, index in
                if index.1 == 0 {
                    owner.likeRepository.ReadLikePosts(query: .init(next: "",
                                                                    limit: "20"))
                } else {
                    owner.postRepository.readUserPosts(queryID: userProfileRelay.value.userID,
                                                       query: ReadPostsQuery(next: "",
                                                                             limit: "20",
                                                                             productID: "SangbooSangzo"))
                }
            }
            .map { $0.data }
            .asDriver(onErrorJustReturn: [ContentEntity]())
        
        input
            .settingTapped
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.coordinator?.pushToSetting()
            }
            .disposed(by: disposeBag)
        
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
