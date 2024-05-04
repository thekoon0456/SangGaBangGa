//
//  TitleView.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 5/3/24.
//

import UIKit

import SnapKit

final class TitleView: BaseView {
    
    private let titleLabel = UILabel().then {
        $0.text = "상가방가"
        $0.font = SSFont.bold28
        $0.textColor = .tintColor
    }
    
    private let iconImageView = UIImageView().then {
        $0.image = SSIcon.icon
        $0.contentMode = .scaleAspectFill
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        addSubviews(iconImageView, titleLabel)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.size.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(iconImageView.snp.centerY)
            make.leading.equalTo(iconImageView.snp.trailing).offset(6)
        }
    }
    
    override func configureView() {
        super.configureView()
    }
}
