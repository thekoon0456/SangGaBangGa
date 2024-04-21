//
//  InfoViewController.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/15/24.
//

import UIKit

final class InfoViewController: RxBaseViewController {
    
    private let viewModel: InfoViewModel
    
    private let detailUserInfoView = DetailUserInfoView()
    
    init(viewModel: InfoViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func bind() {
        super.bind()
        
        let input = InfoViewModel.Input(viewWillAppear: self.rx.viewWillAppear.map { _ in })
        let output = viewModel.transform(input)
        
        output
            .userProfile
            .drive(with: self) { owner, value in
                print(value)
                owner.detailUserInfoView.setValues(user: value)
            }
            .disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        view.addSubviews(detailUserInfoView)
    }
    
    override func configureLayout() {
        super.configureLayout()
        detailUserInfoView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(64)
        }
    }
    
    override func configureView() {
        super.configureView()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "마이페이지"
    }
}
