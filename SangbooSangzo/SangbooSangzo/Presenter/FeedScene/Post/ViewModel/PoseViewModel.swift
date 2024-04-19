//
//  PoseViewModel.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/16/24.
//

import Foundation

import RxCocoa
import RxSwift

final class PostViewModel: ViewModel {
    
    struct Input {
        let selectedPhotos: BehaviorRelay<[Data]>
        let title: ControlProperty<String>
        let category: BehaviorRelay<String?>
        let address: ControlProperty<String>
        let deposit: ControlProperty<String>
        let rent: ControlProperty<String>
        let space: ControlProperty<String>
        let content: ControlProperty<String>
        let post: ControlEvent<Void>
    }
    
    struct Output {
        let selectedPhotos: Driver<[Data]>
        let buttonEnable: Driver<Bool>
    }
    
    private weak var coordinator: FeedCoordinator?
    private let postAPIManager = PostsAPIManager.shared
    var disposeBag = DisposeBag()
    
    init(coordinator: FeedCoordinator?) {
        self.coordinator = coordinator
    }
    
    func transform(_ input: Input) -> Output {

        var request = UploadContentRequest(title: nil,
                                           content: nil,
                                           content1: nil,
                                           content2: nil,
                                           content3: nil,
                                           content4: nil,
                                           content5: nil,
                                           productID: "SangbooSangzo",
                                           files: nil)
        
        let imageURLSubject = BehaviorSubject<[String]>(value: [])
        
        let buttonEnable = Observable.combineLatest(
            [
                input.title.map { $0.isEmpty },
                input.category.map { $0?.isEmpty ?? true },
                input.address.map { $0.isEmpty },
                input.deposit.map { $0.isEmpty },
                input.rent.map { $0.isEmpty },
                input.space.map { $0.isEmpty },
                input.content.map { $0.isEmpty }
            ]
        )
            .map { fields in
                return fields.filter { $0 == true }.count == 0 ? true : false
            }
        
        input
            .title
            .subscribe { value in
                request.title = value
            }
            .disposed(by: disposeBag)
        
        input
            .title
            .subscribe { value in
                request.title = value
            }
            .disposed(by: disposeBag)
        
        input
            .content
            .subscribe { value in
                request.content = value
            }
            .disposed(by: disposeBag)
        
        input
            .category
            .subscribe { value in
                request.content1 = value
            }
            .disposed(by: disposeBag)
        
        input
            .address
            .subscribe { value in
                request.content2 = value
            }
            .disposed(by: disposeBag)
        
//        input
//            .content3
//            .subscribe { value in
//                request.content3 = value
//            }
//            .disposed(by: disposeBag)
        
        Observable.zip(input.deposit,
                       input.rent)
            .subscribe { value in
                request.content4 = "\(value.0) / \(value.1)"
            }
            .disposed(by: disposeBag)
        
        input
            .space
            .subscribe { value in
                request.content5 = value
            }
            .disposed(by: disposeBag)
        
        input
            .post
            .withUnretained(self)
            .flatMap { owner, _ in
                input
                    .selectedPhotos
                    .flatMap { data in
                        owner
                            .postAPIManager
                            .uploadImages(query: .init(datas: data))
                    }
            }
            .subscribe(with: self) { owner, response in
                owner
                    .postAPIManager
                    .uploadContents(images: response.files, query: request)
                    .subscribe { response in
                        switch response {
                        case .success(let response):
                            print(response)
                            owner.coordinator?.popViewController()
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                    .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)
        
        return Output(selectedPhotos: input.selectedPhotos.asDriver(onErrorJustReturn: []),
                      buttonEnable: buttonEnable.asDriver(onErrorJustReturn: false))
    }
}
