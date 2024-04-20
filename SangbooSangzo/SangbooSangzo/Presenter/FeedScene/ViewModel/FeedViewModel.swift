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
        let viewDidLoad: ControlEvent<Void>
        let viewWillAppear: Observable<Void>
        let cellSelected: ControlEvent<UploadContentResponse>
        let addButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let feeds: Driver<[UploadContentResponse]>
    }
    
    // MARK: - Properties
    
    weak var coordinator: FeedCoordinator?
    private let postsAPIManager = PostsAPIManager.shared
    private let userAPIManager = UserAPIManager.shared
    var disposeBag = DisposeBag()
    
    init(coordinator: FeedCoordinator?) {
        self.coordinator = coordinator
    }
    
    func transform(_ input: Input) -> Output {
        
        input
            .viewWillAppear
            .subscribe(with: self) { owner, _ in
                
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
                    .postsAPIManager
                    .readPosts(query: .init(next: nil, limit: "20", productID: "SangbooSangzo"))
            }
            .compactMap { $0.data }
            .debug()
            .asDriver(onErrorJustReturn: [])
        
        TokenInterceptor
            .errorSubject
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                owner.coordinator?.presentLoginScene()
            }
            .disposed(by: disposeBag)
        
        return Output(feeds: feeds)
    }
    
    
}
