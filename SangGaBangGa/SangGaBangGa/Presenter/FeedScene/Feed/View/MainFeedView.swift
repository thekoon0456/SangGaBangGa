//
//  MainFeedView.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/26/24.
//

import UIKit

import RxCocoa
import RxSwift
import Kingfisher
import MarqueeLabel

final class MainFeedView: BaseView {
    
    let imageView = UIImageView().then {
        $0.layer.cornerRadius = 12
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
        $0.setImage(SSIcon.messageFill?
            .withConfiguration(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 17))), for: .selected)
        $0.tintColor = .tintColor
    }
    
    let commentCountLabel = UILabel().then {
        $0.font = SSFont.light11
    }
    
    let categoryLabel = PaddingLabel().then {
        $0.font =  SSFont.medium12
        $0.textColor = .accent
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.accent.cgColor
        $0.layer.cornerRadius = 4
        $0.clipsToBounds = true
        $0.padding = .init(top: 16, left: 8, bottom: 16, right: 8)
    }
    
    let titleLabel = MarqueeLabel().then {
        $0.font = SSFont.semiBold16
    }
    
    let priceLabel = UILabel().then {
        $0.font = SSFont.semiBold14
    }
    
    private let addressImageView = UIImageView().then {
        $0.image = .ssLocation.withTintColor(.systemGray)
        $0.contentMode = .scaleAspectFill
    }
    
    let addressLabel = UILabel().then {
        $0.font = SSFont.medium12
        $0.textColor = .systemGray
    }
    
    let dateLabel = UILabel().then {
        $0.font = SSFont.light11
        $0.textColor = .systemGray
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        addSubviews(imageView, heartButton, heartCountLabel,
                    commentButton, commentCountLabel,
                    categoryLabel, titleLabel, priceLabel,
                    addressImageView, addressLabel ,dateLabel)
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

extension MainFeedView {
    
    func configureCellData(_ data: ContentEntity) {
        imageView.kf.setSeSACImage(input: APIKey.baseURL + "/v1/" + (data.files.first ?? ""))
        categoryLabel.text = data.category
        titleLabel.text = data.title
        priceLabel.text = data.price
        heartCountLabel.text = String(data.likes.count)
        commentCountLabel.text = String(data.comments.count)
        addressLabel.text = data.address
        let formatter = DateFormatterManager.shared
        dateLabel.text =  formatter.iso8601DateToString(data.createdAt, format: .date)
        guard let userID = UserDefaultsManager.shared.userData.userID else { return }
        heartButton.isSelected = data.likes.contains(userID)
        commentButton.isSelected = data.comments.contains { $0.creator.userID == userID }
    }
    
    private func setLayout() {
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.height.equalTo(imageView.snp.width).multipliedBy(0.5)
        }
        
        heartButton.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.trailing.equalTo(commentButton.snp.leading).offset(-12)
            make.size.equalTo(30)
        }
        
        heartCountLabel.snp.makeConstraints { make in
            make.top.equalTo(heartButton.snp.bottom)
            make.centerX.equalTo(heartButton)
        }
        
        commentButton.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.trailing.equalToSuperview().offset(-12)
            make.size.equalTo(30)
        }
        
        commentCountLabel.snp.makeConstraints { make in
            make.top.equalTo(commentButton.snp.bottom)
            make.centerX.equalTo(commentButton)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(12)
            make.height.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalTo(heartButton.snp.leading)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
        }
        
        addressImageView.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(12)
            make.bottom.equalToSuperview()
            make.size.equalTo(16)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.centerY.equalTo(addressImageView)
            make.leading.equalTo(addressImageView.snp.trailing).offset(2)
            make.trailing.lessThanOrEqualTo(dateLabel.snp.leading).offset(-4)
            make.bottom.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(addressLabel)
            make.trailing.equalToSuperview().offset(-12)
        }
    }
}
