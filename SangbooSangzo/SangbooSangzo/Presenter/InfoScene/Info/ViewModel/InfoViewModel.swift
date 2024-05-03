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
        let userProfile: Driver<ProfileEntity>
        let underBarIndex: Driver<Int>
        let feeds: Driver<[ContentEntity]>
    }
    
    weak var coordinator: InfoCoordinator?
    private let postRepository: PostRepository
    private let likeRepository: LikeRepository
    private let profileRepository: ProfileRepository
    var disposeBag = DisposeBag()
    
    init(
        coordinator: InfoCoordinator,
        postRepository: PostRepository,
        likeRepository: LikeRepository,
        profileRepository: ProfileRepository
    ) {
        self.coordinator = coordinator
        self.postRepository = postRepository
        self.likeRepository = likeRepository
        self.profileRepository = profileRepository
    }
    
    func transform(_ input: Input) -> Output {
        let userProfileRelay = BehaviorRelay<ProfileEntity>(value: ProfileEntity.defaultData())
        let updateBar = PublishRelay<Int>()
        
        let userProfile = input
            .viewWillAppear
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.profileRepository.getMyProfile()
            }
            .do { value in
                userProfileRelay.accept(value)
            }
            .asDriver(onErrorJustReturn: ProfileEntity.defaultData())
        
        let feeds = Observable.combineLatest(input.viewWillAppear,
                                             input.segmentTapped)
            .withUnretained(self)
            .do { owner, index in
                updateBar.accept(index.1)
            }
            .flatMap { owner, index in
                if index.1 == 0 {
                    owner.likeRepository.ReadLikePosts(query: .init(next: "",
                                                                    limit: APISetting.limit))
                } else {
                    owner.postRepository.readUserPosts(queryID: userProfileRelay.value.userID,
                                                       query: ReadPostsQuery(next: "",
                                                                             limit: APISetting.limit,
                                                                             productID: APISetting.productID))
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
