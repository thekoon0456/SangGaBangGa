//
//  DetailFeedViewModel.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/19/24.
//

import UIKit

import RxCocoa
import RxSwift

final class DetailFeedViewModel: ViewModel {
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let heartButtonTapped: Observable<Bool>
        let commentButtonTapped: ControlEvent<Void>
        let phoneButtonTapped: ControlEvent<Void>
        let paymentButtonTapped: ControlEvent<Void>
        let editButtonTapped: Observable<Void>
        let removeButtonTapped: Observable<Void>
    }
    
    struct Output {
        let data: Driver<ContentEntity>
        let heartButtonStatus: Driver<Bool>
        let heartCount: Driver<String>
        let comments: Driver<[PostCommentEntity]>
        let paymentDone: Driver<Void>
        let editFeed: Driver<Void>
        let removeFeed: Driver<Void>
    }
    
    private weak var coordinator: FeedCoordinator?
    private let postUseCase: PostUseCase
    private let commentUseCase: CommentUseCase
    private let likeUseCase: LikeUseCase
    private let paymentsUseCase: PaymentsUseCase
    private let paymentsService = PaymentsService()
    private let data: ContentEntity
    var disposeBag = DisposeBag()
    
    init(coordinator: FeedCoordinator,
         postUseCase: PostUseCase,
         commentUseCase: CommentUseCase,
         likeUseCase: LikeUseCase,
         paymentsUseCase: PaymentsUseCase,
         data: ContentEntity
    ) {
        self.coordinator = coordinator
        self.postUseCase = postUseCase
        self.commentUseCase = commentUseCase
        self.likeUseCase = likeUseCase
        self.paymentsUseCase = paymentsUseCase
        self.data = data
        print("data:", data)
    }
    
    func transform(_ input: Input) -> Output {
        let data = BehaviorRelay<ContentEntity>(value: ContentEntity.defaultData())
        let buttonStatus = BehaviorRelay(value: self.data.likes.contains { $0 == UserDefaultsManager.shared.userData.userID} )
        let heartCount = BehaviorRelay(value: self.data.likes.count)
        let commentsRelay = BehaviorRelay<[PostCommentEntity]>(value: [])
        let paymentsRelay = PublishRelay<Void>()
        let editRelay = PublishRelay<Void>()
        let removeRelay = PublishRelay<Void>()
        
        input
            .viewWillAppear
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.postUseCase.readPost(queryID: owner.data.postID)
            }
            .subscribe(with: self) { owner, value in
                data.accept(value)
                let sortedComments = owner.sortedComments(value.comments)
                commentsRelay.accept(sortedComments)
            }
            .disposed(by: disposeBag)
        
        input
            .heartButtonTapped
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .flatMap { owner, value in
                if value == true {
                    owner.likeUseCase.postLike(queryID: owner.data.postID, status: false)
                } else {
                    owner.likeUseCase.postLike(queryID: owner.data.postID, status: true)
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
            .commentButtonTapped
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.coordinator?.presentComment(data: owner.data, commentsRelay: commentsRelay)
            }
            .disposed(by: disposeBag)
        
        input
            .phoneButtonTapped
            .map { data.value }
            .asDriver(onErrorJustReturn: ContentEntity.defaultData())
            .drive(with: self) { owner, value in
                owner.call(value.creator.phoneNum)
            }
            .disposed(by: disposeBag)
        
        input
            .paymentButtonTapped
            .withUnretained(self)
            .flatMap { owner, _ in
                guard let coordinator = owner.coordinator else { return Observable<PaymentsRequest>.never() }
                return owner.paymentsService
                    .requestPayment(nav: coordinator.navigationController,
                                    postID: owner.data.postID,
                                    productName: owner.data.title,
                                    price: 100)
            }
            .withUnretained(self)
            .flatMap{ owner, request in
                owner.paymentsUseCase.validation(request: request)
            }
            .asDriver(onErrorJustReturn: PaymentsValidationEntity.defaultEntity())
            .drive(with: self) { owner, validation in
                owner.coordinator?.showToast(.paymentsSuccess(name: validation.productName,
                                                              price: validation.price))
                paymentsRelay.accept(())
            }
            .disposed(by: disposeBag)
        
        input
            .removeButtonTapped
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                owner.postUseCase.deletePost(queryID: data.value.postID)
                owner.coordinator?.popViewController()
            }
            .disposed(by: disposeBag)
        
        return Output(data: data.asDriver(onErrorJustReturn: ContentEntity.defaultData()),
                      heartButtonStatus: buttonStatus.asDriver(onErrorJustReturn: false),
                      heartCount: heartCount.map { String($0) }.asDriver(onErrorJustReturn: ""),
                      comments: commentsRelay.asDriver(onErrorJustReturn: []),
                      paymentDone: paymentsRelay.asDriver(onErrorJustReturn: ()),
                      editFeed: editRelay.asDriver(onErrorJustReturn: ()),
                      removeFeed: removeRelay.asDriver(onErrorJustReturn: ()))
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
        
        if let url =  URL(string: url),
           UIApplication.shared.canOpenURL(url as URL) {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
    
    func showAlert(title: String, message: String, action: @escaping () -> Void) {
        coordinator?.showAlert(title: title, message: message, action: action)
    }
}

