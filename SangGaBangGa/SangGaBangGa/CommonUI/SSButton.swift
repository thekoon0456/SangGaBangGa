//
//  SSButton.swift
//  SangGaBangGa
//
//  Created by Deokhun KIM on 5/15/24.
//

import UIKit

final class SSButton: UIButton {

    // MARK: - Lifecycles
    
    init(buttonTitle: String, color: UIColor = .accent) {
        super.init(frame: .zero)
        configureUI(buttonTitle: buttonTitle, color: color)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI(buttonTitle: String, color: UIColor) {
        setTitle(buttonTitle, for: .normal)
        setTitleColor(.label, for: .normal)
        setTitleColor(.white, for: .selected)
        titleLabel?.font = SSFont.medium12
        layer.cornerRadius = 10
        clipsToBounds = true
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.accent.cgColor
        backgroundColor = .second
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}
