//
//  FeedViewModel.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/15/24.
//

import Foundation

import RxCocoa
import RxSwift

final class FeedViewModel: ViewModel {
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let cellSelected: ControlEvent<IndexPath>
        let addButtonTapped: ControlEvent<Void>
        let fetchContents: Observable<Int>
        let cellHeartButtonTapped: Observable<(Int, Bool)>
        let cellCommentButtonTapped: Observable<Int>
        let filterHashTag: Observable<String?>
    }
    
    struct Output {
        let feeds: Driver<[ContentEntity]>
        let selectedFilter: Driver<String?>
    }
    
    // MARK: - Properties
    
    weak var coordinator: FeedCoordinator?
    private let postUseCase: PostUseCase
    private let likeUseCase: LikeUseCase
    private let userAPIManager = UserAPIManager.shared
    var disposeBag = DisposeBag()
    
    init(
        coordinator: FeedCoordinator?,
        postUseCase: PostUseCase,
        likeUseCase: LikeUseCase
    ) {
        self.coordinator = coordinator
        self.postUseCase = postUseCase
        self.likeUseCase = likeUseCase
    }
    
    func transform(_ input: Input) -> Output {
        
        let dataRelay = BehaviorRelay<[ContentEntity]>(value: [])
        let nextCursorRelay = BehaviorRelay<String?>(value: nil)
        let commentsRelay = BehaviorRelay<[PostCommentEntity]>(value: [])
        let updateRelay = BehaviorRelay<Void>(value: ())
        let selectedFilterRelay = BehaviorRelay<String?>(value: nil)
        
        Observable
            .combineLatest(
                input.viewWillAppear,
                TokenInterceptor.refreshSubject.asObservable(),
                commentsRelay.asObservable(),
                updateRelay.asObservable()
            )
            .withUnretained(self)
            .flatMap { owner, _ in
                owner
                    .postUseCase
                    .readPosts(query: .init(next: nextCursorRelay.value,
                                            limit: APISetting.limit,
                                            productID: APISetting.productID,
                                            hashTag: nil))
                    .catch { error in
                        print(error)
                        return Single<ReadPostsEntity>.never()
                    }
            }
            .subscribe { value in
                nextCursorRelay.accept(value.nextCursor)
                dataRelay.accept(value.data)
            }
            .disposed(by: disposeBag)
        
        input
            .addButtonTapped
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.coordinator?.pushToPost()
            }
            .disposed(by: disposeBag)
        
        input
            .cellSelected
            .subscribe(with: self) { owner, indexPath in
                owner.coordinator?.pushToDetail(data: dataRelay.value[indexPath.item])
            }
            .disposed(by: disposeBag)
        
        input
            .fetchContents
            .withUnretained(self)
            .flatMap { owner, index in
                guard let nextCursor = nextCursorRelay.value,
                      let lastData = dataRelay.value.last,
                      nextCursor != "0",
                      nextCursor == lastData.postID else {
                    return Single<ReadPostsEntity>.never()
                }
                return owner.postUseCase.readPosts(query: .init(next: nextCursor,
                                                                limit: APISetting.limit,
                                                                productID: APISetting.productID,
                                                                hashTag: nil))
            }
            .subscribe(with: self) { owner, value in
                var data = dataRelay.value
                data.append(contentsOf: value.data)
                dataRelay.accept(data)
                nextCursorRelay.accept(value.nextCursor)
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
                owner.coordinator?.presentComment(data: dataRelay.value[index],
                                                  commentsRelay: commentsRelay)
            }
            .disposed(by: disposeBag)
        
        input
            .filterHashTag
            .do { value in
                selectedFilterRelay.accept(value)
            }
            .withUnretained(self)
            .flatMap { owner, value in
                guard let value else {
                    return owner
                        .postUseCase
                        .readPosts(query: .init(next: nextCursorRelay.value,
                                                limit: APISetting.limit,
                                                productID: APISetting.productID,
                                                hashTag: nil))
                        .catch { error in
                            print(error)
                            return Single<ReadPostsEntity>.never()
                        }
                }
                return owner
                    .postUseCase
                    .readHashtagPosts(query: .init(next: nextCursorRelay.value,
                                                   limit: APISetting.limit,
                                                   productID: APISetting.productID,
                                                   hashTag: value))
                    .catch { error in
                        print(error)
                        return Single<ReadPostsEntity>.never()
                    }
            }
            .subscribe(with: self) { owner, value in
                print(value.data)
                dataRelay.accept(value.data)
                nextCursorRelay.accept(value.nextCursor)
            }
            .disposed(by: disposeBag)
        
        return Output(feeds: dataRelay.asDriver(),
                      selectedFilter: selectedFilterRelay.asDriver())
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


