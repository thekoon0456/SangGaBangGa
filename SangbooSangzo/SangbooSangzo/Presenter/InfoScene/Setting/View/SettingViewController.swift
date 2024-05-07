//
//  SettingViewController.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/23/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class SettingViewController: RxBaseViewController {
    
    let viewModel: SettingViewModel
    
    private let tableView = UITableView().then {
        $0.register(SettingCell.self, forCellReuseIdentifier: SettingCell.identifier)
    }
    
    init(viewModel: SettingViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func bind() {
        super.bind()
        
        let input = SettingViewModel.Input(viewWillAppear: self.rx.viewWillAppear.map { _ in },
                                           cellSelected: tableView.rx.itemSelected)
        let output = viewModel.transform(input)
        
        output
            .settingList
            .drive(tableView.rx.items(cellIdentifier: SettingCell.identifier,
                                      cellType: SettingCell.self)) { row, element, cell in
                cell.configureCell(data: element)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .asDriver()
            .drive(with: self) { owner, indexPath in
                owner.tableView.deselectRow(at: indexPath, animated: true)
        }
        .disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        view.addSubviews(tableView)
    }
    
    override func configureLayout() {
        super.configureLayout()
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        super.configureView()
        navigationItem.title = "설정"
    }
}
