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
import MarqueeLabel

final class FeedCell: RxBaseCollectionViewCell {
    
    // MARK: - Properties
    
    private let likeRepository = LikeRepositoryImpl()
    private lazy var viewModel = FeedCellViewModel(likeRepository: likeRepository)
    private let dataSubject = BehaviorSubject(value: ContentEntity.defaultData())
    
    private let imageView = UIImageView().then {
        $0.layer.cornerRadius = 5
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    
    let heartButton = UIButton().then {
        $0.setImage(SSIcon.heart?
            .withConfiguration(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 18))), for: .normal)
        $0.setImage(SSIcon.heartFill?
            .withConfiguration(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 18))), for: .selected)
        $0.tintColor = .tintColor
    }
    
    let heartCountLabel = UILabel().then {
        $0.font = SSFont.light11
    }
    
    let commentButton = UIButton().then {
        $0.setImage(SSIcon.message?
            .withConfiguration(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 17))), for: .normal)
        $0.tintColor = .tintColor
    }
    
    let commentCountLabel = UILabel().then {
        $0.font = SSFont.light11
    }
    
    let categoryLabel = PaddingLabel().then {
        $0.font =  SSFont.medium12
        $0.textColor = .white
        $0.backgroundColor = .tintColor
        $0.layer.cornerRadius = 4
        $0.clipsToBounds = true
        $0.padding = .init(top: 16, left: 8, bottom: 16, right: 8)
    }
    
    let titleLabel = MarqueeLabel().then {
        $0.font = SSFont.semiBold16
        $0.numberOfLines = 1
    }
    
    let priceLabel = UILabel().then {
        $0.font = SSFont.semiBold14
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
            make.top.equalTo(imageView.snp.bottom)
            make.trailing.equalTo(commentButton.snp.leading).offset(-12)
            make.size.equalTo(30)
        }
        
        heartCountLabel.snp.makeConstraints { make in
            make.top.equalTo(heartButton.snp.bottom)
            make.centerX.equalTo(heartButton)
        }
        
        commentButton.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.trailing.equalToSuperview().offset(-4)
            make.size.equalTo(30)
        }
        
        commentCountLabel.snp.makeConstraints { make in
            make.top.equalTo(commentButton.snp.bottom)
            make.centerX.equalTo(commentButton)
            make.centerY.equalTo(heartCountLabel)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(4)
            make.height.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(heartCountLabel.snp.bottom)
            make.leading.equalToSuperview().offset(4)
            make.trailing.equalToSuperview().offset(-4)
            make.height.equalTo(24)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(4)
            make.trailing.equalToSuperview().offset(-4)
            make.bottom.lessThanOrEqualToSuperview().offset(-4)
            make.height.equalTo(24)
        }
    }
}
