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
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFit
    }
    
    let heartButton = UIButton().then {
        $0.setImage(UIImage(systemName: "heart"), for: .normal)
        $0.setImage(UIImage(systemName: "heart.fill"), for: .selected)
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
    
    func setKF(input: String) {
//        let processor = RoundCornerImageProcessor(cornerRadius: 20)
        imageView.kf.indicatorType = .activity
//        imageView.kf.setImage(with: URL(string: input),
//                              options: [.transition(.fade(1.0)),
//                                        .processor(processor)])
        
        let url = URL(string: input)
        
        let modifier = AnyModifier { request in
            var request = request
            request.setValue(UserDefaultsManager.shared.userToken.accessToken ?? "", forHTTPHeaderField: HTTPHeader.authorization)
            request.setValue(APIKey.sesacKey, forHTTPHeaderField: HTTPHeader.sesacKey)
            return request
        }

        let options: KingfisherOptionsInfo = [
            .requestModifier(modifier)
        ]

        imageView.kf.setImage(with: url, options: options)
    }
    
    func isSelectedButton(input: String) -> Bool {
//        guard let user = UserManager.shared.currentUserValue else { return false }
//        return user.likes.contains(input) ? true : false
        return false
    }

    override func configureHierarchy() {
        super.configureHierarchy()
        contentView.addSubviews(imageView, heartButton, categoryLabel, titleLabel, priceLabel)
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
        setKF(input: APIKey.baseURL + "/v1/" + (data.files?.first ?? ""))
//        heartButton.isSelected = isSelectedButton(input: data.id)
        categoryLabel.text = data.content1
        titleLabel.text = data.title
        priceLabel.text = data.content4
    }
    
    private func setLayout() {
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.lessThanOrEqualTo(300)
        }
        
        heartButton.snp.makeConstraints { make in
            make.trailing.equalTo(imageView.snp.trailing).offset(-10)
            make.bottom.equalTo(imageView.snp.bottom).offset(-10)
            make.size.equalTo(30)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(4)
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
