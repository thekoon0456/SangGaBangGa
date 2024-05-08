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
    
    let view = MainFeedView()
    var heartButtonTapped: (() -> Void)?
    var commentButtonTapped: (() -> Void)?
    
    // MARK: - Lifecycles
    
    override func prepareForReuse() {
        super.prepareForReuse()
        heartButtonTapped = nil
        commentButtonTapped = nil
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
    }
    
    private func setLayout() {
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
