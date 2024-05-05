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
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, ContentEntity>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ContentEntity>
    
    private let viewModel: FeedViewModel
    private var dataSource: DataSource?
    
    private let titleView = TitleView()
    
    private lazy var collectionView = UICollectionView(frame: .zero,
                                                       collectionViewLayout: createLayout()).then {
        $0.register(MainFeedCell.self, forCellWithReuseIdentifier: MainFeedCell.identifier)
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
        
        configureDataSource()
        configureSnapshot()
    }
    
    override func bind() {
        super.bind()
        
        let fetchContents = collectionView.rx.prefetchItems
            .compactMap { $0.last?.item }
        
        let input = FeedViewModel.Input(viewWillAppear: self.rx.viewWillAppear.map { _ in },
                                        cellSelected: collectionView.rx.itemSelected,
                                        addButtonTapped: addButton.rx.tap,
                                        fetchContents: fetchContents)
        
        let output = viewModel.transform(input)
        
        output
            .feeds
            .drive(with: self) { owner, item in
                owner.updateSnapshot(withItems: item, toSection: .feed)
            }
            .disposed(by: disposeBag)
        
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        view.addSubviews(collectionView, addButton)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        addButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.size.equalTo(56)
        }
    }
    
    override func configureView() {
        super.configureView()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleView)
        navigationItem.title = ""
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.8))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 16
            return section
        }
    }
}

extension FeedViewController {
    
    enum Section: Int, CaseIterable {
        case feed
    }
    
    private func feedCellRegistration() -> UICollectionView.CellRegistration<MainFeedCell, ContentEntity> {
        UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            cell.configureCellData(itemIdentifier)
        }
    }
    
    private func configureDataSource() {
        let feedCellRegistration = feedCellRegistration()
        
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            guard let section = Section(rawValue: indexPath.section) else { return UICollectionViewCell() }
            switch section {
            case .feed:
                let cell = collectionView.dequeueConfiguredReusableCell(using: feedCellRegistration, for: indexPath, item: itemIdentifier)
                return cell
            }
        }
    }
    
    private func configureSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        dataSource?.apply(snapshot)
    }
    
    private func updateSnapshot(withItems items: [ContentEntity], toSection section: Section) {
        guard var snapshot = dataSource?.snapshot() else { return }
        
        if snapshot.sectionIdentifiers.contains(section) {
            snapshot.deleteItems(snapshot.itemIdentifiers(inSection: section))
        }
        
        snapshot.appendItems(items, toSection: section)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}
