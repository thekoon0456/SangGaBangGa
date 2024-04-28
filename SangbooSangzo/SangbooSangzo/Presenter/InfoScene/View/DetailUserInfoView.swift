//
//  DetailUserInfoView.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/21/24.
//

import UIKit

import Kingfisher
import SnapKit

final class DetailUserInfoView: BaseView {
    
    // MARK: - Properties
    
    //설정버튼 카메라
    private lazy var cameraImage = UIImageView(image: UIImage(systemName: "camera"))
    
    lazy var profileImageView = UIImageView().then {
        $0.image = .ssUser
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
        $0.layer.borderColor = UIColor.systemGray.cgColor
        $0.layer.borderWidth = 1
        $0.isUserInteractionEnabled = true
    }
    
    private let userNicknameLabel = UILabel().then {
        $0.text = "닉네임"
        $0.font = SSFont.titleRegular
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
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(30)
        }
        
        userNicknameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView.snp.centerY)
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview()
        }
    }
    
    override func configureView() {
        super.configureView()
    }
}
