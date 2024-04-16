//
//  FeedViewController.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/15/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class FeedViewController: RxBaseViewController {
    
    // MARK: - Properties
    
    private let viewModel: FeedViewModel
    
    private lazy var collectionView = UICollectionView(frame: .zero,
                                                  collectionViewLayout: createLayout()).then {
        $0.register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.identifier)
    }
    
    private lazy var addButton = UIButton().then {
        let image = UIImage(systemName: "plus")?.withTintColor(.white)
            .withRenderingMode(.alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 24, weight: .bold)))
        $0.setImage(image, for: .normal)
        $0.backgroundColor = .tintColor
        $0.layer.cornerRadius = 56 / 2
        $0.clipsToBounds = true
    }
    
    // MARK: - Lifecycles
    
    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.coordinator?.presentLoginScene()
    }
    
    override func bind() {
        super.bind()
        
        let input = FeedViewModel.Input(addButtonTapped: addButton.rx.tap)
        let output = viewModel.transform(input)
        
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        view.addSubviews(collectionView, addButton)
    }
    
    override func configureLayout() {
        super.configureLayout()
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        addButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.size.equalTo(56)
        }
    }
    
    override func configureView() {
        super.configureView()
        navigationItem.title = "피드"
    }
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
             let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .estimated(100))
             let item = NSCollectionLayoutItem(layoutSize: itemSize)
             item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

             let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(200))
             let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)

             let section = NSCollectionLayoutSection(group: group)
             return section
         }
    }
}
