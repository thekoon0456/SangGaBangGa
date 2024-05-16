//
//  MapViewModel.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/15/24.
//

import Foundation
import MapKit

import RxCocoa
import RxSwift

final class MapViewModel: ViewModel {
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let searchRegion: Observable<String>
        let currentButtonTapped: ControlEvent<Void>
        let selectCell: Driver<ContentEntity>
    }
    
    struct Output {
        let feeds: Driver<[ContentEntity]>
        let moveToRegion: Driver<MKCoordinateRegion>
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
        
        let regionRelay = BehaviorRelay<MKCoordinateRegion>(value: .init())
        
        input
            .searchRegion
            .withUnretained(self)
            .flatMap { owner, value in
                owner.searchAndMoveToLocation(address: value)
                    .catch { error in
                        DispatchQueue.main.async {
                            owner.coordinator?.showToast(.wrongAddress)
                        }
                        return Observable.never()
                    }
            }
            .subscribe { value in
                regionRelay.accept(value)
            }
            .disposed(by: disposeBag)
            
        
        input
            .currentButtonTapped
            .flatMap { _ in
                SSLocationManager.shared.mapRegionRelay
            }
            .subscribe { value in
                regionRelay.accept(value)
            }
            .disposed(by: disposeBag)
        
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
                                            productID: APISetting.productID,
                                            hashTag: ""))
            }
            .compactMap { $0.data }
            .debug()
            .asDriver(onErrorJustReturn: [])
        
        return Output(feeds: feeds,
                      moveToRegion: regionRelay.asDriver())
    }
}

extension MapViewModel {
    
    func searchAndMoveToLocation(address: String) -> Observable<MKCoordinateRegion> {
        print(#function)
        return Observable.create { observer in
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(address) { placemarks, error in
                
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                if let placemarks = placemarks,
                   let location = placemarks.first?.location {
                    print(placemarks)
                    print(location)
                    
                    let region = MKCoordinateRegion(center: location.coordinate,
                                                    latitudinalMeters: SSMapConst.latitudinalMeters,
                                                    longitudinalMeters: SSMapConst.longitudinalMeters)
                    observer.onNext(region)
                    observer.onCompleted()
                }
            }
            
            return Disposables.create()
        }
    }
}
