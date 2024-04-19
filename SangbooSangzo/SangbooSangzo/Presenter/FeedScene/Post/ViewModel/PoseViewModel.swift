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
    
    private let postAPIManager = PostsAPIManager.shared
    var disposeBag = DisposeBag()
    
    func transform(_ input: Input) -> Output {
        
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
        
        
        //        input
        //            .selectedPhotos
        //            .subscribe(with: self) { owner, values in
        //                owner
        //                    .postAPIManager
        //                    .uploadImages(query: .init(datas: values))
        //                    .subscribe { response in
        //                        switch response {
        //                        case .success(let response):
        //                            imageURLSubject.onNext(response.files)
        //                        case .failure(let error):
        //                            print(error.localizedDescription)
        //                        }
        //                    }
        //                    .disposed(by: owner.disposeBag)
        //            }
        //            .disposed(by: disposeBag)
        
        
        input
            .post
            .subscribe(with: self) { owner, _ in
                guard let images = try? imageURLSubject.value() else { return }
                owner
                    .postAPIManager
                    .uploadContents(images: images, query: .init(title: "test",
                                                                 content: "test",
                                                                 content1: "test",
                                                                 content2: "test",
                                                                 content3: "test",
                                                                 content4: "test",
                                                                 content5: "test",
                                                                 productID: "SangbooSangzo",
                                                                 files: images))
                    .subscribe { response in
                        switch response {
                        case .success(let response):
                            print(response)
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                    .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)
        
        return Output(selectedPhotos: input.selectedPhotos.asDriver(onErrorJustReturn: [Data()]),
                      buttonEnable: buttonEnable.asDriver(onErrorJustReturn: false))
    }
}
