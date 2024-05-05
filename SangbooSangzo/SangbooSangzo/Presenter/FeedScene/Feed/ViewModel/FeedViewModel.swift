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
    }
    
    struct Output {
        let feeds: Driver<[ContentEntity]>
    }
    
    // MARK: - Properties
    
    weak var coordinator: FeedCoordinator?
    private let postRepository: PostRepository
    private let userAPIManager = UserAPIManager.shared
    var disposeBag = DisposeBag()
    
    init(coordinator: FeedCoordinator?, postRepository: PostRepository) {
        self.coordinator = coordinator
        self.postRepository = postRepository
    }
    
    func transform(_ input: Input) -> Output {
        
        let dataRelay = BehaviorRelay<[ContentEntity]>(value: [])
        let nextCursorRelay = BehaviorRelay<String?>(value: nil)
        
        Observable
            .combineLatest(input.viewWillAppear, TokenInterceptor.refreshSubject)
            .withUnretained(self)
            .flatMap { owner, _ in
                owner
                    .postRepository
                    .readPosts(query: .init(next: nil,
                                            limit: APISetting.limit,
                                            productID: APISetting.productID))
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
                return owner.postRepository.readPosts(query: .init(next: nextCursor,
                                                                   limit: APISetting.limit,
                                                                   productID: APISetting.productID))
            }
            .subscribe(with: self) { owner, value in
                var data = dataRelay.value
                data.append(contentsOf: value.data)
                dataRelay.accept(data)
                nextCursorRelay.accept(value.nextCursor)
            }
            .disposed(by: disposeBag)
        
        return Output(feeds: dataRelay.asDriver())
    }
}
