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
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, UploadContentResponse>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, UploadContentResponse>
    
    private let viewModel: FeedViewModel
    private var dataSource: DataSource?
    
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

        //        configureDataSource()
        //        configureSnapshot()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "피드"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.title = ""
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func bind() {
        super.bind()
        
        let input = FeedViewModel.Input(viewDidLoad: self.rx.viewDidLoad,
                                        viewWillAppear: self.rx.viewWillAppear.map { _ in },
                                        cellSelected: collectionView.rx.modelSelected(UploadContentResponse.self),
                                        addButtonTapped: addButton.rx.tap)
        let output = viewModel.transform(input)
        
        output
            .feeds
            .drive(collectionView.rx.items(cellIdentifier: FeedCell.identifier, cellType: FeedCell.self)) { item , element, cell in
                cell.configureCellData(element)
                print(element)
            }
            .disposed(by: disposeBag)
        
        //        output
        //            .feeds
        //            .drive(with: self) { owner, item in
        //                owner.updateSnapshot(withItems: item, toSection: .feed)
        //            }
        //            .disposed(by: disposeBag)
        
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
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            // MARK: - 높이 계산해서 고정값 주기
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(300))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(300))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
            
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
    
    private func feedCellRegistration() -> UICollectionView.CellRegistration<FeedCell, UploadContentResponse> {
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
        let snapshot = Snapshot().then {
            $0.appendSections(Section.allCases)
        }
        dataSource?.apply(snapshot)
    }
    
    private func updateSnapshot(withItems items: [UploadContentResponse], toSection section: Section) {
        var snapshot = dataSource?.snapshot() ?? Snapshot()
        snapshot.appendItems(items, toSection: section)
        dataSource?.apply(snapshot)
    }
}
