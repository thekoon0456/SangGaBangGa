//
//  MapDetailViewController.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/26/24.
//

import UIKit

import RxCocoa
import RxSwift
import Kingfisher

final class MapDetailViewController: RxBaseViewController {
    
    private let viewModel: MapDetailViewModel
    private let cellTapped = PublishRelay<Void>()
    
    private lazy var baseView = MainFeedBaseView().then {
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(baseViewTapped)))
    }
    
    private let titleLabel = UILabel().then {
        $0.font = SSFont.titleMedium
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
        
        let input = MapDetailViewModel.Input(viewWillAppear: self.rx.viewWillAppear.map { _ in },
                                             cellTapped: cellTapped.asObservable(),
                                             heartButtonTapped: heartButtonTapped)
        let output = viewModel.transform(input)
        
        output.data.drive(with: self) { owner, data in
            owner.titleLabel.text = data.title
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
    
    @objc private func baseViewTapped() {
        cellTapped.accept(())
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        view.addSubviews(baseView, titleLabel)
        
    }
    
    override func configureLayout() {
        super.configureLayout()
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
        }
        
        baseView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-12).priority(.low)
        }
    }
    
    override func configureView() {
        super.configureView()
    }
}
