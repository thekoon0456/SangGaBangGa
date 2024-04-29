//
//  PoseViewModel.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/16/24.
//

import CoreLocation
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
        let spaceM2: ControlProperty<String>
        let content: ControlProperty<String>
        let post: ControlEvent<Void>
    }
    
    struct Output {
        let selectedPhotos: Driver<[Data]>
        let space: Driver<String>
        let spaceM2: Driver<String>
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
        
        let space = BehaviorRelay(value: "")
        let spaceM2 = BehaviorRelay(value: "")
        
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
        
        input
            .address
            .withUnretained(self)
            .flatMap { owner, value in
                owner.convertAddressToCoordinates(address: value)
                    .catchAndReturn("")
            }
            .subscribe { value in
                request.content3 = value
            }
            .disposed(by: disposeBag)
        
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
                space.accept(value)
                to33Space(value)
            }
            .disposed(by: disposeBag)
        
        input
            .spaceM2
            .subscribe { value in
                spaceM2.accept(value)
                toSpace(value)
            }
            .disposed(by: disposeBag)

        input
            .post
            .flatMap {
                input .selectedPhotos
            }
            .withUnretained(self)
            .flatMap { owner, data in
                owner
                    .postAPIManager
                    .uploadImages(query: .init(datas: data))
            }
            .withUnretained(self)
            .flatMap { owner, response in
                owner
                    .postAPIManager
                    .uploadContents(images: response.files, query: request)
            }
            .catch { [weak self] error in
                guard let self else { return Observable.just(UploadContentResponse()) }
                coordinator?.showToast(.uploadFail)
                return Observable.just(UploadContentResponse())
            }
            .subscribe(with: self) { owner, value in
                owner.coordinator?.showToast(.uploadSuccess) {
                    owner.coordinator?.popViewController()
                }
            }
            .disposed(by: disposeBag)
        
        func toSpace(_ input: String) {
            if input == "0" || input == "" {
                space.accept("")
            }
            if let spaceDouble = Double(input){
                let newValue = String(Int(spaceDouble / 3.3))
                space.accept(newValue)
            }
        }
        
        func to33Space(_ input: String) {
            if input == "0" || input == "" {
                spaceM2.accept("")
            }
            if let spaceDouble = Double(input) {
                let newValue = String(spaceDouble * 3.3)
                spaceM2.accept(newValue)
            }
        }
        
        return Output(selectedPhotos: input.selectedPhotos.asDriver(onErrorJustReturn: []),
                      space: space.asDriver(onErrorJustReturn: ""),
                      spaceM2: spaceM2.asDriver(onErrorJustReturn: ""),
                      buttonEnable: buttonEnable.asDriver(onErrorJustReturn: false))
    }
}

extension PostViewModel {
    //위도 / 경도
    func convertAddressToCoordinates(address: String) -> Observable<String> {
        print(#function)
        return Observable.create { observer in
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(address) { (placemarks, error) in
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                if let placemark = placemarks?.first, let location = placemark.location {
                    observer.onNext("\(location.coordinate.latitude) / \(location.coordinate.longitude)")
                    observer.onCompleted()
                } else {
                    observer.onError(NSError(domain: "LocationError",
                                             code: 0,
                                             userInfo: [NSLocalizedDescriptionKey: "No valid coordinates found"]))
                }
            }
            
            return Disposables.create()
        }
    }
}
