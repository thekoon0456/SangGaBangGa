//
//  BackgroundView.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 5/5/24.
//

import UIKit

import SnapKit
import Then

final class EmptySSView: BaseView {
    
    //각 case에 따른 멘트
    enum SettingTitle: String {
        case like = "좋아요 누른 글이"
        case written = "작성한 글이"
        case payments = "계약금을 입금한 글이"
    }
    
    // MARK: - Properties
    
    private let emptyLabel = UILabel().then {
        $0.text = "아직 신청한 글이 없어요!"
        $0.textAlignment = .center
        $0.font = SSFont.semiBold16
        $0.textColor = .systemGray
    }
    
    private let iconImageView = UIImageView().then {
        $0.image = SSIcon.icon?.withTintColor(.second, renderingMode: .alwaysOriginal)
        $0.contentMode = .scaleAspectFill
    }
    
    // MARK: - Lifecycles
    
    init(frame: CGRect = .zero, type: SettingTitle) {
        super.init(frame: frame)
        
        configureUI()
        setEmptyViewTitle(type)
    }
    
    // MARK: - Helpers
    
    private func setEmptyViewTitle(_ type: SettingTitle) {
        emptyLabel.text = "아직 \(type.rawValue) 없어요!"
    }
    
    private func configureUI() {
        addSubviews(emptyLabel,
                    iconImageView)
        
        iconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(105)
            make.height.equalTo(50)
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(iconImageView.snp.bottom).offset(40)
        }
    }
}
