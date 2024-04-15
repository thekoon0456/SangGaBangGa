//
//  MapViewController.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/15/24.
//

import MapKit
import UIKit

import RxCocoa
import RxSwift

final class MapViewController: RxBaseViewController {
    
    private let viewModel: MapViewModel
    private let mapView = MKMapView()
    
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        view.addSubviews(mapView)
    }
    
    override func configureLayout() {
        super.configureLayout()
        mapView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        super.configureView()
        navigationItem.title = "지도"
    }
}
