//
//  DetailFeedView.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/27/24.
//

import MapKit
import UIKit

import Kingfisher
import SnapKit

final class DetailFeedView: BaseView {
    
    var heightConstraint: Constraint?
    
    // MARK: - UI
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    let profileView = UserProfileView()
    
    lazy var imageScrollView = ImageScrollView()
    
    let heartButton = UIButton().then {
        $0.setImage(UIImage(systemName: "heart")?.withConfiguration(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 26))),
                    for: .normal)
        $0.setImage(UIImage(systemName: "heart.fill")?.withConfiguration(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 26))),
                    for: .selected)
        $0.tintColor = .tintColor
        $0.contentVerticalAlignment = .center
        $0.contentHorizontalAlignment = .center
    }
    
    let heartCountLabel = UILabel().then {
        $0.font = SSFont.semiBold14
        $0.textAlignment = .left
    }
    
    let commentButton = UIButton().then {
        $0.setImage(UIImage(systemName: "message")?.withConfiguration(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 26))),
                    for: .normal)
        $0.tintColor = .tintColor
        $0.contentVerticalAlignment = .center
        $0.contentHorizontalAlignment = .center
    }
    
    let commentCountLabel = UILabel().then {
        $0.font = SSFont.semiBold14
        $0.textAlignment = .left
    }
    
    let titleLabel = UILabel().then {
        $0.font = SSFont.semiBold24
        $0.numberOfLines = 2
    }
    
    let categoryLabel = UILabel().then {
        $0.font = SSFont.semiBold14
        $0.textColor = .systemGray
    }
    
    private let descriptionTitle = UILabel().then {
        $0.text = "매물 정보"
        $0.font = SSFont.semiBold24
    }
    
    private let addressTitleLabel = UILabel().then {
        $0.text = "주소: "
        $0.font = SSFont.semiBold16
    }
    
    let addressLabel = UILabel().then {
        $0.font = SSFont.semiBold16
    }
    
    private let priceTitleLabel = UILabel().then {
        $0.text = "보증금 / 월세: "
        $0.font = SSFont.semiBold16
    }
    
    let priceLabel = UILabel().then {
        $0.font = SSFont.semiBold16
    }
    
    private let spaceTitleLabel = UILabel().then {
        $0.text = "규모: "
        $0.font = SSFont.semiBold16
    }
    
    let spaceLabel = UILabel().then {
        $0.font = SSFont.semiBold16
    }
    
    private let contentTitle = UILabel().then {
        $0.text = "상세 설명"
        $0.font = SSFont.semiBold24
    }
    
    let contentLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.numberOfLines = 0
    }
    
    private let mapTitle = UILabel().then {
        $0.text = "지도"
        $0.font = SSFont.semiBold24
    }
    
    let mapView = MKMapView().then {
        $0.isScrollEnabled = false
        $0.layer.cornerRadius = 16
    }
    
    private let inquiryTitle = UILabel().then {
        $0.text = "문의하기"
        $0.font = SSFont.semiBold24
    }
    
    lazy var inquiryStackView = UIStackView(arrangedSubviews: [phoneButton, messageButton]).then {
        $0.axis = .horizontal
        $0.spacing = 80
        $0.distribution = .fillEqually
    }
    
    let phoneButton = UIButton().then {
        $0.setTitle("전화하기", for: .normal)
        $0.setTitleColor(.tintColor, for: .normal)
        $0.setImage(UIImage(systemName: "phone.fill"), for: .normal)
        $0.titleEdgeInsets = .init(top: 0, left: 16, bottom: 0, right: 0)
    }
    
    let messageButton = UIButton().then {
        $0.setTitle("문자하기", for: .normal)
        $0.setTitleColor(.tintColor, for: .normal)
        $0.setImage(UIImage(systemName: "message.fill"), for: .normal)
        $0.titleEdgeInsets = .init(top: 0, left: 16, bottom: 0, right: 0)
    }
    
    private let commentTitle = UILabel().then {
        $0.text = "댓글"
        $0.font = SSFont.semiBold24
    }
    
    let commentsTableView = UITableView().then {
        $0.register(CommentCell.self, forCellReuseIdentifier: CommentCell.identifier)
        $0.rowHeight = UITableView.automaticDimension
        $0.isScrollEnabled = false
    }
    
    let commentTextField = UITextField().then {
        $0.placeholder = "댓글을 입력하세요"
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 8
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        $0.leftViewMode = .always
    }
    
    let sendButton = UIButton().then {
        $0.setImage(UIImage(systemName: "paperplane.circle.fill")?.withConfiguration(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 30))), for: .normal)
        $0.tintColor = .tintColor
    }
    
    // MARK: - Configure
    
    override func configureHierarchy() {
        super.configureHierarchy()
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(imageScrollView, profileView, heartButton, heartCountLabel, commentButton, commentCountLabel,
                                titleLabel, categoryLabel, descriptionTitle, addressTitleLabel, addressLabel,
                                priceTitleLabel, priceLabel, spaceTitleLabel, spaceLabel,
                                contentTitle, contentLabel, mapTitle, mapView,
                                commentTitle, commentsTableView, commentTextField, sendButton,
                                inquiryTitle, inquiryStackView)
    }
    
    override func configureLayout() {
        super.configureLayout()
        setLayout()
    }
    
    override func configureView() {
        super.configureView()
    }
    
    func configureViewData(_ data: ContentEntity) {
       titleLabel.text = data.title
       contentLabel.text = data.content
       categoryLabel.text = data.category
       addressLabel.text = data.address
       priceLabel.text = data.price
       spaceLabel.text = data.space
       profileView.setValues(nick: data.creator.nick, imageURL: data.creator.profileImage)
        
        imageScrollView.imageViews = data.files.map {
            let imageView = UIImageView()
            imageView.kf.setSeSACImage(input: APIKey.baseURL + "/v1/" + $0)
            return imageView
        }
        
        heartCountLabel.text = String(data.likes.count)
        heartButton.isSelected = data.likes.contains { $0 == UserDefaultsManager.shared.userData.userID }
    }
}

