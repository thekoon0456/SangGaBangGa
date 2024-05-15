//
//  BaseCollectionViewCell.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/10/24.
//

import UIKit

import RxSwift

class RxBaseCollectionViewCell: UICollectionViewCell {
    
    var disposeBag = DisposeBag()
    
    static var identifier: String {
        return self.description()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bind()
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    func bind() { }
    func configureHierarchy() { }
    func configureLayout() { }
    func configureView() { }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
