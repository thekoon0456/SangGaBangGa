//
//  CommentViewModel.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 5/2/24.
//

import Foundation

import RxCocoa
import RxSwift

final class CommentViewModel: ViewModel {
    
    struct Input {
        let sendButtonTapped: Observable<String>
    }
    
    struct Output {
        let comments: Driver<[PostCommentEntity]>
    }
    
    var disposeBag = DisposeBag()
    private let commentRepository: CommentRepository
    private let data: ContentEntity
    private let commentsRelay: BehaviorRelay<[PostCommentEntity]>
    
    init(data: ContentEntity,
         commentRepository: CommentRepository,
         commentsRelay: BehaviorRelay<[PostCommentEntity]>
    ) {
        self.commentRepository = commentRepository
        self.data = data
        self.commentsRelay = commentsRelay
    }
    
    func transform(_ input: Input) -> Output {
        
        input
            .sendButtonTapped
            .withUnretained(self)
            .flatMap { owner, value in
                owner.commentRepository.postComments(queryID: owner.data.postID, content: value)
                    .catchAndReturn(PostCommentEntity.defaultData())
            }
            .subscribe(with: self) { owner, value in
                var comments = owner.commentsRelay.value
                comments.append(value)
                owner.commentsRelay.accept(comments)
            }
            .disposed(by: disposeBag)
        
        return Output(comments: commentsRelay.asDriver(onErrorJustReturn: []))
    }
}