extension DetailFeedView {
    
    private func setLayout() {
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalToSuperview().offset(-100)
            make.bottom.equalToSuperview()
        }
        
        imageScrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(self.snp.width).multipliedBy(0.8)
        }
    
        profileView.snp.makeConstraints { make in
            make.top.equalTo(imageScrollView.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(30)
        }
        
        heartButton.snp.makeConstraints { make in
            make.top.equalTo(imageScrollView.snp.bottom).offset(8)
            make.leading.greaterThanOrEqualTo(profileView.snp.trailing).offset(16)
            make.size.equalTo(30)
        }
        
        heartCountLabel.snp.makeConstraints { make in
            make.top.equalTo(imageScrollView.snp.bottom).offset(8)
            make.leading.equalTo(heartButton.snp.trailing).offset(4)
            make.height.equalTo(30)
        }
        
        commentButton.snp.makeConstraints { make in
            make.top.equalTo(imageScrollView.snp.bottom).offset(8)
            make.leading.equalTo(heartCountLabel.snp.trailing).offset(16)
            make.size.equalTo(30)
        }
        
        commentCountLabel.snp.makeConstraints { make in
            make.top.equalTo(imageScrollView.snp.bottom).offset(8)
            make.leading.equalTo(commentButton.snp.trailing).offset(4)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        descriptionTitle.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        addressTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionTitle.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(addressTitleLabel.snp.top)
            make.leading.equalTo(addressTitleLabel.snp.trailing).offset(4)
            make.trailing.lessThanOrEqualToSuperview().offset(-16)
        }
        
        priceTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(addressTitleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(priceTitleLabel.snp.top)
            make.leading.equalTo(priceTitleLabel.snp.trailing).offset(4)
            make.trailing.lessThanOrEqualToSuperview().offset(-16)
        }
        
        spaceTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(priceTitleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
        }
        
        spaceLabel.snp.makeConstraints { make in
            make.top.equalTo(spaceTitleLabel.snp.top)
            make.leading.equalTo(spaceTitleLabel.snp.trailing).offset(4)
            make.trailing.lessThanOrEqualToSuperview().offset(-16)
        }
        
        mapTitle.snp.makeConstraints { make in
            make.top.equalTo(spaceLabel.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(mapTitle.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(140)
        }
        
        contentTitle.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(contentTitle.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        inquiryTitle.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        inquiryStackView.snp.makeConstraints { make in
            make.top.equalTo(inquiryTitle.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(300)
        }
        
        commentTitle.snp.makeConstraints { make in
            make.top.equalTo(inquiryStackView.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        commentsTableView.snp.makeConstraints { make in
            make.top.equalTo(commentTitle.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            heightConstraint = make.height.equalTo(0).constraint
        }
        
        commentTextField.snp.makeConstraints { make in
            make.top.equalTo(commentsTableView.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
            make.height.equalTo(44)
        }
        
        sendButton.snp.makeConstraints { make in
            make.top.equalTo(commentsTableView.snp.bottom).offset(8)
            make.leading.equalTo(commentTextField.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview().offset(-8)
            make.size.equalTo(44)
        }
    }
}
