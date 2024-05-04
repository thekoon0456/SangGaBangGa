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
        let searchRegion: ControlProperty<String>
        let selectCell: Driver<ContentEntity>
    }
    
    struct Output {
        let feeds: Driver<[ContentEntity]>
    }
    
    // MARK: - Properties
    
    weak var coordinator: MapCoordinator?
    private let postRepository: PostRepository
    var disposeBag = DisposeBag()
    
    init(coordinator: MapCoordinator, postRepository: PostRepository) {
        self.coordinator = coordinator
        self.postRepository = postRepository
    }
    
    func transform(_ input: Input) -> Output {
        
        input
            .searchRegion
            
        
        
        input
            .selectCell
            .drive(with: self) { owner, data in
                owner.coordinator?.presentDetail(data: data)
            }
            .disposed(by: disposeBag)
        
        let feeds = input
            .viewWillAppear
            .withUnretained(self)
            .flatMap { owner, _ in
                owner
                    .postRepository
                    .readPosts(query: .init(next: nil,
                                            limit: APISetting.limit,
                                            productID: APISetting.productID))
            }
            .compactMap { $0.data }
            .debug()
            .asDriver(onErrorJustReturn: [])
        
        return Output(feeds: feeds)
    }
}
