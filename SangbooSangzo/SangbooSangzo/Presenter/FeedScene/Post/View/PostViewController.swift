//
//  PostViewController.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/16/24.
//

import UIKit

import RxCocoa
import RxSwift

final class PostViewController: RxBaseViewController {
    
    private let viewModel: PostViewModel
    
    init(viewModel: PostViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
    }
    
    override func configureLayout() {
        super.configureLayout()
        
    }
    
    override func configureView() {
        super.configureView()
        navigationItem.title = "게시글 작성하기"
    }
    
    
}
