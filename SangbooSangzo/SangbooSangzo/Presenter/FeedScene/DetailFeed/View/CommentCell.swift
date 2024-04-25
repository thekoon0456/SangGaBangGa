//
//  CommentCell.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/24/24.
//

import UIKit

final class CommentCell: BaseTableViewCell {
    
    // MARK: - Properties
    
    private lazy var profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = true
    }
    
    private let userNicknameLabel = UILabel().then {
        $0.font = SSFont.filterRegular
        $0.textColor = .systemGray
    }
    
    private let commentLabel = UILabel().then {
        $0.font = SSFont.titleRegular
        $0.numberOfLines = 0
    }
    
    // MARK: - Helpers
    
    func configureCell(data: PostCommentResponse) {
        userNicknameLabel.text = data.creator.nick
        commentLabel.text = data.content
        guard let profileURL = data.creator.profileImage else {
            profileImageView.image = UIImage(named: "person.fill")
            return
        }
        profileImageView.kf.setSeSACImage(input: APIKey.baseURL + "/v1/" + profileURL)
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        addSubviews(profileImageView, userNicknameLabel, commentLabel)
    }
    
    override func configureLayout() {
        super.configureLayout()
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(40)
        }
        
        userNicknameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview()
        }
        
        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(userNicknameLabel.snp.bottom).offset(4)
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(-4)
        }
    }
    
    override func configureView() {
        super.configureView()
        
    }
}
