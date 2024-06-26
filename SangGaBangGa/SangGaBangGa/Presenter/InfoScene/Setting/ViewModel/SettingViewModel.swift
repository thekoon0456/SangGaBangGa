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
    private let profileUseCase: ProfileUseCase
    private let userAPIManager = UserAPIManager.shared
    
    init(coordinator: InfoCoordinator,
         profileUseCase: ProfileUseCase) {
        self.coordinator = coordinator
        self.profileUseCase = profileUseCase
    }
    
    func transform(_ input: Input) -> Output {
        
        let list = ["내 정보 수정", "로그아웃", "회원 탈퇴"]
        let userProfileRelay = BehaviorRelay(value: ProfileEntity.defaultData())
        
        input
            .viewWillAppear
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.profileUseCase.getMyProfile()
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
                case 1:
                    owner.coordinator?
                        .showAlert(title: "로그아웃", message: "로그아웃 하시겠습니까?") {
                            UserDefaultsManager.shared.userData = UserData()
                            guard let coordinator = owner.coordinator else { return }
                            coordinator.didFinish(childCoordinator: coordinator)
                        }
                default:
                    owner.coordinator?
                        .showAlert(title: "회원 탈퇴", message: "정말로 탈퇴하시겠습니까?") {
                            owner.userAPIManager.withdraw()
                                .subscribe { response in
                                    print(response)
                                    guard let coordinator = owner.coordinator else { return }
                                    coordinator.didFinish(childCoordinator: coordinator)
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
