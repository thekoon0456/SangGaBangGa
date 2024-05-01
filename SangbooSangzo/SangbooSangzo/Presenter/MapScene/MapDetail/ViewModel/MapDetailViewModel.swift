//
//  MapDetailViewModel.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/26/24.
//impl, live, defa

import Foundation

import RxCocoa
import RxSwift

final class MapDetailViewModel: ViewModel {
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let cellTapped: Observable<Void>
        let heartButtonTapped: Observable<Bool>
    }
    
    struct Output {
        let data: Driver<ContentEntity>
        let heartButtonStatus: Driver<Bool>
        let heartCount: Driver<String>
        let comments: Driver<[PostCommentEntity]>
    }
    
    private weak var coordinator: MapCoordinator?
    private let data: ContentEntity
    private let postRepository: PostRepository
    private let commentRepository: CommentRepository
    private let likeRepository: LikeRepository
    var disposeBag = DisposeBag()
    
    init(
        coordinator: MapCoordinator,
        postRepository: PostRepository,
        commentRepository: CommentRepository,
        likeRepository: LikeRepository,
        data: ContentEntity
    ) {
        self.coordinator = coordinator
        self.postRepository = postRepository
        self.commentRepository = commentRepository
        self.likeRepository = likeRepository
        self.data = data
        print("data:", data)
    }
    
    func transform(_ input: Input) -> Output {
        let data = BehaviorRelay<ContentEntity>(value: ContentEntity.defaultData())
        let buttonStatus = BehaviorRelay(value: self.data.likes.contains { $0 == UserDefaultsManager.shared.userData.userID} )
        let heartCount = BehaviorRelay(value: self.data.likes.count)
        let comments = BehaviorRelay<[PostCommentEntity]>(value: [])
        
        input
            .viewWillAppear
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.postRepository.readPost(queryID: owner.data.postID)
            }
            .subscribe { value in
                data.accept(value)
                comments.accept(value.comments)
            }
            .disposed(by: disposeBag)
        
        input
            .cellTapped
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                owner.coordinator?.pushToMapDetail(data: data.value)
            }
            .disposed(by: disposeBag)
        
        input
            .heartButtonTapped
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .flatMap { owner, value in
                if value == true {
                    owner.likeRepository.postLike(queryID: owner.data.postID, status: false)
                } else {
                    owner.likeRepository.postLike(queryID: owner.data.postID, status: true)
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
        
        return Output(data: data.asDriver(onErrorJustReturn: ContentEntity.defaultData()),
                      heartButtonStatus: buttonStatus.asDriver(onErrorJustReturn: false),
                      heartCount: heartCount.map { String($0) }.asDriver(onErrorJustReturn: ""),
                      comments: comments.asDriver(onErrorJustReturn: [])
        )
    }
}
