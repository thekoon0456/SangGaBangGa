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
        let image = UIImage(systemName: "mappin.and.ellipse.circle")
        $0.setImage(image, for: .normal)
        $0.addTarget(self, action: #selector(currentLocationButtonTapped), for: .touchUpInside)
        $0.tintColor = .black
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 25
        $0.clipsToBounds = true
    }

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "지도"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.title = ""
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func bind() {
        super.bind()
        let input = MapViewModel.Input(viewWillAppear: self.rx.viewWillAppear.map { _ in },
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
    
    @objc func currentLocationButtonTapped() {
        mapView.setRegion(locationManager.mapRegionRelay.value, animated: true)
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
    }
}

// MARK: - MapView

extension MapViewController {
    
    func configureMap() {
        mapView.delegate = self
    }
    
    //맵 annotaion 리셋
    func resetMapAnnotation() {
        mapView.removeAnnotations(mapView.annotations)
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
        setAnnotation(coordinate: locationManager.userLocationRelay.value)
    }
    
    func setAnnotation(coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "현재 위치"
        
        mapView.addAnnotation(annotation)
    }
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print(#function)
        guard let annotation = view.annotation as? SSAnnotation else { return }
        dataRelay.accept(annotation.data)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        print(#function)
        guard let customAnnotation = annotation as? SSAnnotation,
              let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: SSAnnotationView.identifier)
        else {
            return nil
        }
        
        annotationView.annotation = customAnnotation
        annotationView.frame = .init(x: 0, y: 0, width: 70, height: 100)
        
        return annotationView
    }
}

extension MapViewController {
    
    
}
