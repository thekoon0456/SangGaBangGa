//
//  InfoViewController.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/15/24.
//

import UIKit

final class InfoViewController: RxBaseViewController {
    
    private let viewModel: InfoViewModel
    
    init(viewModel: InfoViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
    }
    
    override func configureLayout() {
        super.configureLayout()
        
    }
    
    override func configureView() {
        super.configureView()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "마이페이지"
    }
}
