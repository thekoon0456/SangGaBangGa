//
//  PostImageCell.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/19/24.
//

import UIKit

import SnapKit

final class PostImageCell: RxBaseCollectionViewCell {
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
    func configureCell(image: UIImage) {
        imageView.image = image
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        contentView.addSubview(imageView)
    }
    
    override func configureLayout() {
        super.configureLayout()
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        super.configureView()
        
    }
}
