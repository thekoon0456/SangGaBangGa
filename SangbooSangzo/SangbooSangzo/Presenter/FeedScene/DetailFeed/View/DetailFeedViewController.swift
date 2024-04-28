//
//  DetailFeedViewController.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/19/24.
//

import MapKit
import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Kingfisher

final class DetailFeedViewController: RxBaseViewController {
    
    private let viewModel: DetailFeedViewModel
    
    private let baseView = DetailFeedView()
    
    // MARK: - Lifecycles

    init(viewModel: DetailFeedViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func loadView() {
        super.loadView()
        self.view = baseView
    }
    
    // MARK: - Bind
    
    override func bind() {
        super.bind()
        let heartButtonTapped = baseView.heartButton.rx.tap.map { [weak self] in
            guard let self else { return false }
            return baseView.heartButton.isSelected
        }
        
        let commentSendButtonTapped = baseView.sendButton.rx.tap.withLatestFrom(baseView.commentTextField.rx.text.orEmpty)
        
        let input = DetailFeedViewModel.Input(viewWillAppear: self.rx.viewWillAppear.map { _ in },
                                              heartButtonTapped: heartButtonTapped,
                                              commentSendButtonTapped: commentSendButtonTapped)
        let output = viewModel.transform(input)
        
        output.data.drive(with: self) { owner, data in
            owner.baseView.titleLabel.text = data.title
            owner.baseView.contentLabel.text = data.content
            owner.baseView.categoryLabel.text = data.category
            owner.baseView.addressLabel.text = data.address
            owner.baseView.priceLabel.text = data.price
            owner.baseView.spaceLabel.text = data.space
            //            owner.profileView.setValues(nick: data.creator.nick, imageURL: data.creator.profileImage)
            //            owner.commentCountLabel.text = String(data.comments.count)
            
            owner.baseView.imageScrollView.imageViews = data.files.map {
                let imageView = UIImageView()
                imageView.kf.setSeSACImage(input: APIKey.baseURL + "/v1/" + $0)
                return imageView
            }
            
            owner.baseView.heartCountLabel.text = String(data.likes.count)
            owner.baseView.heartButton.isSelected = data.likes.contains { $0 == UserDefaultsManager.shared.userData.userID }
            
            owner.setAnnotaion(coordinate: data.coordinate, title: "상가 위치")
        }
        .disposed(by: disposeBag)
        
        
        
        output
            .heartButtonStatus
            .drive(baseView.heartButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        output
            .heartCount
            .drive(baseView.heartCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        output
            .comments
            .drive(baseView.commentsTableView.rx.items(cellIdentifier: CommentCell.identifier, cellType: CommentCell.self)) { row, element, cell in
                cell.configureCell(data: element)
            }
            .disposed(by: disposeBag)
        
        output
            .comments
            .drive(with: self) { owner, data in
                owner.baseView.heightConstraint?.update(offset: owner.baseView.commentsTableView.contentSize.height)
                //                owner.commentsTableView.layoutIfNeeded()
                owner.baseView.commentCountLabel.text = String(data.count)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Configure
    
    func setAnnotaion(coordinate: String?, title: String) {
        guard let latitude = Double(coordinate?.components(separatedBy: " / ").first ?? ""),
              let longitude = Double(coordinate?.components(separatedBy: " / ").last ?? "") else { return }
        print(latitude, longitude)
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        
        baseView.mapView.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(center: coordinate,
                                        latitudinalMeters: 100,
                                        longitudinalMeters: 100)
        baseView.mapView.setRegion(region, animated: true)
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
    }
    
    override func configureLayout() {
        super.configureLayout()
    }
    
    override func configureView() {
        super.configureView()
    }
}
