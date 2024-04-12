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
    
    private let emailTextField = UITextField().then {
        $0.placeholder = "이메일을 입력해주세요"
    }
    
    private let passwordTextField = UITextField().then {
        $0.placeholder = "비밀번호를 입력해주세요"
        $0.isSecureTextEntry = true
    }

    override func bind() {
        super.bind()
        
        let loginObservable = Observable.zip(emailTextField.rx.text.orEmpty,
                                   passwordTextField.rx.text.orEmpty)
            .map { email, password in
                LoginRequest(email: email, password: password)
            }
        loginObservable
            .take(1)
            .subscribe
        
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        view.addSubviews(emailTextField, passwordTextField)
    }
    
    override func configureLayout() {
        super.configureLayout()
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.leading.equalToSuperview().offset(-20)
            make.trailing.equalToSuperview().offset(20)
            make.height.equalTo(60)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(-20)
            make.trailing.equalToSuperview().offset(20)
            make.height.equalTo(60)
        }
    }
    
    override func configureView() {
        super.configureView()
    }
    
}
