//
//  Toast.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/16/24.
//

import UIKit

enum Toast {
    case loginFail
    
    case emailValidation(email: String)
    case emailValidationFail(email: String)
    
    var message: String {
        switch self {
        case .loginFail:
            "유효하지 않은 회원정보입니다. 회원가입을 진행해주세요."
        case .emailValidation(let email):
            "\(email)은 사용 가능합니다."
        case .emailValidationFail(let email):
            "\(email)은 이미 가입된 이메일입니다."
        }
    }
}

final class ToastViewController: RxBaseViewController {
    
    // MARK: - Properties
    
    private let inputMessage: String
    private let messageLabel = PaddingLabel().then {
        $0.font = .boldSystemFont(ofSize: 20)
        $0.textColor = .white
        $0.textAlignment = .center
        $0.adjustsFontSizeToFitWidth = true
        $0.numberOfLines = 0
        $0.padding = .init(top: 12, left: 12, bottom: 12, right: 12)
        $0.backgroundColor = .tintColor
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }
    
    // MARK: - Helpers
    
    init(inputMessage: String) {
        self.inputMessage = inputMessage
        super.init()
    }
    
    // MARK: - Helpers
    
    override func configureHierarchy() {
        view.addSubview(messageLabel)
    }
    
    override func configureLayout() {
        messageLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-48)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-100)
        }
    }
    
    override func configureView() {
        view.backgroundColor = .clear
        messageLabel.text = inputMessage
    }
}

final class PaddingLabel: UILabel {
    
    var padding = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right

        return contentSize
    }
}
