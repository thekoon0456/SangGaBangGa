//
//  DetailUserInfoView.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/21/24.
//

import UIKit

import Kingfisher
import SnapKit

final class UserProfileView: BaseView {
    
    // MARK: - Properties

    lazy var profileImageView = UIImageView().then {
        $0.image = .ssUser
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 30
        $0.clipsToBounds = true
        $0.layer.borderColor = UIColor.accent.cgColor
        $0.layer.borderWidth = 2
    }
    
    private let userNicknameLabel = UILabel().then {
        $0.text = "닉네임"
        $0.font = SSFont.semiBold18
        $0.tintColor = .tintColor
    }
    
    // MARK: - Helpers
    
    func setValues(nick: String?, imageURL: String?) {
        userNicknameLabel.text = nick ?? "닉네임을 설정해주세요"
        guard let profileURL = imageURL else {
            profileImageView.image = .ssUser
            return
        }
        profileImageView.kf.setSeSACImage(input: APIKey.baseURL + "/v1/" + profileURL)
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        addSubviews(profileImageView, userNicknameLabel)
    }
    
    override func configureLayout() {
        super.configureLayout()
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
            make.size.equalTo(60)
        }
        
        userNicknameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
            make.trailing.lessThanOrEqualToSuperview().offset(-8)
        }
    }
    
    override func configureView() {
        super.configureView()
//        self.layer.borderWidth = 1
//        self.layer.borderColor = UIColor.accent.cgColor
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
    }
}
