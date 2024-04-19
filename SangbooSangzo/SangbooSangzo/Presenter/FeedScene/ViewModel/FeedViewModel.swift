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
        let cellSelected: ControlEvent<UploadContentResponse>
        let addButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let feeds: Driver<[UploadContentResponse]>
    }
    
    // MARK: - Properties
    
    weak var coordinator: FeedCoordinator?
    private let postsAPIManager = PostsAPIManager.shared
    var disposeBag = DisposeBag()
    
    init(coordinator: FeedCoordinator?) {
        self.coordinator = coordinator
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
            .flatMap {
                PostsAPIManager.shared.readPosts(query: .init(next: nil, limit: "20", productID: "SangbooSangzo"))
            }
            .compactMap { $0.data }
            .debug()
            .asDriver(onErrorJustReturn: [])
        
        
        return Output(feeds: feeds)
    }
    
    
}
