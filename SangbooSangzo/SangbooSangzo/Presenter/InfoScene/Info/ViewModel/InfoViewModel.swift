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
    private let paymentsRepository: PaymentsAPIRepository
    private let paymentsService = PaymentsService()
    var disposeBag = DisposeBag()
    
    init(
        coordinator: InfoCoordinator,
        postRepository: PostRepository,
        likeRepository: LikeRepository,
        profileRepository: ProfileRepository,
        paymentsRepository: PaymentsAPIRepository
    ) {
        self.coordinator = coordinator
        self.postRepository = postRepository
        self.likeRepository = likeRepository
        self.profileRepository = profileRepository
        self.paymentsRepository = paymentsRepository
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
                print(index.1)
                updateBar.accept(index.1)
            }
            .flatMap { owner, index in
                switch index.1 {
                case 0:
                    let posts = owner.likeRepository.ReadLikePosts(query: .init(next: "",
                                                                                limit: APISetting.limit))
                    return posts.map { $0.data }
                case 1:
                    let posts = owner.postRepository.readUserPosts(queryID: userProfileRelay.value.userID,
                                                                   query: ReadPostsQuery(next: "",
                                                                                         limit: APISetting.limit,
                                                                                         productID: APISetting.productID))
                    return posts.map { $0.data }
                default:
                    return owner.paymentsContentsSingle()
                }
            }
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

    func paymentsContentsSingle() -> Single<[ContentEntity]> {
        return paymentsRepository.readMyPayments()
            .asObservable()
            .map { payments in
                Set(payments.map { $0.postID })
            }
            .flatMap { ids in
                Observable.combineLatest(ids.map { id in
                    self.postRepository.readPost(queryID: id)
                        .asObservable()
                        .flatMap {
                            Observable.just($0)
                        }
                })
            }
            .map { results in
                results.compactMap { $0 }
            }
            .asSingle()
    }
}
