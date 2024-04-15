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
    
    private let viewModel: MapViewModel
    private let mapView = MKMapView()
    let locationManager = CLLocationManager()
    let defaultLocation = CLLocationCoordinate2D(latitude: 37.654536, longitude: 127.049893)
    var userLocation: CLLocationCoordinate2D?
    
    private lazy var currentLocationButton = UIButton().then {
        let image = UIImage(systemName: "mappin.and.ellipse.circle")
        $0.setImage(image, for: .normal)
        $0.addTarget(self, action: #selector(currentLocationButtonTapped), for: .touchUpInside)
        $0.tintColor = .black
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 25
        $0.clipsToBounds = true
    }
    
    @objc func currentLocationButtonTapped() {
        print(#function)
        print(userLocation)
        guard let userLocation else {
            print("안댐")
            return
        }
        let region = MKCoordinateRegion(center: userLocation,
                                        latitudinalMeters: 300,
                                        longitudinalMeters: 300)
        mapView.setRegion(region, animated: true)
    }
    
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addAnnotation()
        registerMapAnnotationViews()
        configureMap()
        configureLocation()
    }
    
    private func addAnnotation() {
        let annotation = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: 37,
                                                                             longitude: 127))
        annotation.imageName = "star"
        mapView.addAnnotation(annotation)
        
    }
    
    func registerMapAnnotationViews() {
        mapView.register(CustomAnnotationView.self,
                         forAnnotationViewWithReuseIdentifier:CustomAnnotationView.identifier)
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        view.addSubviews(mapView, currentLocationButton)
    }
    
    override func configureLayout() {
        super.configureLayout()
        mapView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        currentLocationButton.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
    
    override func configureView() {
        super.configureView()
        navigationItem.title = "지도"
    }
}

//extension MapViewController: MKMapViewDelegate {
//    
//    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
//        let lat = annotation.coordinate.latitude
//        let lon = annotation.coordinate.longitude
//        let location = CLLocation(latitude: lat, longitude: lon)
//        
//        locationManager.getPlacemark(location: location) { [weak self] locality, country in
//            guard let self else { return }
//            viewModel.coordinator?.showMapAlert(location: locality) {
//                UserDefaultsManager.shared.city = City(id: 0,
//                                                       name: locality,
//                                                       country: country,
//                                                       coord: CityCoord(lat: lat, lon: lon))
//                LocationManager.shared.updateCity()
//            }
//        }
//    }
//}

extension MapViewController: MKMapViewDelegate {
    //시점 이동
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? MKPointAnnotation else { return }
        
        let region = MKCoordinateRegion(center: annotation.coordinate,
                                        latitudinalMeters: 5000,
                                        longitudinalMeters: 5000)
        mapView.setRegion(region, animated: true)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    //맵 구성
    func configureMap() {
        mapView.delegate = self
        
        let coordinate2 = CLLocationCoordinate2D(latitude: 37,
                                                 longitude: 127)
        
        //meters: 중심지로부터 거리
        let region = MKCoordinateRegion(center: coordinate2,
                                        latitudinalMeters: 1000,
                                        longitudinalMeters: 1000)
        
        mapView.setRegion(region, animated: true)
        
//        theaterData.forEach { theater in
//            let coordinate = CLLocationCoordinate2D(latitude: theater.latitude, longitude: theater.longitude)
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = coordinate
//            annotation.title = theater.location
//            
//            mapView.addAnnotation(annotation)
//        }
    }
    
    //맵 annotaion 리셋
    func resetMapAnnotation() {
        mapView.removeAnnotations(mapView.annotations)
    }
}


extension MapViewController {
    
    func configureLocation() {
        //delegate 연결
        locationManager.delegate = self
        //사용자 권한 확인
        self.checkDeviceLocationAuthorization()
    }
    
