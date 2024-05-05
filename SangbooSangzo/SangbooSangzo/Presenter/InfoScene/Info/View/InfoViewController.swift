//
//  InfoViewController.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/15/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class InfoViewController: RxBaseViewController {
    
    private let viewModel: InfoViewModel
    
    // MARK: - UI
    
    private let detailUserInfoView = UserProfileView()
    
    private let titleView = TitleView().then {
        $0.configureView(title: "마이페이지")
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.identifier)
    }
    
    private lazy var segmentContainerView = UIView().then {
        $0.backgroundColor = .systemBackground
        $0.addSubviews(titleSegment, underLineView)
    }
    
    private lazy var titleSegment = UISegmentedControl().then {
        $0.selectedSegmentTintColor = .clear
        $0.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        $0.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        $0.insertSegment(withTitle: "좋아요 한 글", at: 0, animated: true)
        $0.insertSegment(withTitle: "내가 작성한 글", at: 1, animated: true)
        $0.insertSegment(withTitle: "계약금 입금한 글", at: 2, animated: true)
        let segWidth = UIScreen.main.bounds.width / 3
        $0.setWidth(segWidth, forSegmentAt: 0)
        $0.setWidth(segWidth, forSegmentAt: 1)
        $0.setWidth(segWidth, forSegmentAt: 2)
        $0.selectedSegmentIndex = 0
        $0.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.systemGray,
            NSAttributedString.Key.font: SSFont.semiBold16 as Any
        ], for: .normal)
        
        $0.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.label,
            NSAttributedString.Key.font: SSFont.semiBold16 as Any], for: .selected)
    }
    
    private lazy var underLineView = UIView().then {
        $0.backgroundColor = UIColor.systemGray
    }
    
    private let settingButton = UIButton().then {
        $0.setImage(.ssSetting, for: .normal)
        $0.tintColor = .tintColor
    }
    
    init(viewModel: InfoViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func bind() {
        super.bind()
        
        let input = InfoViewModel.Input(viewWillAppear: self.rx.viewWillAppear.map { _ in },
                                        segmentTapped: titleSegment.rx.value,
                                        settingTapped: settingButton.rx.tap,
                                        cellTapped: collectionView.rx.modelSelected(ContentEntity.self))
        let output = viewModel.transform(input)
        
        output
            .userProfile
            .drive(with: self) { owner, value in
                owner.detailUserInfoView.setValues(nick: value.nick, imageURL: value.profileImage)
            }
            .disposed(by: disposeBag)
        
        output
            .underBarIndex
            .drive(with: self) { owner, index in
                owner.updateUnderlinePosition(index: index)
            }
            .disposed(by: disposeBag)
        
        output
            .feeds
            .drive(collectionView.rx.items(cellIdentifier: FeedCell.identifier, cellType: FeedCell.self)) { item , element, cell in
                cell.configureCellData(element)
            }
            .disposed(by: disposeBag)
        
        output
            .feeds
            .drive(with: self) { owner, value in
                let index = owner.titleSegment.selectedSegmentIndex
                switch index {
                case 0:
                    owner.collectionView.backgroundView = value.count == 0 ? EmptySSView(type: .like) : nil
                case 1:
                    owner.collectionView.backgroundView = value.count == 0 ? EmptySSView(type: .written) : nil
                default:
                    owner.collectionView.backgroundView = value.count == 0 ? EmptySSView(type: .payments) : nil
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func updateUnderlinePosition(index: Int) {
        let segmentWidth = titleSegment.widthForSegment(at: index)
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            self.underLineView.frame.origin.x = self.titleSegment.frame.origin.x + CGFloat(index) * segmentWidth
            self.underLineView.frame.size.width = segmentWidth
        }
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
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
    
    // MARK: - Configure
    
    override func configureHierarchy() {
        super.configureHierarchy()
        view.addSubviews(detailUserInfoView, segmentContainerView, collectionView, settingButton)
    }
    
    override func configureLayout() {
        super.configureLayout()
        detailUserInfoView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.height.equalTo(72)
        }
        
        settingButton.snp.makeConstraints { make in
            make.centerY.equalTo(detailUserInfoView)
            make.trailing.equalToSuperview().offset(-16)
            make.size.equalTo(48)
        }
        
        segmentContainerView.snp.makeConstraints { make in
            make.top.equalTo(detailUserInfoView.snp.bottom).offset(8)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
        }
        
        titleSegment.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        underLineView.snp.makeConstraints { make in
            make.top.equalTo(titleSegment.snp.bottom).offset(2)
            make.height.equalTo(2)
            make.width.equalTo(titleSegment.widthForSegment(at: 0))
            make.centerX.equalTo(titleSegment.snp.leading).offset(titleSegment.widthForSegment(at: 0) / 2)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(segmentContainerView.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        super.configureView()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleView)
    }
}

struct SectionModel {
    let title: String
    let items: [UploadContentResponse]
}
