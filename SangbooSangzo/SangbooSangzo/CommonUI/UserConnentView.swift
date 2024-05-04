//
//  UserConnectView.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 5/5/24.
//

import UIKit

import Kingfisher
import SnapKit

final class UserConnectView: BaseView {
    
    // MARK: - Properties

    lazy var profileImageView = UIImageView().then {
        $0.image = .ssUser
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
        $0.layer.borderColor = UIColor.accent.cgColor
        $0.layer.borderWidth = 2
    }
    
    private let userNicknameLabel = UILabel().then {
        $0.text = "닉네임"
        $0.font = SSFont.semiBold18
        $0.tintColor = .tintColor
    }
    
    lazy var inquiryStackView = UIStackView(arrangedSubviews: [phoneButton, messageButton]).then {
        $0.axis = .horizontal
        $0.spacing = 24
        $0.distribution = .fillEqually
    }
    
    let phoneButton = UIButton().then {
        $0.setTitleColor(.tintColor, for: .normal)
        $0.setImage(UIImage(systemName: "phone.fill"), for: .normal)
    }
    
    let messageButton = UIButton().then {
        $0.setTitleColor(.tintColor, for: .normal)
        $0.setImage(UIImage(systemName: "message.fill"), for: .normal)
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
        addSubviews(profileImageView, userNicknameLabel, inquiryStackView)
    }
    
    override func configureLayout() {
        super.configureLayout()
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(40)
        }
        
        userNicknameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
            make.trailing.lessThanOrEqualTo(inquiryStackView.snp.leading).offset(-8)
        }
        
        inquiryStackView.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalTo(80)
            make.height.equalTo(60)
            
        }
    }
    
    override func configureView() {
        super.configureView()
        self.backgroundColor = .second
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
    }
}
