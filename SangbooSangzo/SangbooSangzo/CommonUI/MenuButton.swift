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
    let chevronImage = UIImage(systemName: "chevron.down")
    let disposeBag = DisposeBag()
    
    // MARK: - Lifecycles
    
    init(buttonTitle: String, menus: [String]) {
        super.init(frame: .zero)
        configureUI(buttonTitle: buttonTitle, menus: menus)
        
        menuButtonRelay.subscribe(with: self) { owner, title in
            guard let title else { return }
            owner.setTitle(title, for: .normal)
        }.disposed(by: disposeBag)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    // TODO: - 폰트?
    private func configureUI(buttonTitle: String, menus: [String]) {
        setTitle(buttonTitle, for: .normal)
        setTitleColor(.label, for: .normal)
        tintColor = .tintColor
        layer.cornerRadius = 10
        clipsToBounds = true
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.systemGray.cgColor
        showsMenuAsPrimaryAction = true
        
        let menus: [String]  = menus
        
        menu = UIMenu(children: menus.map { title in
            UIAction(title: title) { [weak self] _ in
                guard let self else { return }
                menuButtonRelay.accept(title)
            }
        })
        
        if let titleLabel = titleLabel {
            titleLabel.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(16)
                make.centerY.equalToSuperview()
            }
        }
        
        // Add the chevronImage directly to the button
        if let chevronImage = chevronImage {
            let chevronImageView = UIImageView(image: chevronImage)
            addSubview(chevronImageView)
            chevronImageView.snp.makeConstraints { make in
                make.trailing.equalToSuperview().offset(-16)
                make.centerY.equalToSuperview()
            }
        }
    }
}
