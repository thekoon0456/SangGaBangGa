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
        let cellDeleted: ControlEvent<IndexPath>
    }
    
    struct Output {
        let comments: Driver<[PostCommentEntity]>
    }
    
    // MARK: - Properties
    
    var disposeBag = DisposeBag()
    private let commentUseCase: CommentUseCase
    private let data: ContentEntity
    private let commentsRelay: BehaviorRelay<[PostCommentEntity]>
    
    // MARK: - Lifecycles
    
    init(data: ContentEntity,
         commentUseCase: CommentUseCase,
         commentsRelay: BehaviorRelay<[PostCommentEntity]>
    ) {
        self.commentUseCase = commentUseCase
        self.data = data
        self.commentsRelay = commentsRelay
    }
    
    // MARK: - Helpers
    
    func transform(_ input: Input) -> Output {
        
        input
            .sendButtonTapped
            .withUnretained(self)
            .flatMap { owner, value in
                owner
                    .commentUseCase
                    .postComments(queryID: owner.data.postID, content: value)
                    .catchAndReturn(PostCommentEntity.defaultData())
            }
            .subscribe(with: self) { owner, value in
                var comments = owner.commentsRelay.value
                comments.append(value)
                owner.commentsRelay.accept(comments)
            }
            .disposed(by: disposeBag)
        
        input
            .cellDeleted
            .subscribe(with: self) { owner, index in
                var comments = owner.commentsRelay.value
                owner.commentUseCase.deleteComment(queryID: owner.data.postID,
                                                      commentID: comments[index.row].commentID)
                comments.remove(at: index.row)
                owner.commentsRelay.accept(comments)
            }
            .disposed(by: disposeBag)
        
        return Output(comments: commentsRelay.asDriver(onErrorJustReturn: []))
    }
    
    func getCurrentComments() -> [PostCommentEntity] {
        commentsRelay.value
    }
}
