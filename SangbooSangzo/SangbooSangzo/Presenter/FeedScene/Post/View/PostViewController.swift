//
//  PostViewController.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/16/24.
//

import UIKit
import PhotosUI

import RxCocoa
import RxSwift
import SnapKit

final class PostViewController: RxBaseViewController {
    
    private let viewModel: PostViewModel
    var data: [Data] = []
    private lazy var selectedImagesRelay = BehaviorRelay<[Data]>(value: [])
    
    private lazy var scrollView = UIScrollView().then {
        $0.addSubview(contentView)
    }
    
    private let contentView = UIView()
    
    private lazy var imageCollectionView = UICollectionView(frame: .zero,
                                                            collectionViewLayout: configureLayout()).then {
        $0.register(PostImageCell.self, forCellWithReuseIdentifier: PostImageCell.identifier)
        $0.showsHorizontalScrollIndicator = false
    }
    
    private func configureLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 100, height: 100)
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .horizontal
        return layout
    }
    
    private let imageTitleLabel = UILabel().then {
        $0.text = "사진 (최대 5장)"
        $0.font = SSFont.semiBold18
    }
    
    private let imageButton = UIButton().then {
        $0.setImage(UIImage(systemName: "photo"), for: .normal)
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.layer.borderWidth = 1
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "카테고리 / 제목"
        $0.font = SSFont.semiBold18
    }
    
    private let titleTextField = UITextField().then {
        $0.placeholder = "제목을 입력해주세요"
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemGray.cgColor
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.leftView = UIView(frame: .init(x: 0, y: 0, width: 12, height: 0))
        $0.leftViewMode = .always
    }
    
    private let contentTitleLabel = UILabel().then {
        $0.text = "상세 내용"
        $0.font = SSFont.semiBold14
    }
    
    private let contentTextView = UITextView().then {
        $0.textAlignment = .left
        $0.isScrollEnabled = false
        $0.font = .systemFont(ofSize: 18)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemGray.cgColor
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
    private let categoryButton = SSMenuButton(buttonTitle: "카테고리",
                                              menus: ["공실", "카페", "음식점", "기타"])
    
    private let addressTitleLabel = UILabel().then {
        $0.text = "주소"
        $0.font = SSFont.semiBold18
    }
    
    private let addressTextField = UITextField().then {
        $0.placeholder = "해당 매물의 주소를 입력해주세요"
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemGray.cgColor
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.leftView = UIView(frame: .init(x: 0, y: 0, width: 12, height: 0))
        $0.leftViewMode = .always
    }
    
    private let priceTitleLabel = UILabel().then {
        $0.text = "보증금 / 월세"
        $0.font = SSFont.semiBold18
    }
    
    private let depositTextField = UITextField().then {
        $0.placeholder = "보증금"
        $0.keyboardType = .numberPad
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemGray.cgColor
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.leftView = UIView(frame: .init(x: 0, y: 0, width: 12, height: 0))
        $0.leftViewMode = .always
    }
    
    private let depositPriceLabel = UILabel().then {
        $0.text = "만원"
        $0.font = SSFont.semiBold14
    }
    
    private let rentTextField = UITextField().then {
        $0.placeholder = "월세"
        $0.keyboardType = .numberPad
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemGray.cgColor
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.leftView = UIView(frame: .init(x: 0, y: 0, width: 12, height: 0))
        $0.leftViewMode = .always
    }
    
    private let rentPriceLabel = UILabel().then {
        $0.text = "만원"
        $0.font = SSFont.semiBold14
    }
    
    private let spaceTitleLabel  = UILabel().then {
        $0.text = "규모"
        $0.font = SSFont.semiBold18
    }
    
    private let spaceTextField = UITextField().then {
        $0.placeholder = "약 -평"
        $0.keyboardType = .numberPad
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemGray.cgColor
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.leftView = UIView(frame: .init(x: 0, y: 0, width: 12, height: 0))
        $0.leftViewMode = .always
    }
    
    private let spaceLabel = UILabel().then {
        $0.text = "평"
        $0.font = SSFont.semiBold14
    }
    
    private let space33Field = UITextField().then {
        $0.placeholder = "약 -㎡"
        $0.keyboardType = .numberPad
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemGray.cgColor
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.leftView = UIView(frame: .init(x: 0, y: 0, width: 12, height: 0))
        $0.leftViewMode = .always
    }
    
    private let m2Label = UILabel().then {
        $0.text = "㎡"
        $0.font = SSFont.semiBold14
    }

    private let detailTitleLabel  = UILabel().then {
        $0.text = "상세 내용"
        $0.font = SSFont.semiBold18
    }
    
    private let postButton = UIButton().then {
        $0.setTitle("게시글 올리기", for: .normal)
        $0.setTitle("모든 항목을 입력해주세요", for: .disabled)
        $0.setTitleColor(.white, for: .normal)
        $0.setTitleColor(.lightGray, for: .disabled)
        $0.backgroundColor = .tintColor
        $0.isEnabled = false
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
    init(viewModel: PostViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func bind() {
        super.bind()
        
        let input = PostViewModel.Input(selectedPhotos: selectedImagesRelay,
                                        title: titleTextField.rx.text.orEmpty,
                                        category: categoryButton.menuButtonRelay,
                                        address: addressTextField.rx.text.orEmpty,
                                        deposit: depositTextField.rx.text.orEmpty,
                                        rent: rentTextField.rx.text.orEmpty,
                                        space: spaceTextField.rx.text.orEmpty,
                                        spaceM2: space33Field.rx.text.orEmpty,
                                        content: contentTextView.rx.text.orEmpty,
                                        post: postButton.rx.tap)
        let output = viewModel.transform(input)
        
        imageButton.rx.tap.bind(with: self) { owner, _ in
            guard owner.data.count < 5 else { return }
            owner.configurePHPicker()
        }
        .disposed(by: disposeBag)
        
        output
            .buttonEnable
            .drive(postButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output
            .selectedPhotos
            .drive(imageCollectionView.rx.items(
                cellIdentifier: PostImageCell.identifier,
                cellType: PostImageCell.self)
            ) { item, element, cell in
                cell.configureCell(image: UIImage(data: element) ?? UIImage())
            }
            .disposed(by: disposeBag)
        
        output
            .space
            .drive(spaceTextField.rx.text)
            .disposed(by: disposeBag)
        
        output
            .spaceM2
            .drive(space33Field.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func configurePHPicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 5 - data.count
        configuration.filter = .images
        configuration.filter = .any(of: [.images])
        let vc = PHPickerViewController(configuration: configuration)
        vc.delegate = self
        present(vc, animated: true)
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        view.addSubview(scrollView)
        contentView.addSubviews(imageTitleLabel, imageButton, imageCollectionView, titleLabel, categoryButton, titleTextField,
                                contentTextView, addressTitleLabel, addressTextField,
                                priceTitleLabel, depositTextField, depositPriceLabel, rentTextField, rentPriceLabel,
                                spaceTitleLabel, spaceTextField, spaceLabel, space33Field,m2Label, detailTitleLabel, postButton)
    }
    
    override func configureLayout() {
        super.configureLayout()
        setLayout()
    }
    
    override func configureView() {
        super.configureView()
        navigationItem.title = "게시글 작성하기"
    }
}

extension PostViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        results.forEach { result in
            let itemProvider = result.itemProvider
            
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    guard let self,
                          let image = image as? UIImage else { return }
                    data.append(image.jpegData(compressionQuality: 0.5)!)
                    selectedImagesRelay.accept(data)
                }
            }
        }
        
        picker.dismiss(animated: true)
    }
}

