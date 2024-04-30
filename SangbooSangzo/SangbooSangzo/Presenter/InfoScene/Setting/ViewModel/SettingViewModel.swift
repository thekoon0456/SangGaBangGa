//
//  SettingViewModel.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/23/24.
//

import Foundation

import RxCocoa
import RxSwift

final class SettingViewModel: ViewModel {
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let cellSelected: ControlEvent<IndexPath>
    }
    
    struct Output {
        let settingList: Driver<[String]>
    }
    
    // MARK: - Properties
    
    weak var coordinator: InfoCoordinator?
    var disposeBag = DisposeBag()
    private let profileAPIManager = ProfileAPIManager.shared
    private let userAPIManager = UserAPIManager.shared
    
    init(coordinator: InfoCoordinator) {
        self.coordinator = coordinator
    }
    
    func transform(_ input: Input) -> Output {
        
        let list = ["내 정보 수정", "회원 탈퇴"]
        let userProfileRelay = BehaviorRelay(value: ProfileResponse())
        
        input
            .viewWillAppear
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.profileAPIManager.getMyProfile()
            }
            .subscribe { value in
                userProfileRelay.accept(value)
            }
            .disposed(by: disposeBag)
        
        let settingList = input
            .viewWillAppear
            .map { list }
            .asDriver(onErrorJustReturn: [])
        
        input
            .cellSelected
            .asDriver()
            .drive(with: self) { owner, indexPath in
                switch indexPath.row {
                case 0:
                    owner.coordinator?.pushTo(userInfo: userProfileRelay.value)
                default:
                    owner.coordinator?
                        .showAlert(title: "회원 탈퇴", message: "정말로 탈퇴하시겠습니까?") {
                            owner.userAPIManager.withdraw()
                                .subscribe { response in
                                    print(response)
                                } onFailure: { error in
                                    print(error)
                                }
                                .disposed(by: owner.disposeBag)
                        }
                }
            }
            .disposed(by: disposeBag)
        
        return Output(settingList: settingList)
    }
    
    
    
}