    func checkDeviceLocationAuthorization() {
        //첫 진입시 권한 띄워주거나, 동의 하면 위치 가져오기
        //사용자 아이폰의 위치 서비스가 켜져있는 경우
        //사용자 권한 확인, 글로벌 스레드에서 동작
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                let authorization: CLAuthorizationStatus = self.locationManager.authorizationStatus
                
                DispatchQueue.main.async {
                    self.checkCurrentLocationAuthorization(status: authorization)
                }
            } else {
                //사용자의 아이폰의 위치 서비스가 꺼져있는 경우. alert으로 띄워주기
                DispatchQueue.main.async {
                    self.showLocationSettingAlert(title: "위치 서비스 확인",
                                                  message: "아이폰의 위치 서비스가 꺼져 있어서 위치 권한을 요청할 수 없어요\n기기의 설정 -> 개인 정보 보호에서 위치 서비스를 켜주세요")
                }
            }
        }
    }
    
    func checkCurrentLocationAuthorization(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            //어느 정도 위치 정확도를 가질지 설정
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization() //plist의 권한 요청 문구 띄움
        case .denied:
            //위치권한이 거부된 경우. 설정창으로 이동 alert띄우기
            showLocationSettingAlert(title: "위치 정보 이용",
                                     message: "위치서비스를 사용할 수 없습니다\n기기의 설정 -> 개인정보 보호 및 보안에서 위치 서비스를 켜주세요")
        case .authorizedWhenInUse:
            //사용자가 동의한 경우, 위치 업데이트 시작. didUpdateLocation 메서드 실행
            locationManager.startUpdatingLocation()
        default:
            //사용자의 아이폰의 위치 서비스가 꺼져있는 경우. alert으로 띄워주기
            showLocationSettingAlert(title: "위치 서비스 확인",
                                     message: "아이폰의 위치 서비스가 꺼져 있어서 위치 권한을 요청할 수 없어요\n기기의 설정 -> 개인정보 보호 및 보안에서 위치 서비스를 켜주세요")
        }
    }
    
    func showLocationSettingAlert(title: String, message: String) {
        showAlert(title: title,
                  message: message) {
            //아이폰 설정창으로 이동
            guard let settingURL = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(settingURL)
        }
    }
    
    func setRegionAndAnnotation() {
        guard let userLocation else {
            let region = MKCoordinateRegion(center: defaultLocation,
                                            latitudinalMeters: 300,
                                            longitudinalMeters: 300)
            mapView.setRegion(region, animated: true)
            setAnnotation(coordinate: defaultLocation)
            return
        }
        
        let region = MKCoordinateRegion(center: userLocation,
                                        latitudinalMeters: 300,
                                        longitudinalMeters: 300)
        mapView.setRegion(region, animated: true)
        setAnnotation(coordinate: userLocation)
    }
    
    //맵뷰 annotation추가
    func setAnnotation(coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "현재 위치"
        
        mapView.addAnnotation(annotation)
    }
    
}

extension MapViewController {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        
        if let coordinate = locations.last?.coordinate {
//            userLocation?.latitude = coordinate.latitude
//            userLocation?.longitude = coordinate.longitude
            userLocation = CLLocationCoordinate2D(latitude: coordinate.latitude,
                                                  longitude: coordinate.longitude)
        }
        setRegionAndAnnotation()
    }
    
    //위치정보 가져오지 못했을 경우. alert이나 default 위치 띄우기
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showLocationSettingAlert(title: "위치 정보 이용",
                                 message: "위치서비스를 사용할 수 없습니다\n기기의 설정 -> 개인정보 보호 및 보안에서 위치 서비스를 켜주세요")
        
        let region = MKCoordinateRegion(center: defaultLocation,
                                        latitudinalMeters: 300,
                                        longitudinalMeters: 300)
        mapView.setRegion(region, animated: true)
    }
    
    //사용자 권한 상태가 바뀌었을때
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkDeviceLocationAuthorization()
    }
    
}

// MARK: - Alert

extension UIViewController {
    
    func showAlert(title: String, message: String, action: @escaping () -> Void) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.view.tintColor = .tintColor
        
        let defaultButton = UIAlertAction(title: "확인", style: .default) { _ in
            action()
        }
        
        let cancleButton = UIAlertAction(title: "취소", style: .destructive)
        
        alert.addAction(cancleButton)
        alert.addAction(defaultButton)
        
        present(alert, animated: true)
    }
}

