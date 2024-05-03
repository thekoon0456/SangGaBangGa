//
//  LocationManager.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 5/3/24.
//

import CoreLocation
import Foundation
import MapKit

import RxCocoa
import RxSwift

enum LocationAlert {
    case none
    case deviceLocationOff
    
    var alert: (title: String, message: String)? {
        switch self {
        case .none:
            return nil
        case .deviceLocationOff:
            return (title: "위치 서비스 확인",
                    message: "위치서비스를 사용할 수 없습니다\n기기의 설정 -> 개인정보 보호 및 보안에서 위치 서비스를 켜주세요")
        }
    }
}

final class SSLocationManager: NSObject {
    
    static let shared = SSLocationManager()
    
    private override init() {
        super.init()
//        configureLocation()
    }
    
    private let locationManager = CLLocationManager()
    private let latitudinalMeters: Double = 1000
    private let longitudinalMeters: Double = 1000
    private var updateLocation = true
    let authorizationStateRelay = BehaviorRelay<CLAuthorizationStatus>(value: .authorizedWhenInUse)
    let userLocationRelay = BehaviorRelay<CLLocationCoordinate2D>(value: CLLocationCoordinate2D(latitude: 37.654536, longitude: 127.049893))
    lazy var mapRegionRelay = BehaviorRelay(value: MKCoordinateRegion(center: userLocationRelay.value,
                                                                   latitudinalMeters: latitudinalMeters,
                                                                   longitudinalMeters: longitudinalMeters))
    let locationAlertRelay = BehaviorRelay<LocationAlert>(value: .none)
    
    func configureLocation() {
        locationManager.delegate = self
        checkDeviceLocationAuthorization()
    }
    
    func checkDeviceLocationAuthorization() {
        //첫 진입시 권한 띄워주거나, 동의 하면 위치 가져오기
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            if CLLocationManager.locationServicesEnabled() {
                let authorization: CLAuthorizationStatus = self.locationManager.authorizationStatus

                DispatchQueue.main.async {
                    self.checkCurrentLocationAuthorization(status: authorization)
                }
            } else {
                //사용자의 아이폰의 위치 서비스가 꺼져있는 경우. alert으로 띄워주기
                locationAlertRelay.accept(.deviceLocationOff)
            }
        }
    }
    
    func checkCurrentLocationAuthorization(status: CLAuthorizationStatus) {
        authorizationStateRelay.accept(status)
        switch status {
        case .notDetermined:
            //어느 정도 위치 정확도를 가질지 설정
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.requestWhenInUseAuthorization() //plist의 권한 요청 문구 띄움
            locationAlertRelay.accept(.none)
        case .denied:
            //위치권한이 거부된 경우. 설정창으로 이동 alert띄우기
            locationAlertRelay.accept(.deviceLocationOff)
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            locationAlertRelay.accept(.none)
        default:
            locationAlertRelay.accept(.deviceLocationOff)
        }
    }
}

extension SSLocationManager: CLLocationManagerDelegate {
    
    //위치 한번만 업데이트
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        guard updateLocation else { return }
        updateLocation = false
        if let coordinate = locations.last?.coordinate {
            let location = CLLocationCoordinate2D(latitude: coordinate.latitude,
                                                  longitude: coordinate.longitude)
            userLocationRelay.accept(location)
        }
    }
    
    //위치정보 가져오지 못했을 경우. alert
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let region = MKCoordinateRegion(center: userLocationRelay.value,
                                        latitudinalMeters: latitudinalMeters,
                                        longitudinalMeters: longitudinalMeters)
        mapRegionRelay.accept(region)
        locationAlertRelay.accept(.deviceLocationOff)
    }
    
    //사용자 권한 상태가 바뀌었을때
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkDeviceLocationAuthorization()
    }
}
