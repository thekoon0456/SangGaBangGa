//
//  InfoCoordinator.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/15/24.
//

import UIKit

final class InfoCoordinator: Coordinator {

    weak var delegate: CoordinatorDelegate?
    var childCoordinators: [Coordinator]
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.childCoordinators = []
        self.navigationController = navigationController
    }
    
    func start() {
        let vm = InfoViewModel(coordinator: self)
        let vc = InfoViewController(viewModel: vm)
        vc.tabBarItem = UITabBarItem(title: nil,
                                     image: UIImage(systemName: "person"),
                                     selectedImage: UIImage(systemName: "person.fill"))
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushToDetail(data: UploadContentResponse) {
        let vm = DetailFeedViewModel(coordinator: self, data: data)
        let vc = DetailFeedViewController(viewModel: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushToSetting() {
        let vm = SettingViewModel(coordinator: self)
        let vc = SettingViewController(viewModel: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentUserInfo(userInfo: ProfileResponse) {
        let vm = SignInViewModel(coordinator: self, userInfo: userInfo)
        let vc = SignInViewController(viewModel: vm)
        navigationController?.present(vc, animated: true)
    }
}
