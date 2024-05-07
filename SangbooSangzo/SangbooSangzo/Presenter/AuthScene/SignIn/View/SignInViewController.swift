//
//  SignInViewController.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/15/24.
//

import UIKit

final class SignInViewController: RxBaseViewController {
    
    private let viewModel: SignInViewModel
    
    private let signInLabel = UILabel().then {
        $0.text = "회원 가입"
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 40, weight: .bold)
        $0.textColor = .tintColor
    }

    private let emailTextField = UITextField().then {
        $0.placeholder = "이메일을 입력해주세요"
        $0.borderStyle = .roundedRect
    }
    
    private let emailCheckButton = UIButton().then {
        $0.setTitle("중복체크", for: .normal)
        $0.backgroundColor = .tintColor
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
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
    
    private let signInButton = UIButton().then {
        $0.setTitle("회원가입", for: .normal)
        $0.setTitle("모든 항목을 입력해주세요", for: .disabled)
        $0.setTitleColor(.white, for: .normal)
        $0.setTitleColor(.lightGray, for: .disabled)
        $0.backgroundColor = .tintColor
        $0.isEnabled = false
    }
    
    init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func bind() {
        super.bind()
        
        let input = SignInViewModel.Input(email: emailTextField.rx.text.orEmpty,
                                          password: passwordTextField.rx.text.orEmpty,
                                          nickname: nicknameTextField.rx.text.orEmpty,
                                          phoneNumber: phoneNumberTextField.rx.text.orEmpty,
                                          emailCheckButtonTapped: emailCheckButton.rx.tap,
                                          signInButtonTapped: signInButton.rx.tap)
        let output = viewModel.transform(input)
        
        output.emailEnabled.drive(with: self) { owner, value in
            if value == false {
                owner.emailTextField.text = ""
            }
        }
        .disposed(by: disposeBag)
        
        output
            .buttonEnabled
            .drive(signInButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Helpers
    
    override func configureHierarchy() {
        super.configureHierarchy()
        view.addSubviews(signInLabel, emailTextField, emailCheckButton,
                         passwordTextField, nicknameTextField, phoneNumberTextField, signInButton)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        signInLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(100)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(signInLabel.snp.bottom).offset(80)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(60)
        }
        
        emailCheckButton.snp.makeConstraints { make in
            make.top.equalTo(signInLabel.snp.bottom).offset(80)
            make.leading.equalTo(emailTextField.snp.trailing).offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(60)
            make.width.equalTo(80)
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
        
        signInButton.snp.makeConstraints { make in
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
