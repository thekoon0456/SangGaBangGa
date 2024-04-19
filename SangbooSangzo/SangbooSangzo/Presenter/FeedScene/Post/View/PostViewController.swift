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
    
    private lazy var scrollView = UIScrollView().then {
        $0.addSubview(contentView)
    }
    
    private let contentView = UIView()
    
    private lazy var imageCollectionView = UICollectionView(frame: .zero,
                                                            collectionViewLayout: configureLayout()).then {
        $0.register(PostImageCell.self, forCellWithReuseIdentifier: PostImageCell.identifier)
        $0.showsHorizontalScrollIndicator = false
    }
    
    private let photoSubject = BehaviorSubject(value: [UIImage]())
    
    var data = [UIImage]()
    
    private func configureLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 100, height: 100)
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .horizontal
        return layout
    }
    
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
    
    override func bind() {
        super.bind()
        
        imageButton.rx.tap.bind(with: self) { owner, _ in
            owner.configurePHPicker()
        }
        .disposed(by: disposeBag)
        
        
        photoSubject.bind(to:imageCollectionView.rx.items(cellIdentifier: PostImageCell.identifier, cellType: PostImageCell.self)) { item, element, cell in
            cell.configureCell(image: element)
        }
        .disposed(by: disposeBag)
    }
    
    private func configurePHPicker() {
        var configuration = PHPickerConfiguration()
        //사진 다중선택 가능, 0으로 설정시 무제한 선택 가능
        configuration.selectionLimit = 5
        //앨범 중 사진, 동영사상, 스크린캡쳐, 화면녹화, 타임랩스 등 사진에 대한 종류 필터
        configuration.filter = .images //사진만 나옴
        //.any를 통해 배열 형태로 여러 종류 동시에 필터 설정 가능
        configuration.filter = .any(of: [.images, .videos])
        let vc = PHPickerViewController(configuration: configuration)
        vc.delegate = self
        present(vc, animated: true)
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        view.addSubview(scrollView)
        contentView.addSubviews(imageButton, imageCollectionView, titleTextField, contentTextView, categoryButton,
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
        
        imageCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalTo(imageButton.snp.trailing).offset(8)
            make.trailing.equalToSuperview()
            make.height.equalTo(100)
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

extension PostViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        results.forEach { result in
            let itemProvider = result.itemProvider
            
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    guard let self,
                          let image = image as? UIImage else { return }
                    data.append(image)
                    photoSubject.onNext(data)
                }
            }
        }
        
//        let itemProvider = results.first?.itemProvider
//        
//        if let itemProvider,
//           //실제 이미지가 존재하고, UIImage타입으로 가지고 올 수 있는지 체크
//           itemProvider.canLoadObject(ofClass: UIImage.self) {
//            //메타정보는 빼고 이미지만 가져옴
//            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
//                //메인스레드에서 동작하도록 설정
//                DispatchQueue.main.async { [weak self] in
//                    guard let self,
//                        let image = image as? UIImage else { return }
//                    imageButton.setImage(image, for: .normal)
//                }
//            }
//        }
        
        picker.dismiss(animated: true)
    }
}
