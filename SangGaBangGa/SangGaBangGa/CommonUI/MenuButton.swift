//
//  MenuButton.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/18/24.
//

import UIKit

import RxCocoa
import RxSwift

final class SSMenuButton: UIButton {
    
    var menuButtonRelay = BehaviorRelay<String?>(value: nil)
    let buttonLabel = UILabel().then {
        $0.font = SSFont.medium12
    }
    let chevronImageView = UIImageView().then {
        $0.image = UIImage(systemName: "chevron.down")
    }
    
    let disposeBag = DisposeBag()
    
    // MARK: - Lifecycles
    
    init(buttonTitle: String, menus: [String]) {
        super.init(frame: .zero)
        configureUI(buttonTitle: buttonTitle, menus: menus)
        
        menuButtonRelay
            .subscribe(with: self) { owner, title in
                guard let title else { return }
                owner.buttonLabel.text = title
            }.disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    // TODO: - 폰트?
    private func configureUI(buttonTitle: String, menus: [String]) {
        buttonLabel.text = buttonTitle
        tintColor = .accent
        layer.cornerRadius = 10
        clipsToBounds = true
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.accent.cgColor
        showsMenuAsPrimaryAction = true
        addSubviews(buttonLabel, chevronImageView)
        backgroundColor = .second
        
        let menus: [String]  = menus
        
        menu = UIMenu(children: menus.map { title in
            UIAction(title: title) { [weak self] _ in
                guard let self else { return }
                menuButtonRelay.accept(title)
            }
        })
        
        buttonLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        chevronImageView.snp.makeConstraints { make in
            make.leading.equalTo(buttonLabel.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }
}
