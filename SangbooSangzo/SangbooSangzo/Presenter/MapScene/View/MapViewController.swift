//
//  MapViewController.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/15/24.
//

import UIKit

import RxCocoa
import RxSwift

final class MapViewController: RxBaseViewController {
    
    private let viewModel: MapViewModel
    
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
}
