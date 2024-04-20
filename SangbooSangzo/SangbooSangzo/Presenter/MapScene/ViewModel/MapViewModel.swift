//
//  MapViewModel.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/15/24.
//

import Foundation

import RxCocoa
import RxSwift

final class MapViewModel: ViewModel {
    
    struct Input {
        let viewWillAppear: Observable<Void>
    }
    
    struct Output {
        let feeds: Driver<[UploadContentResponse]>
    }
    
    // MARK: - Properties
    
    weak var coordinator: MapCoordinator?
    private let postsAPIManager = PostsAPIManager.shared
    var disposeBag = DisposeBag()
    
    init(coordinator: MapCoordinator? = nil) {
        self.coordinator = coordinator
    }
    
    func transform(_ input: Input) -> Output {
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
        
        return Output(feeds: feeds)
    }
}
