//
//  MapViewController.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/15/24.
//

import CoreLocation
import MapKit
import UIKit

import RxCocoa
import RxSwift

final class MapViewController: RxBaseViewController {
    
    // MARK: - Properties
    
    private let viewModel: MapViewModel
    
    private let titleView = TitleView().then {
        $0.configureView(title: "지도")
    }
    
    private let mapView = MKMapView().then {
        $0.register(SSAnnotationView.self,
                    forAnnotationViewWithReuseIdentifier:SSAnnotationView.identifier)
    }
    
    private let locationManager = SSLocationManager.shared
    private let dataRelay = PublishRelay<ContentEntity>()
    
    private let searchBar = UISearchBar().then {
        $0.searchBarStyle = .minimal
        $0.backgroundColor = .clear
        $0.searchTextField.backgroundColor = .white
        $0.layer.shadowOffset = CGSize(width: 4, height: 4)
        $0.layer.shadowColor = UIColor.systemGray.cgColor
        $0.layer.shadowOpacity = 0.8
        $0.layer.shadowRadius = 16
    }
    
    private lazy var currentLocationButton = UIButton().then {
        let image = UIImage.ssLocation.withTintColor(.accent)
        $0.setImage(image, for: .normal)
        $0.backgroundColor = .second
        $0.layer.cornerRadius = 25
        $0.clipsToBounds = true
    }
    
    private var markerView = CustomMarkerView()
    
    // MARK: - Lifecycles
    
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMap()
        locationManager.configureLocation()
    }
    
    override func bind() {
        super.bind()
        let input = MapViewModel.Input(viewWillAppear: self.rx.viewWillAppear.map { _ in },
                                       searchRegion: searchBar.rx.searchButtonClicked.withLatestFrom(searchBar.rx.text.orEmpty),
                                       currentButtonTapped: currentLocationButton.rx.tap,
                                       selectCell: dataRelay.asDriver(onErrorJustReturn: ContentEntity.defaultData()))
        let output = viewModel.transform(input)
        
        output
            .feeds
            .drive(with: self) { owner, value in
                value.forEach { data in
                    owner.setSSAnnotation(data: data)
                }
            }
            .disposed(by: disposeBag)
        
        output
            .moveToRegion
            .drive(with: self) { owner, value in
                let coordinator = CLLocationCoordinate2D(latitude: value.center.latitude,
                                                         longitude: value.center.longitude)
                owner.setAnnotation(coordinate: coordinator)
                owner.mapView.setRegion(value, animated: true)
            }
            .disposed(by: disposeBag)
        
        locationManager
            .userLocationRelay
            .asDriver()
            .drive(with: self) { owner, location in
                owner.setCurrentRegionAndAnnotation()
            }
            .disposed(by: disposeBag)
        
        locationManager
            .mapRegionRelay
            .asDriver()
            .drive(with: self) { owner, region in
                owner.mapView.setRegion(region, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        view.addSubviews(mapView, currentLocationButton, searchBar)
    }
    
    override func configureLayout() {
        super.configureLayout()
        mapView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        currentLocationButton.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
    
    override func configureView() {
        super.configureView()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleView)
    }
}

// MARK: - MapView

extension MapViewController {
    
    func configureMap() {
        mapView.delegate = self
    }

    func setAnnotation(coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "현재 위치"
        
        mapView.addAnnotation(annotation)
    }
    
    func setSSAnnotation(data: ContentEntity) {
        guard let site = data.coordinate,
              let latitude = Double(site.components(separatedBy: " / ").first ?? ""),
              let longitude = Double(site.components(separatedBy: " / ").last ?? "")
        else { return }
        
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let annotation = SSAnnotation(coordinate: coordinate,
                                      data: data)
        mapView.addAnnotation(annotation)
    }
    
    func setCurrentRegionAndAnnotation() {
        mapView.setRegion(locationManager.mapRegionRelay.value, animated: true)
    }
    
    func resetMapAnnotation() {
        mapView.removeAnnotations(mapView.annotations)
    }
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? SSAnnotation else { return }
        dataRelay.accept(annotation.data)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        print(#function)
        
        if let annotation = annotation as? MKPointAnnotation {
            if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: CustomMarkerView.identifier) as? CustomMarkerView {
                annotationView.annotation = annotation
                annotationView.markerTintColor = .accent
                markerView = annotationView
                return markerView
            } else {
                let markerView = CustomMarkerView(annotation: annotation)
                return markerView
            }
        }
        
        if let customAnnotation = annotation as? SSAnnotation,
           let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: SSAnnotationView.identifier) {
            annotationView.annotation = customAnnotation
            annotationView.frame = .init(x: 0, y: 0, width: 70, height: 120)
            return annotationView
        }
           
        return nil
    }
}
