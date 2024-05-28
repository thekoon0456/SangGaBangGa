//
//  DetailFeedViewController.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/19/24.
//

import MapKit
import MessageUI
import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Kingfisher

final class DetailFeedViewController: RxBaseViewController {
    
    // MARK: - Properties
    
    private let viewModel: DetailFeedViewModel
    private let baseView = DetailFeedView()
    private let ellipsisButton = UIButton().then {
        $0.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        $0.tintColor = .white
    }
    
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
        
        let heartButtonTapped = baseView.heartButton.rx.tap
            .withUnretained(self)
            .map { owner, _ in
                owner.baseView.heartButton.isSelected
            }
        
        let input = DetailFeedViewModel.Input(viewWillAppear: self.rx.viewWillAppear.map { _ in },
                                              heartButtonTapped: heartButtonTapped,
                                              commentButtonTapped: baseView.commentButton.rx.tap,
                                              phoneButtonTapped: baseView.userConnectView.phoneButton.rx.tap,
                                              paymentButtonTapped: baseView.paymentButton.rx.tap,
                                              ellipsisButtonTapped: ellipsisButton.rx.tap)
        let output = viewModel.transform(input)
        
        output.data.drive(with: self) { owner, data in
            owner.baseView.configureViewData(data)
            owner.baseView.layoutIfNeeded()
            owner.setAnnotation(coordinate: data.coordinate, title: data.address)
            owner.ellipsisButton.isHidden = data.creator.userID != UserDefaultsManager.shared.userData.userID
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
            .drive(with: self) { owner, data in
                owner.baseView.commentCountLabel.text = String(data.count)
            }
            .disposed(by: disposeBag)
        
        output
            .paymentDone
            .drive(with: self) { owner, _ in
                owner.baseView.setPaymentsButton(isEnable: false)
            }
            .disposed(by: disposeBag)
        
        baseView.userConnectView.messageButton.rx.tap
            .flatMap { output.data }
            .asDriver(onErrorJustReturn: ContentEntity.defaultData())
            .drive(with: self) { owner, data in
                let messageComposer = MFMessageComposeViewController()
                messageComposer.messageComposeDelegate = self
                if MFMessageComposeViewController.canSendText(){
                    messageComposer.recipients = [data.creator.phoneNum]
                    owner.present(messageComposer, animated: true, completion: nil)
                }
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Configure
    
    func setAnnotation(coordinate: String?, title: String) {
        guard let latitude = Double(coordinate?.components(separatedBy: " / ").first ?? ""),
              let longitude = Double(coordinate?.components(separatedBy: " / ").last ?? "")
        else { return }
        
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: ellipsisButton)
    }
}

// MARK: - Message

extension DetailFeedViewController: MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result {
        case MessageComposeResult.sent:
            print("전송 완료")
            break
        case MessageComposeResult.cancelled:
            print("취소")
            break
        case MessageComposeResult.failed:
            print("전송 실패")
            break
        default:
            print("error")
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }
}
