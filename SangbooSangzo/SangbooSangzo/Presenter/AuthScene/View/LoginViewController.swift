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
        $0.text = "상부상조"
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 40, weight: .bold)
        $0.textColor = .tintColor
    }
    
    private let xButton = UIButton().then {
        let image = UIImage(systemName: "xmark")?
            .withConfiguration(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 20)))
        $0.setImage(image, for: .normal)
        $0.tintColor = .tintColor
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
    
    // MARK: - Lifecycles
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDismissGesture()
    }
    
    // MARK: - Helpers
    
    override func bind() {
        super.bind()
        
        let loginObservable = Observable.zip(emailTextField.rx.text.orEmpty,
                                             passwordTextField.rx.text.orEmpty)
            .map { email, password in
                LoginRequest(email: email, password: password)
            }
        
        xButton.rx.tap.subscribe(with: self) { owner, _ in
            owner.dismiss(animated: true)
        }
        .disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        view.addSubviews(appLabel, emailTextField, passwordTextField)
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
    }
    
    override func configureView() {
        super.configureView()
        navigationItem.title = "Login"
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: xButton)
    }
}

extension LoginViewController {
    
    func setDismissGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(dismissGesture))
        view.addGestureRecognizer(panGesture)
    }
    
    // 팬 제스처를 처리하는 메소드
    @objc func dismissGesture(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        switch sender.state {
        case .changed:
            if translation.y > 0 {
                view.transform = CGAffineTransform(translationX: 0, y: translation.y)
            }
            break
        case .ended:
            if translation.y > 100 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
                }) { [weak self] _ in
                    guard let self else { return }
                    dismiss(animated: true)
                }
            } else {
                UIView.animate(withDuration: 0.3) { [weak self] in
                    guard let self else { return }
                    view.transform = .identity
                }
            }
        default:
            break
        }
    }
}
