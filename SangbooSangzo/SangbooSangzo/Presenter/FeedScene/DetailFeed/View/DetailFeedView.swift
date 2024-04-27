//
//  DetailFeedView.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/27/24.
//

import MapKit
import UIKit

import SnapKit

final class DetailFeedView: BaseView {
    
    var heightConstraint: Constraint?
    
    // MARK: - UI
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    //    private let profileView = DetailUserInfoView().then {
    //        $0.isUserInteractionEnabled = true
    //    }
    
    lazy var imageScrollView = ImageScrollView()
    
    let heartButton = UIButton().then {
        $0.setImage(UIImage(systemName: "heart")?.withConfiguration(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 26))), for: .normal)
        $0.setImage(UIImage(systemName: "heart.fill")?.withConfiguration(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 26))), for: .selected)
        $0.tintColor = .tintColor
    }
    
    let heartCountLabel = UILabel().then {
        $0.font = SSFont.titleSmall
        $0.textAlignment = .left
    }
    
    let commentButton = UIButton().then {
        $0.setImage(UIImage(systemName: "message")?.withConfiguration(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 26))), for: .normal)
        $0.tintColor = .tintColor
    }
    
    let commentCountLabel = UILabel().then {
        $0.font = SSFont.titleSmall
        $0.textAlignment = .left
    }
    
    let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.numberOfLines = 2
    }
    
    let categoryLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .systemGray
    }
    
    let addressLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
    }
    
    let priceLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 18, weight: .bold)
    }
    
    let spaceLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
    }
    
    let contentLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.numberOfLines = 0
    }
    
    let mapView = MKMapView().then {
        $0.isScrollEnabled = false
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
        contentView.addSubviews(imageScrollView, heartButton, heartCountLabel, commentButton, commentCountLabel, titleLabel, categoryLabel, addressLabel, priceLabel, spaceLabel, contentLabel, mapView, commentsTableView, commentTextField, sendButton)
    }
    
    override func configureLayout() {
        super.configureLayout()
        setLayout()
    }
    
    override func configureView() {
        super.configureView()
    }
}

extension DetailFeedView {
    
    private func setLayout() {
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            //            make.verticalEdges.equalToSuperview()
            make.top.equalToSuperview().offset(-100)
            make.bottom.equalToSuperview()
        }
        
        //        profileView.snp.makeConstraints { make in
        //            make.top.equalToSuperview()
        //            make.leading.equalToSuperview().offset(8)
        //            make.trailing.equalToSuperview().offset(-8)
        //            make.height.equalTo(64)
        //        }
        
        imageScrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(self.snp.width)
        }
        
        heartButton.snp.makeConstraints { make in
            make.top.equalTo(imageScrollView.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(4)
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
            make.height.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(heartButton.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }
        
        spaceLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(spaceLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.height.equalTo(180)
        }
        
        commentsTableView.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            heightConstraint = make.height.equalTo(0).constraint
        }
        
        commentTextField.snp.makeConstraints { make in
            make.top.equalTo(commentsTableView.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
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
