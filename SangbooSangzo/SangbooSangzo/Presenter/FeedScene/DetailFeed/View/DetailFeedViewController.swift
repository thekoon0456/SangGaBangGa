//
//  DetailFeedViewController.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/19/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Kingfisher

final class DetailFeedViewController: RxBaseViewController {
    
    private let viewModel: DetailFeedViewModel
    var heightConstraint: Constraint?
    
    // MARK: - UI
    
    private lazy var scrollView = UIScrollView().then {
        $0.addSubview(contentView)
    }
    
    private let contentView = UIView()
    
    private let profileView = DetailUserInfoView().then {
        $0.isUserInteractionEnabled = true
    }
    
    private let imageView = UIImageView().then {
        $0.layer.cornerRadius = 4
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    
    private lazy var imageScrollView = ImageScrollView()
    
    let heartButton = UIButton().then {
        $0.setImage(UIImage(systemName: "heart")?.withConfiguration(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 26))), for: .normal)
        $0.setImage(UIImage(systemName: "heart.fill")?.withConfiguration(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 26))), for: .selected)
        $0.tintColor = .tintColor
    }
    
    private let heartCountLabel = UILabel().then {
        $0.font = SSFont.titleSmall
        $0.textAlignment = .left
    }
    
    let commentButton = UIButton().then {
        $0.setImage(UIImage(systemName: "message")?.withConfiguration(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 26))), for: .normal)
        $0.tintColor = .tintColor
    }
    
    private let commentCountLabel = UILabel().then {
        $0.font = SSFont.titleSmall
        $0.textAlignment = .left
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.numberOfLines = 2
    }
    
    private let categoryLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .systemGray
    }
    
    private let addressLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
    }

    private let priceLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 18, weight: .bold)
    }
    
    private let spaceLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
    }
    
    private let contentLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.numberOfLines = 0
    }
    
    private let commentsTableView = UITableView().then {
        $0.register(CommentCell.self, forCellReuseIdentifier: CommentCell.identifier)
        $0.rowHeight = UITableView.automaticDimension
        $0.isScrollEnabled = false
    }
    
    private let commentTextField = UITextField().then {
        $0.placeholder = "댓글을 입력하세요"
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 8
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        $0.leftViewMode = .always
    }
    
    private let sendButton = UIButton().then {
        $0.setImage(UIImage(systemName: "paperplane.circle.fill")?.withConfiguration(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 30))), for: .normal)
        $0.tintColor = .tintColor
    }
    
    // MARK: - Lifecycles
    
    init(viewModel: DetailFeedViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Bind
    
    override func bind() {
        super.bind()
        let heartButtonTapped = heartButton.rx.tap.map { [weak self] in
            guard let self else { return false }
            return heartButton.isSelected
        }
        
        let commentSendButtonTapped = sendButton.rx.tap.withLatestFrom(commentTextField.rx.text.orEmpty)
        
        let input = DetailFeedViewModel.Input(viewWillAppear: self.rx.viewWillAppear.map { _ in },
                                              heartButtonTapped: heartButtonTapped,
                                              commentSendButtonTapped: commentSendButtonTapped)
        let output = viewModel.transform(input)
        
        output.data.drive(with: self) { owner, data in
            owner.titleLabel.text = data.title
            owner.contentLabel.text = data.content
            owner.categoryLabel.text = data.content1
            owner.addressLabel.text = data.content2
            owner.priceLabel.text = data.content4
            owner.spaceLabel.text = data.content5
            owner.profileView.setValues(nick: data.creator.nick, imageURL: data.creator.profileImage)
//            owner.commentCountLabel.text = String(data.comments.count)
            
            owner.imageScrollView.imageViews = data.files.map {
                let imageView = UIImageView()
                imageView.kf.setSeSACImage(input: APIKey.baseURL + "/v1/" + $0)
                return imageView
            }
            
            owner.heartCountLabel.text = String(data.likes.count)
            owner.heartButton.isSelected = data.likes.contains { $0 == UserDefaultsManager.shared.userData.userID }
        }
        .disposed(by: disposeBag)
        
        output
            .heartButtonStatus
            .drive(heartButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        output
            .heartCount
            .drive(heartCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        output
            .comments
            .drive(commentsTableView.rx.items(cellIdentifier: CommentCell.identifier, cellType: CommentCell.self)) { row, element, cell in
                cell.configureCell(data: element)
            }
            .disposed(by: disposeBag)
        
        output
            .comments
            .drive(with: self) { owner, data in
                owner.heightConstraint?.update(offset: owner.commentsTableView.contentSize.height)
                owner.commentsTableView.layoutIfNeeded()
                owner.commentCountLabel.text = String(data.count)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Configure
    
    override func configureHierarchy() {
        super.configureHierarchy()
        view.addSubview(scrollView)
        contentView.addSubviews(profileView, imageScrollView, heartButton, heartCountLabel, commentButton, commentCountLabel, titleLabel, categoryLabel, addressLabel, priceLabel, spaceLabel, contentLabel, commentsTableView, commentTextField, sendButton)
    }
    
    override func configureLayout() {
        super.configureLayout()
        setLayout()
    }
    
    override func configureView() {
        super.configureView()
    }
}

extension DetailFeedViewController {
    
    private func setLayout() {
        
        scrollView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.verticalEdges.equalToSuperview()
        }
        
        profileView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.height.equalTo(64)
        }
        
        imageScrollView.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(view.snp.width)
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
        
        commentsTableView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(8)
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
