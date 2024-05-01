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
        let cellSelected: ControlEvent<ContentEntity>
        let addButtonTapped: ControlEvent<Void>
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
        
        input
            .addButtonTapped
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.coordinator?.pushToPost()
            }
            .disposed(by: disposeBag)
        
        input
            .cellSelected
            .subscribe(with: self) { owner, model in
                print("cell.model", model)
                owner.coordinator?.pushToDetail(data: model)
            }
            .disposed(by: disposeBag)
        
        let feeds = input
            .viewWillAppear
            .withUnretained(self)
            .flatMap { owner, _ in
                owner
                    .postRepository
                    .readPosts(query: .init(next: nil, limit: "20", productID: "SangbooSangzo"))
            }
            .map { $0.data }
            .asDriver(onErrorJustReturn: [])
        
        return Output(feeds: feeds)
    }
}
