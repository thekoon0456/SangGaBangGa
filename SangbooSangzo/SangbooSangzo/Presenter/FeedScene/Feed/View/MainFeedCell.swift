//
//  MainFeedCell.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/26/24.
//

import UIKit

import RxCocoa
import RxSwift
import Kingfisher

final class MainFeedCell: RxBaseCollectionViewCell {
    
    // MARK: - Properties
    
    let view = MainFeedBaseView()
    
    private let viewModel = MainFeedCellViewModel()
    private let dataSubject = BehaviorSubject(value: ContentEntity.defaultsEntity)
    
    // MARK: - Lifecycles
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        view.heartButton.isSelected = false
        view.heartCountLabel.text = nil
        view.commentCountLabel.text = nil
        bind()
    }
    
    // MARK: - Helpers
    
    override func bind() {
        super.bind()
        
        let input = MainFeedCellViewModel.Input(inputData: dataSubject.asObservable(),
                                                heartButtonTapped: view.heartButton.rx.tap.map { [weak self] in
            guard let self else { return false }
            return view.heartButton.isSelected })
        let output = viewModel.transform(input)
        
        output
            .heartButtonStatus
            .drive(view.heartButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        output
            .heartCount
            .drive(view.heartCountLabel.rx.text)
            .disposed(by: disposeBag)
    }

    override func configureHierarchy() {
        super.configureHierarchy()
        contentView.addSubviews(view)
    }
    
    override func configureLayout() {
        super.configureLayout()
        setLayout()
    }
    
    override func configureView() {
        super.configureView()
    }
}

// MARK: - Configure

extension MainFeedCell {

    func configureCellData(_ data: ContentEntity) {
        view.configureCellData(data)
        dataSubject.onNext(data)
    }
    
    private func setLayout() {
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
