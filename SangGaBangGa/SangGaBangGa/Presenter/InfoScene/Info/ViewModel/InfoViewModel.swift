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
        let cellHeartButtonTapped: Observable<(Int, Bool)>
        let cellCommentButtonTapped: Observable<Int>
    }
    
    struct Output {
        let userProfile: Driver<ProfileEntity>
        let underBarIndex: Driver<Int>
        let feeds: Driver<[ContentEntity]>
    }
    
    weak var coordinator: InfoCoordinator?
    private let postUseCase: PostUseCase
    private let likeUseCase: LikeUseCase
    private let profileUseCase: ProfileUseCase
    private let paymentsUseCase: PaymentsUseCase
//    private let paymentsService = PaymentsService()
    var disposeBag = DisposeBag()
    
    init(
        coordinator: InfoCoordinator,
        postUseCase: PostUseCase,
        likeUseCase: LikeUseCase,
        profileUseCase: ProfileUseCase,
        paymentsUseCase: PaymentsUseCase
    ) {
        self.coordinator = coordinator
        self.postUseCase = postUseCase
        self.likeUseCase = likeUseCase
        self.profileUseCase = profileUseCase
        self.paymentsUseCase = paymentsUseCase
    }
    
    func transform(_ input: Input) -> Output {
        let userProfileRelay = BehaviorRelay<ProfileEntity>(value: ProfileEntity.defaultData())
        let updateBar = PublishRelay<Int>()
        let dataRelay = BehaviorRelay<[ContentEntity]>(value: [])
        let commentsRelay = BehaviorRelay<[PostCommentEntity]>(value: [])
        let updateRelay = BehaviorRelay<Void>(value: ())
        
        let userProfile = input
            .viewWillAppear
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.profileUseCase.getMyProfile()
            }
            .do { value in
                userProfileRelay.accept(value)
            }
            .asDriver(onErrorJustReturn: ProfileEntity.defaultData())
        
        Observable
            .combineLatest(
                input.viewWillAppear,
                input.segmentTapped,
                commentsRelay.asObservable(),
                updateRelay.asObservable()
            )
            .withUnretained(self)
            .do { owner, index in
                print(index.1)
                updateBar.accept(index.1)
            }
            .flatMap { owner, index in
                switch index.1 {
                case 0:
                    let posts = owner.likeUseCase.readLikePosts(query: .init(next: "",
                                                                                limit: APISetting.limit))
                    return posts.map { $0.data }
                case 1:
                    let posts = owner.postUseCase.readUserPosts(queryID: userProfileRelay.value.userID,
                                                                   query: ReadPostsQuery(next: "",
                                                                                         limit: APISetting.limit,
                                                                                         productID: APISetting.productID,
                                                                                         hashTag: nil))
                    return posts.map { $0.data }
                default:
                    return owner.paymentsContentsSingle()
                }
            }
            .subscribe { value in
                dataRelay.accept(value)
            }
            .disposed(by: disposeBag)
        
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
        
        input
            .cellHeartButtonTapped
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .map { value in
                var status = value.1
                status.toggle()
                return (value.0, status)
            }
            .withUnretained(self)
            .flatMap { owner, value in
                owner
                    .likeUseCase
                    .postLike(queryID: dataRelay.value[value.0].postID, status: value.1)
                    .catch { error in
                        print(error)
                        return Single<LikeEntity>.never()
                    }
            }
            .subscribe { _ in
                updateRelay.accept(())
            }
            .disposed(by: disposeBag)
        
        
        input
            .cellCommentButtonTapped
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: 0)
            .drive(with: self) { owner, index in
                let comments = owner.sortedComments(dataRelay.value[index].comments)
                commentsRelay.accept(comments)
            }
            .disposed(by: disposeBag)
        
        return Output(userProfile: userProfile,
                      underBarIndex: updateBar.asDriver(onErrorJustReturn: 0),
                      feeds: dataRelay.asDriver())
    }
    
    func paymentsContentsSingle() -> Single<[ContentEntity]> {
        return paymentsUseCase.readMyPayments()
            .asObservable()
            .map { payments in
                Set(payments.map { $0.postID })
            }
            .flatMap { ids in
                Observable.combineLatest(ids.map { id in
                    self.postUseCase.readPost(queryID: id)
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
    
    func sortedComments(_ input: [PostCommentEntity]) -> [PostCommentEntity] {
        let formatter = DateFormatterManager.shared
        
        return input.sorted { item1, item2 in
            let date1 = formatter.formattedISO8601ToDate(item1.createdAt) ?? Date()
            let date2 = formatter.formattedISO8601ToDate(item2.createdAt) ?? Date()
            return date1 < date2
        }
    }
}
