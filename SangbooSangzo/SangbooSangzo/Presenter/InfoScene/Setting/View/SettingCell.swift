//
//  SettingCell.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/23/24.
//

import UIKit

import RxSwift
import RxCocoa

final class SettingCell: BaseTableViewCell {
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    private var titleLabel = UILabel().then {
        $0.font = SSFont.text
    }
    
    // MARK: - Helpers
    
    func configureCell(data: String) {
        titleLabel.text = data
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        contentView.addSubviews(titleLabel)
    }
    
    override func configureLayout() {
        super.configureLayout()
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
    }
    
    override func configureView() {
        super.configureView()
    }
}
