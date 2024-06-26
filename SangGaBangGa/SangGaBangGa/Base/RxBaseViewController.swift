//
//  RxBaseViewController.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/10/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

class RxBaseViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    func bind() { }
    func configureHierarchy() { }
    func configureLayout() { }
    func configureView() {
        view.backgroundColor = .white
        navigationItem.backButtonDisplayMode = .minimal
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
