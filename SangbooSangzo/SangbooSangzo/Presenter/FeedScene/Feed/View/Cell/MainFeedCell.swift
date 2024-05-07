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
    //    private let likeRepository = LikeRepositoryImpl()
    //    private lazy var viewModel = MainFeedCellViewModel(likeRepository: likeRepository)
    //    private let dataSubject = BehaviorSubject(value: ContentEntity.defaultData())
    
    var heartButtonTapped: (() -> Void)?
    var commentButtonTapped: (() -> Void)?
    
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
        
        view.heartButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.view.heartButton.isSelected.toggle()
                owner.heartButtonTapped?()
            }
            .disposed(by: disposeBag)
        
        view.commentButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.commentButtonTapped?()
            }
            .disposed(by: disposeBag)
        //
        //        let heartButtonTapped = view.heartButton.rx.tap
        //            .map { [weak self] in
        //            guard let self else { return false }
        //            return view.heartButton.isSelected
        //        }
        //
        //        let input = MainFeedCellViewModel.Input(inputData: dataSubject.asObservable(),
        //                                                heartButtonTapped: heartButtonTapped,
        //                                                commentButtonTapped: view.commentButton.rx.tap)
        //        let output = viewModel.transform(input)
        //
        //        output
        //            .heartButtonStatus
        //            .drive(view.heartButton.rx.isSelected)
        //            .disposed(by: disposeBag)
        //
        //        output
        //            .heartCount
        //            .drive(view.heartCountLabel.rx.text)
        //            .disposed(by: disposeBag)
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
        //        dataSubject.onNext(data)
    }
    
    private func setLayout() {
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
