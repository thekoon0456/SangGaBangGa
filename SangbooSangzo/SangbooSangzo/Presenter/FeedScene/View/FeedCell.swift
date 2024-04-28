//
//  FeedCell.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/16/24.
//

import UIKit

import RxCocoa
import RxSwift
import Kingfisher

final class FeedCell: RxBaseCollectionViewCell {
    
    // MARK: - Properties
    
    private let viewModel = FeedCellViewModel()
    private let dataSubject = BehaviorSubject(value: ContentEntity.defaultsEntity)
    
    private let imageView = UIImageView().then {
        $0.layer.cornerRadius = 5
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    
    let heartButton = UIButton().then {
        $0.setImage(UIImage(systemName: "heart")?.withConfiguration(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 20))), for: .normal)
        $0.setImage(UIImage(systemName: "heart.fill")?.withConfiguration(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 20))), for: .selected)
        $0.tintColor = .tintColor
    }
    
    private let heartCountLabel = UILabel().then {
        $0.font = SSFont.titleSmall
        $0.textAlignment = .left
    }
    
    let commentButton = UIButton().then {
        $0.setImage(UIImage(systemName: "message")?.withConfiguration(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 20))), for: .normal)
        $0.backgroundColor = .white
        $0.tintColor = .tintColor
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
    }
    
    private let commentCountLabel = UILabel().then {
        $0.font = SSFont.titleSmall
        $0.textAlignment = .left
    }
    
    private let categoryLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 13)
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.numberOfLines = 2
    }
    
    private let priceLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .bold)
    }
    
    // MARK: - Lifecycles
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        heartButton.isSelected = false
        heartCountLabel.text = nil
        commentCountLabel.text = nil
        bind()
    }
    
    // MARK: - Helpers
    
    override func bind() {
        super.bind()
        
        let input = FeedCellViewModel.Input(inputData: dataSubject.asObservable(),
                                            heartButtonTapped: heartButton.rx.tap.map { [weak self] in
            guard let self else { return false }
            return heartButton.isSelected })
        let output = viewModel.transform(input)
        
        output
            .heartButtonStatus
            .drive(heartButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        output
            .heartCount
            .drive(heartCountLabel.rx.text)
            .disposed(by: disposeBag)
    }

    override func configureHierarchy() {
        super.configureHierarchy()
        contentView.addSubviews(imageView, heartButton, heartCountLabel,
                                commentButton, commentCountLabel,
                                categoryLabel, titleLabel, priceLabel)
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

extension FeedCell {

    func configureCellData(_ data: ContentEntity) {
        imageView.kf.setSeSACImage(input: APIKey.baseURL + "/v1/" + (data.files.first ?? ""))
        categoryLabel.text = data.category
        titleLabel.text = data.title
        priceLabel.text = data.price
        commentCountLabel.text = String(data.comments.count)
        dataSubject.onNext(data)
    }
    
    private func setLayout() {
        imageView.snp.makeConstraints { make in
            make.top.width.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
        }
        
        heartButton.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(4)
            make.size.equalTo(30)
        }
        
        heartCountLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.leading.equalTo(heartButton.snp.trailing).offset(2)
            make.height.equalTo(30)
        }
        
        commentButton.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.leading.equalTo(heartCountLabel.snp.trailing).offset(12)
            make.size.equalTo(30)
        }
        
        commentCountLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.leading.equalTo(commentButton.snp.trailing).offset(2)
            make.height.equalTo(30)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(heartButton.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview().offset(-4)
        }
    }
}
