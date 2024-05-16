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
    
    private let cellHeartButtonSubject = PublishSubject<(Int, Bool)>()
    private let cellCommentButtonSubject = PublishSubject<Int>()
    
    // MARK: - UI
    
    private let titleView = TitleView()
    
    private let filterScrollView = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
    }
    
    private lazy var optionStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 8
        $0.addArrangedSubviews(regionFilterButton, allButton, emptyButton, cafeButton, foodButton, etcButton)
    }
    
    private let regionFilterButton = SSMenuButton(buttonTitle: "모든 지역",
                                                  menus: ["모든 지역", "서울", "인천", "부산", "대구", "울산",
                                                          "대전", "광주", "세종특별자치시","경기", "강원특별자치도",
                                                          "충북", "충남", "경북", "경남", "전북", "전남", "제주특별자치도"])
    
    private let allButton = SSButton(buttonTitle: "모두")
    private let emptyButton = SSButton(buttonTitle: "공실")
    private let cafeButton = SSButton(buttonTitle: "카페")
    private let foodButton = SSButton(buttonTitle: "음식점")
    private let etcButton = SSButton(buttonTitle: "기타")
    
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
        let filterHashTag = BehaviorRelay<String?>(value: nil)
        
        let input = FeedViewModel.Input(viewWillAppear: self.rx.viewWillAppear.map { _ in },
                                        cellSelected: collectionView.rx.itemSelected,
                                        addButtonTapped: addButton.rx.tap,
                                        fetchContents: fetchContents,
                                        cellHeartButtonTapped: cellHeartButtonSubject.asObservable(),
                                        cellCommentButtonTapped: cellCommentButtonSubject.asObservable(),
                                        filterHashTag: filterHashTag.asObservable())
        
        let output = viewModel.transform(input)
        
        output
            .feeds
            .drive(with: self) { owner, item in
                owner.updateSnapshot(withItems: item, toSection: .feed)
            }
            .disposed(by: disposeBag)
        
        regionFilterButton.menuButtonRelay
            .map { [weak self] _ in
                guard let self else { return nil }
                return regionFilterButton.buttonLabel.text
            }
            .subscribe { value in
                filterHashTag.accept(value)
            }
            .disposed(by: disposeBag)
        
        allButton.rx.tap
            .map { [weak self] _ in
                guard let self else { return nil }
                return allButton.titleLabel?.text
            }
            .subscribe { value in
                filterHashTag.accept(value)
            }
            .disposed(by: disposeBag)
        
        emptyButton.rx.tap
            .map { [weak self] _ in
                guard let self else { return nil }
                return emptyButton.titleLabel?.text
            }
            .subscribe { value in
                filterHashTag.accept(value)
            }
            .disposed(by: disposeBag)

        
        cafeButton.rx.tap
            .map { [weak self] _ in
                guard let self else { return nil }
                return cafeButton.titleLabel?.text
            }
            .subscribe { value in
                filterHashTag.accept(value)
            }
            .disposed(by: disposeBag)

        
        foodButton.rx.tap
            .map { [weak self] _ in
                guard let self else { return nil }
                return foodButton.titleLabel?.text
            }
            .subscribe { value in
                filterHashTag.accept(value)
            }
            .disposed(by: disposeBag)
        
        etcButton.rx.tap
            .map { [weak self] _ in
                guard let self else { return nil }
                return etcButton.titleLabel?.text
            }
            .subscribe { value in
                filterHashTag.accept(value)
            }
            .disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        view.addSubview(filterScrollView)
        filterScrollView.addSubview(optionStackView)
        view.addSubviews(collectionView, addButton)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        filterScrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(40)
        }
        
        optionStackView.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(filterScrollView.snp.bottom)
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
            
            cell.heartButtonTapped = { [weak self] in
                guard let self else { return }
                let isSelected = itemIdentifier.likes.contains(UserDefaultsManager.shared.userData.userID ?? "") ? true : false
                cellHeartButtonSubject.onNext((indexPath.item, isSelected))
            }
            
            cell.commentButtonTapped = { [weak self] in
                guard let self else { return }
                cellCommentButtonSubject.onNext(indexPath.item)
            }
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
