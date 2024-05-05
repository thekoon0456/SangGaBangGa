//
//  EditProfileViewController.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/24/24.
//

import UIKit
import PhotosUI

import RxCocoa
import RxSwift
import Kingfisher

final class EditProfileViewController: RxBaseViewController {
    
    private let viewModel: EditProfileViewModel
    private let imageRelay = BehaviorRelay(value: UIImage())
    
    private let titleLabel = UILabel().then {
        $0.text = "프로필 수정"
        $0.textAlignment = .center
        $0.font = SSFont.bold28
        $0.textColor = .tintColor
    }
    
    private lazy var cameraImage = UIImageView(image: UIImage(named: "SSCameraButton"))
    
    lazy var profileImageView = UIImageView().then {
        $0.image = .ssUser
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 50
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewTapped)))
        $0.layer.borderColor = UIColor.accent.cgColor
        $0.layer.borderWidth = 4
    }
    
    private let emailTextField = UITextField().then {
        $0.placeholder = "이메일을 입력해주세요"
        $0.borderStyle = .roundedRect
        $0.isEnabled = false
    }
    
    private let passwordTextField = UITextField().then {
        $0.placeholder = "비밀번호를 입력해주세요"
        $0.borderStyle = .roundedRect
    }
    
    private let nicknameTextField = UITextField().then {
        $0.placeholder = "닉네임을 입력해주세요"
        $0.borderStyle = .roundedRect
    }
    
    private let phoneNumberTextField = UITextField().then {
        $0.placeholder = "전화번호를 숫자만 입력해주세요"
        $0.keyboardType = .numberPad
        $0.borderStyle = .roundedRect
    }
    
    private let editButton = UIButton().then {
        $0.setTitle("수정하기", for: .normal)
        $0.setTitle("모든 항목을 입력해주세요", for: .disabled)
        $0.setTitleColor(.white, for: .normal)
        $0.setTitleColor(.lightGray, for: .disabled)
        $0.backgroundColor = .tintColor
        $0.isEnabled = false
    }
    
    init(viewModel: EditProfileViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func bind() {
        super.bind()
        
        let input = EditProfileViewModel.Input(viewWillAppear: self.rx.viewWillAppear.map { _ in },
                                               password: passwordTextField.rx.text.orEmpty,
                                               nickname: nicknameTextField.rx.text.orEmpty,
                                               phoneNumber: phoneNumberTextField.rx.text.orEmpty,
                                               imageData: imageRelay.map { $0.jpegData(compressionQuality: 0.5)},
                                               editButtonTapped: editButton.rx.tap)
        
        let output = viewModel.transform(input)
        
        output
            .userInfo
            .drive(with: self) { owner, value in
                owner.emailTextField.text = value.email
                owner.nicknameTextField.text = value.nick
                owner.passwordTextField.text = nil
                owner.phoneNumberTextField.text = value.phoneNum
                guard let imageURL = value.profileImage else { return }
                owner.profileImageView.kf.setSeSACImage(input: APIKey.baseURL + "/v1/" + (imageURL))
            }
            .disposed(by: disposeBag)
        
        output
            .buttonEnabled
            .drive(editButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        imageRelay
            .asDriver()
            .drive(profileImageView.rx.image)
            .disposed(by: disposeBag)

    }
    
    // MARK: - Selectors
    
    @objc
    func imageViewTapped() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        viewModel.coordinator?.presentPHPickerView(picker: picker)
    }
    
    // MARK: - Helpers
    
    override func configureHierarchy() {
        super.configureHierarchy()
        view.addSubviews(titleLabel, profileImageView, emailTextField, passwordTextField, nicknameTextField, phoneNumberTextField, editButton)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(100)
            
            profileImageView.addSubview(cameraImage)
            cameraImage.snp.makeConstraints { make in
                make.size.equalTo(20)
                make.trailing.equalTo(profileImageView.snp.trailing)
                make.bottom.equalTo(profileImageView.snp.bottom)
            }
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(60)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(60)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(60)
        }
        
        phoneNumberTextField.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(60)
        }
        
        editButton.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberTextField.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(60)
        }
    }
    
    override func configureView() {
        super.configureView()
        
    }
}

extension EditProfileViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                if let image = image as? UIImage {
                    print("image있음")
                    self?.imageRelay.accept(image)
                } else {
                    print("image없음")
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: PHPickerViewController) {
        picker.dismiss(animated: true)
    }
}
