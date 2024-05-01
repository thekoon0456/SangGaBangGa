//
//  DetailFeedViewModel.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/19/24.
//

import UIKit
import Foundation

import RxCocoa
import RxSwift

final class DetailFeedViewModel: ViewModel {
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let heartButtonTapped: Observable<Bool>
        let phoneButtonTapped: ControlEvent<Void>
        let commentSendButtonTapped: Observable<String>
    }
    
    struct Output {
        let data: Driver<ContentEntity>
        let heartButtonStatus: Driver<Bool>
        let heartCount: Driver<String>
        let comments: Driver<[PostCommentEntity]>
    }
    
    private weak var coordinator: Coordinator?
    private let data: ContentEntity
    private let postRepository = PostRepository()
    private let likeAPIManager = LikeAPIManager.shared
    private let commentAPIManager = CommentsAPIManager.shared
    var disposeBag = DisposeBag()
    
    init(coordinator: Coordinator?, data: ContentEntity) {
        self.coordinator = coordinator
        self.data = data
        print("data:", data)
    }
    
    func transform(_ input: Input) -> Output {
        let data = BehaviorRelay<ContentEntity>(value: ContentEntity.defaultsEntity)
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
        
        input
            .phoneButtonTapped
            .map { data.value }
            .asDriver(onErrorJustReturn: ContentEntity.defaultsEntity)
            .drive(with: self) { owner, value in
                owner.call("01083849023")
            }
            .disposed(by: disposeBag)
        
        
        input
            .commentSendButtonTapped
            .withUnretained(self)
            .flatMap { owner, value in
                owner.commentAPIManager.postComments(queryID: owner.data.postID, content: value)
                    .catchAndReturn(PostCommentResponse())
            }
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.postRepository.readPost(queryID: owner.data.postID)
            }
            .subscribe(with: self) { owner, value in
                data.accept(value)
                comments.accept(owner.sortedComments(value.comments))
            }
            .disposed(by: disposeBag)
        
        return Output(data: data.asDriver(onErrorJustReturn: ContentEntity.defaultsEntity),
                      heartButtonStatus: buttonStatus.asDriver(onErrorJustReturn: false),
                      heartCount: heartCount.map { String($0) }.asDriver(onErrorJustReturn: ""),
                      comments: comments.asDriver(onErrorJustReturn: [])
        )
    }
    
    // MARK: - 댓글 sorted
    
    func sortedComments(_ input: [PostCommentEntity]) -> [PostCommentEntity] {
        let formatter = DateFormatterManager.shared
        
        return input.sorted { item1, item2 in
            let date1 = formatter.formattedISO8601ToDate(item1.createdAt) ?? Date()
            let date2 = formatter.formattedISO8601ToDate(item2.createdAt) ?? Date()
            return date1 < date2
        }
    }
    
    // MARK: - 전화 걸기 연결
    
    func call(_ input: String) {
        
        let url = "tel://\(input)"
        
        // URLScheme 문자열을 통해 URL 인스턴스를 만들어 줍니다.
        if let url =  URL(string: url),
           UIApplication.shared.canOpenURL(url as URL) {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
}

