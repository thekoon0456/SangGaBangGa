//
//  PostViewController.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/16/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class PostViewController: RxBaseViewController {
    
    private let viewModel: PostViewModel
    
    private lazy var scrollView = UIScrollView().then {
        $0.addSubview(contentView)
    }
    
    private let contentView = UIView()
    
    private let imageButton = UIButton().then {
        $0.setImage(UIImage(systemName: "photo"), for: .normal)
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.layer.borderWidth = 1
    }
    
    private let titleTextField = UITextField().then {
        $0.placeholder = "제목을 입력해주세요"
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemGray.cgColor
        $0.borderStyle = .roundedRect
    }
    
    private let contentTextView = UITextView().then {
        $0.textAlignment = .left
        $0.isScrollEnabled = false
        $0.font = .systemFont(ofSize: 18)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemGray.cgColor
    }
    
    private let categoryButton = SSMenuButton(buttonTitle: "카테고리", menus: ["공실", "카페", "음식점", "기타"])
    
    private let addressTextField = UITextField().then {
        $0.placeholder = "주소를 입력해주세요 (시군구)"
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemGray.cgColor
        $0.borderStyle = .roundedRect
    }
    
    private let depositTextField = UITextField().then {
        $0.placeholder = "보증금"
        $0.keyboardType = .numberPad
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemGray.cgColor
        $0.borderStyle = .roundedRect
    }
    
    private let rentTextField = UITextField().then {
        $0.placeholder = "월세"
        $0.keyboardType = .numberPad
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemGray.cgColor
        $0.borderStyle = .roundedRect
    }
    
    private let spaceTextField = UITextField().then {
        $0.placeholder = "평수 (약 -평)"
        $0.keyboardType = .numberPad
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemGray.cgColor
        $0.borderStyle = .roundedRect
    }
    
    private let postButton = UIButton().then {
        $0.setTitle("게시글 올리기", for: .normal)
        $0.setTitle("모든 항목을 입력해주세요", for: .disabled)
        $0.setTitleColor(.white, for: .normal)
        $0.setTitleColor(.lightGray, for: .disabled)
        $0.backgroundColor = .tintColor
        $0.isEnabled = false
    }
    
    init(viewModel: PostViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        view.addSubview(scrollView)
        contentView.addSubviews(imageButton, titleTextField, contentTextView, categoryButton,
                         addressTextField, depositTextField, rentTextField, spaceTextField, postButton)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        scrollView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.verticalEdges.equalToSuperview()
        }
        
        imageButton.snp.makeConstraints { make in
            make.size.equalTo(100)
            make.top.leading.equalToSuperview().offset(20)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(imageButton.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(60)
        }
        
        categoryButton.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(60)
            make.width.equalTo(120)
        }
        
        addressTextField.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(20)
            make.leading.equalTo(categoryButton.snp.trailing).offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(60)
        }
        
        depositTextField.snp.makeConstraints { make in
            make.top.equalTo(categoryButton.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(60)
            make.width.equalTo(120)
        }
        
        rentTextField.snp.makeConstraints { make in
            make.top.equalTo(categoryButton.snp.bottom).offset(20)
            make.leading.equalTo(categoryButton.snp.trailing).offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(60)
        }
        
        spaceTextField.snp.makeConstraints { make in
            make.top.equalTo(depositTextField.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(60)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(spaceTextField.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.greaterThanOrEqualTo(200)
        }
        
        postButton.snp.makeConstraints { make in
            make.top.equalTo(contentTextView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(60)
            make.bottom.equalToSuperview()
        }
        
    }
    
    override func configureView() {
        super.configureView()
        navigationItem.title = "게시글 작성하기"
    }
    
}

