//
//  MapDetailViewController.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/26/24.
//

import UIKit

import RxCocoa
import RxGesture
import RxSwift
import Kingfisher

final class MapDetailViewController: RxBaseViewController {
    
    private let viewModel: MapDetailViewModel
    
    private lazy var baseView = MainFeedBaseView().then {
        $0.isUserInteractionEnabled = true
    }
    
    init(viewModel: MapDetailViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func bind() {
        super.bind()
        
        let heartButtonTapped = baseView.heartButton.rx.tap.map { [weak self] in
            guard let self else { return false }
            return baseView.heartButton.isSelected
        }
        
        let baseViewTapped = baseView.rx.tapGesture().when(.recognized).map { _ in }
        
        let input = MapDetailViewModel.Input(viewWillAppear: self.rx.viewWillAppear.map { _ in },
                                             cellTapped: baseViewTapped,
                                             heartButtonTapped: heartButtonTapped)
        let output = viewModel.transform(input)
        
        output.data.drive(with: self) { owner, data in
            owner.baseView.configureCellData(data)
        }
        .disposed(by: disposeBag)
        
        output
            .heartButtonStatus
            .drive(baseView.heartButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        output
            .heartCount
            .drive(baseView.heartCountLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        view.addSubviews(baseView)
        
    }
    
    override func configureLayout() {
        super.configureLayout()
        baseView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-12).priority(.low)
        }
    }
    
    override func configureView() {
        super.configureView()
    }
}
