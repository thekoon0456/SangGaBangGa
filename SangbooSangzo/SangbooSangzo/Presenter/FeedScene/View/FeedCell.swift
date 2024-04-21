//
//  FeedCell.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/16/24.
//

import UIKit

import Kingfisher

final class FeedCell: BaseCollectionViewCell {
    
    // MARK: - Properties
    
    private let imageView = UIImageView().then {
        $0.layer.cornerRadius = 5
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    
    let heartButton = UIButton().then {
        $0.setImage(UIImage(systemName: "heart")?.withConfiguration(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 20))), for: .normal)
        $0.setImage(UIImage(systemName: "heart.fill")?.withConfiguration(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 20))), for: .selected)
        $0.backgroundColor = .white
        $0.tintColor = .tintColor
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
    }
    
    let commentButton = UIButton().then {
        $0.setImage(UIImage(systemName: "message")?.withConfiguration(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 20))), for: .normal)
        $0.backgroundColor = .white
        $0.tintColor = .tintColor
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
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
    
    // MARK: - Helpers
    
    func isSelectedButton(input: String) -> Bool {
//        guard let user = UserManager.shared.currentUserValue else { return false }
//        return user.likes.contains(input) ? true : false
        return false
    }

    override func configureHierarchy() {
        super.configureHierarchy()
        contentView.addSubviews(imageView, heartButton, commentButton, categoryLabel, titleLabel, priceLabel)
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

    func configureCellData(_ data: UploadContentResponse) {
        imageView.kf.setSeSACImage(input: APIKey.baseURL + "/v1/" + (data.files?.first ?? ""))
        
        categoryLabel.text = data.content1
        titleLabel.text = data.title
        priceLabel.text = data.content4
    }
    
    private func setLayout() {
        imageView.snp.makeConstraints { make in
            make.top.width.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
        }
        
        heartButton.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(8)
            make.size.equalTo(30)
        }
        
        commentButton.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.leading.equalTo(heartButton.snp.trailing).offset(8)
            make.size.equalTo(30)
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