extension PostViewController {
    
    private func setLayout() {
        scrollView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.verticalEdges.equalToSuperview()
        }
        
        imageTitleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(20)
        }
        
        imageButton.snp.makeConstraints { make in
            make.top.equalTo(imageTitleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(20)
            make.size.equalTo(100)
        }
        
        imageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(imageButton.snp.top)
            make.leading.equalTo(imageButton.snp.trailing).offset(8)
            make.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageButton.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        categoryButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(60)
            make.width.equalTo(120)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(categoryButton.snp.trailing).offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(60)
        }
        
        addressTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryButton.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        addressTextField.snp.makeConstraints { make in
            make.top.equalTo(addressTitleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(60)
        }
        
        priceTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(addressTextField.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        depositTextField.snp.makeConstraints { make in
            make.top.equalTo(priceTitleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(60)
        }
        
        depositPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(priceTitleLabel.snp.bottom).offset(8)
            make.leading.equalTo(depositTextField.snp.trailing).offset(8)
            make.height.equalTo(60)
            make.width.equalTo(30)
        }
        
        rentTextField.snp.makeConstraints { make in
            make.top.equalTo(priceTitleLabel.snp.bottom).offset(8)
            make.leading.equalTo(depositPriceLabel.snp.trailing).offset(20)
            make.height.equalTo(60)
            make.width.equalTo(depositTextField.snp.width)
        }
        
        rentPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(priceTitleLabel.snp.bottom).offset(8)
            make.leading.equalTo(rentTextField.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(60)
            make.width.equalTo(30)
        }
        
        spaceTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(depositTextField.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        spaceTextField.snp.makeConstraints { make in
            make.top.equalTo(spaceTitleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(60)
        }
        
        spaceLabel.snp.makeConstraints { make in
            make.top.equalTo(spaceTextField.snp.top)
            make.leading.equalTo(spaceTextField.snp.trailing).offset(8)
            make.height.equalTo(60)
            make.width.equalTo(30)
        }
        
        space33Field.snp.makeConstraints { make in
            make.top.equalTo(spaceTextField.snp.top)
            make.leading.equalTo(spaceLabel.snp.trailing).offset(20)
            make.height.equalTo(60)
            make.width.equalTo(spaceTextField.snp.width)
        }
        
        m2Label.snp.makeConstraints { make in
            make.top.equalTo(space33Field.snp.top)
            make.leading.equalTo(space33Field.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(60)
            make.width.equalTo(30)
        }
        
        detailTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(spaceTextField.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(detailTitleLabel.snp.bottom).offset(8)
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
}
