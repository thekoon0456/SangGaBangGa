//
//  LoginViewController.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/11/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class LoginViewController: RxBaseViewController {
    
    // MARK: - Properties
    
    private let viewModel: LoginViewModel
    
    private let appLabel = UILabel().then {
        $0.text = "상가방가"
        $0.textAlignment = .center
        $0.font = SSFont.bold28
        $0.textColor = .tintColor
    }

    private let emailTextField = UITextField().then {
        $0.placeholder = "이메일을 입력해주세요"
        $0.borderStyle = .roundedRect
    }
    
    private let passwordTextField = UITextField().then {
        $0.placeholder = "비밀번호를 입력해주세요"
        $0.isSecureTextEntry = true
        $0.borderStyle = .roundedRect
    }
    
    private let loginButton = UIButton().then {
        $0.backgroundColor = .tintColor
        $0.setTitle("로그인하기", for: .normal)
    }
    
    private let signInLabel = UILabel().then {
        $0.text = "아직 회원이 아니세요?"
        $0.font = SSFont.semiBold14
    }
    
    private let signInButton = UIButton().then {
        $0.setTitle("여기를 눌러 가입하기", for: .normal)
        $0.setTitleColor(.tintColor, for: .normal)
        $0.titleLabel?.font = SSFont.semiBold16
    }
    
    // MARK: - Lifecycles
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Helpers
    
    override func bind() {
        super.bind()
        
        let input = LoginViewModel.Input(email: emailTextField.rx.text.orEmpty,
                                         password: passwordTextField.rx.text.orEmpty,
                                         loginButtonTapped: loginButton.rx.tap,
                                         singInButtonTapped: signInButton.rx.tap)
        let output = viewModel.transform(input)
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        view.addSubviews(appLabel, emailTextField, passwordTextField, loginButton, signInLabel, signInButton)
    }
    
    override func configureLayout() {
        super.configureLayout()
        appLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(100)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(appLabel.snp.bottom).offset(80)
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
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(60)
        }
        
        signInLabel.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(40)
        }
        
        signInButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(20)
            make.leading.equalTo(signInLabel.snp.trailing).offset(20)
            make.height.equalTo(40)
        }
    }
    
    override func configureView() {
        super.configureView()
    }
}
