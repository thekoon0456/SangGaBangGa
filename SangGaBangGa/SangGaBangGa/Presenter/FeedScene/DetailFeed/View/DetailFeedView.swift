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
    
    // MARK: - UI
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    lazy var imageScrollView = ImageScrollView()
    
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
    
    let titleLabel = UILabel().then {
        $0.font = SSFont.semiBold20
        $0.numberOfLines = 2
    }
    
    let categoryLabel = PaddingLabel().then {
        $0.font =  SSFont.medium12
        $0.textColor = .white
        $0.backgroundColor = .tintColor
        $0.layer.cornerRadius = 4
        $0.clipsToBounds = true
        $0.padding = .init(top: 16, left: 8, bottom: 16, right: 8)
    }
    
    private let descriptionTitle = UILabel().then {
        $0.text = "매물 정보"
        $0.font = SSFont.semiBold20
    }
    
    private let addressTitleLabel = UILabel().then {
        $0.text = "주소: "
        $0.font = SSFont.semiBold14
    }
    
    let addressLabel = UILabel().then {
        $0.font = SSFont.semiBold14
    }
    
    private let priceTitleLabel = UILabel().then {
        $0.text = "보증금 / 월세: "
        $0.font = SSFont.semiBold14
    }
    
    let priceLabel = UILabel().then {
        $0.font = SSFont.semiBold14
    }
    
    private let spaceTitleLabel = UILabel().then {
        $0.text = "규모: "
        $0.font = SSFont.semiBold14
    }
    
    let spaceLabel = UILabel().then {
        $0.font = SSFont.semiBold14
    }
    
    private let dateTitleLabel = UILabel().then {
        $0.text = "등록일: "
        $0.font = SSFont.semiBold14
    }
    
    let dateLabel = UILabel().then {
        $0.font = SSFont.semiBold14
    }
    
    private let contentTitle = UILabel().then {
        $0.text = "상세 설명"
        $0.font = SSFont.semiBold20
    }
    
    let contentLabel = UILabel().then {
        $0.font = SSFont.medium14
        $0.numberOfLines = 0
    }
    
    private let mapTitle = UILabel().then {
        $0.text = "지도"
        $0.font = SSFont.semiBold20
    }
    
    let mapView = MKMapView().then {
        $0.isScrollEnabled = false
        $0.layer.cornerRadius = 16
        $0.register(CustomMarkerView.self,
                    forAnnotationViewWithReuseIdentifier: CustomMarkerView.identifier)
    }
    
    private let inquiryTitle = UILabel().then {
        $0.text = "문의하기"
        $0.font = SSFont.semiBold20
    }
    
    let userConnectView = UserConnectView()
    
    let paymentButton = UIButton().then {
        $0.setTitle("계약금 입금하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = SSFont.semiBold16
        $0.backgroundColor = .accent
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }
    
    
    // MARK: - Configure
    
    override func configureHierarchy() {
        super.configureHierarchy()
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(imageScrollView, heartButton, heartCountLabel, commentButton, commentCountLabel,
                                titleLabel, categoryLabel, descriptionTitle, dateTitleLabel, dateLabel,
                                addressTitleLabel, addressLabel,
                                priceTitleLabel, priceLabel, spaceTitleLabel, spaceLabel,
                                contentTitle, contentLabel, mapTitle, mapView,
                                inquiryTitle, userConnectView, paymentButton)
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
        userConnectView.setValues(nick: data.creator.nick, imageURL: data.creator.profileImage)
        
        imageScrollView.imageViews = data.files.map {
            let imageView = UIImageView()
            imageView.kf.setSeSACImage(input: APIKey.baseURL + "/v1/" + $0)
            imageView.contentMode = .scaleAspectFill
            return imageView
        }
        
        heartCountLabel.text = String(data.likes.count)
        commentCountLabel.text = String(data.comments.count)
        
        let formatter = DateFormatterManager.shared
        dateLabel.text = formatter.iso8601DateToString(data.createdAt, format: .date)
        
        guard let userID = UserDefaultsManager.shared.userData.userID else { return }
        heartButton.isSelected = data.likes.contains(userID)
        commentButton.isSelected = data.comments.contains { $0.creator.userID == userID }
        
        data.buyers.contains(userID)
        ? setPaymentsButton(isEnable: false)
        : setPaymentsButton(isEnable: true)
    }
    
    func setPaymentsButton(isEnable: Bool) {
        if isEnable {
            paymentButton.setTitle("계약금 입금하기", for: .normal)
            paymentButton.setTitleColor(.white, for: .normal)
        } else {
            paymentButton.setTitle("계약금 입금이 완료되었습니다", for: .normal)
            paymentButton.setTitleColor(.systemGray, for: .normal)
        }
    }
}

extension DetailFeedView {
    
    private func setLayout() {
        
        scrollView.snp.makeConstraints { make in
            make.size.equalTo(UIScreen.main.bounds.size)
        }
        
        contentView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        imageScrollView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-100)
            make.width.equalToSuperview()
            make.height.equalTo(imageScrollView.snp.width).multipliedBy(0.8)
        }
        
        heartButton.snp.makeConstraints { make in
            make.top.equalTo(imageScrollView.snp.bottom).offset(8)
            make.trailing.equalTo(commentButton.snp.leading).offset(-12)
            make.size.equalTo(30)
        }
        
        heartCountLabel.snp.makeConstraints { make in
            make.top.equalTo(heartButton.snp.bottom)
            make.centerX.equalTo(heartButton)
        }
        
        commentButton.snp.makeConstraints { make in
            make.top.equalTo(imageScrollView.snp.bottom).offset(8)
            make.trailing.equalToSuperview().offset(-12)
            make.size.equalTo(30)
        }
        
        commentCountLabel.snp.makeConstraints { make in
            make.top.equalTo(commentButton.snp.bottom)
            make.centerX.equalTo(commentButton)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageScrollView.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(heartButton.snp.leading).offset(-4)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(12)
            make.height.equalTo(20)
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
        
        dateTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(spaceLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(dateTitleLabel.snp.top)
            make.leading.equalTo(dateTitleLabel.snp.trailing).offset(4)
            make.trailing.lessThanOrEqualToSuperview().offset(-16)
        }
        
        mapTitle.snp.makeConstraints { make in
            make.top.equalTo(dateTitleLabel.snp.bottom).offset(24)
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
        
        userConnectView.snp.makeConstraints { make in
            make.top.equalTo(inquiryTitle.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(72)
        }
        
        paymentButton.snp.makeConstraints { make in
            make.top.equalTo(userConnectView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
}
