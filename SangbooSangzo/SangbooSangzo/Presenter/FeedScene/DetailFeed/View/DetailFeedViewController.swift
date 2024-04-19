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
    
    // MARK: - UI
    
    private lazy var scrollView = UIScrollView().then {
        $0.addSubview(contentView)
    }
    
    private let contentView = UIView()
    
    private let imageView = UIImageView().then {
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    
    let heartButton = UIButton().then {
        $0.setImage(UIImage(systemName: "heart"), for: .normal)
        $0.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        $0.backgroundColor = .white
        $0.tintColor = .tintColor
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
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
    
    // MARK: - Lifecycles
    
    init(viewModel: DetailFeedViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Bind
    
    override func bind() {
        super.bind()
        
        let input = DetailFeedViewModel.Input(viewDidLoad: self.rx.viewDidLoad)
        let output = viewModel.transform(input)
        
        output.data.drive(with: self) { owner, data in
            owner.imageView.kf.setSeSACImage(input: APIKey.baseURL + "/v1/" + (data.files?.first ?? ""))
            owner.heartButton.isSelected = data.likes!.contains(data.postID ?? "")
            ? true
            : false
            owner.titleLabel.text = data.title
            owner.contentLabel.text = data.content
            owner.categoryLabel.text = data.content1
            owner.addressLabel.text = data.content2
//            owner.areaLabel.text = data.content3
            owner.priceLabel.text = data.content4
            owner.spaceLabel.text = data.content5
        }
        .disposed(by: disposeBag)
    }
    
    // MARK: - Configure
    
    override func configureHierarchy() {
        super.configureHierarchy()
        view.addSubview(scrollView)
        contentView.addSubviews(imageView, heartButton, titleLabel, categoryLabel, addressLabel, priceLabel, spaceLabel, contentLabel)
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
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(300)
        }
        
        heartButton.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(20)
            make.size.equalTo(44)
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
            make.bottom.equalToSuperview().offset(-8)
        }
    }
}
