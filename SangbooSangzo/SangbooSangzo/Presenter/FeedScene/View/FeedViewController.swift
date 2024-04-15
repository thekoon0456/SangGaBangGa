//
//  FeedViewController.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/15/24.
//

import UIKit

import RxCocoa
import RxSwift

final class FeedViewController: RxBaseViewController {
    
    private let viewModel: FeedViewModel
    
    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
}
