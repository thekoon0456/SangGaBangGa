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
         
        let paymentButtonTapped = baseView.paymentView.rx
            .tapGesture()
            .when(.recognized)
            .map { _ in }
        
        let input = DetailFeedViewModel.Input(viewWillAppear: self.rx.viewWillAppear.map { _ in },
                                              heartButtonTapped: heartButtonTapped,
                                              commentButtonTapped: baseView.commentButton.rx.tap,
                                              phoneButtonTapped: baseView.userConnectView.phoneButton.rx.tap,
                                              paymentButtonTapped: paymentButtonTapped)
        let output = viewModel.transform(input)
        
        output.data.drive(with: self) { owner, data in
            owner.baseView.configureViewData(data)
            owner.baseView.layoutIfNeeded()
            owner.setAnnotaion(coordinate: data.coordinate, title: data.address)
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
        
//        Observable.zip(baseView.commentsTableView.rx.itemDeleted.asObservable(),
//                       output.comments.asObservable())
//        .subscribe(with: self) { owner, data in
//            let comment = data.1[data.0.row].creator.userID
//            guard comment == UserDefaultsManager.shared.userData.userID ?? "" else { return }
//            
//            // 사용자 ID 체크
//            if comment == UserDefaultsManager.shared.userData.userID ?? "" {
//                print("본인")
//                //                       self.viewWillAppear.onNext()
//            } else {
//                // 삭제 불가 토스트 메시지 또는 알림
//                print("본인아님")
//            }
//        }
//        .disposed(by: disposeBag)
        
        
        //        baseView.commentsTableView.rx.itemDeleted { indexPath in
        //                return (indexPath, data.0, data.1)
        //            }
        //            .subscribe(onNext: { [weak self] indexPath, comments, currentUserId in
        //                guard let self = self else { return }
        //                let comment = comments[indexPath.row]
        //
        //                // 사용자 ID 체크
        //                if comment.userId == currentUserId {
        //                    var newComments = comments
        //                    newComments.remove(at: indexPath.row)
        //                    self.comments.onNext(newComments)
        //                } else {
        //                    // 삭제 불가 토스트 메시지 또는 알림
        //                    print("삭제할 수 없습니다.")
        //                }
        //            })
        //            .disposed(by: disposeBag)
        
        baseView.userConnectView.messageButton.rx.tap
            .flatMap { output.data }
            .asDriver(onErrorJustReturn: ContentEntity.defaultData())
            .drive(with: self) { owner, data in
                print(data)
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

// MARK: - 여기서 delete 막기

extension DetailFeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        //        guard let comment = try? output.comments.value()[indexPath.row],
        //              let userID = UserDefaultsManager.shared.userData.userID else {
        //            return .none
        //        }
        //
        //        return comment.creator.userID == userID ? .delete : .none
        return .none
    }
}

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
