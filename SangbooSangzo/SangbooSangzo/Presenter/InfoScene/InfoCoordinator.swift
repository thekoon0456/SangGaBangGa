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
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.childCoordinators = []
        self.navigationController = navigationController
    }
    
    func start() {
        let postRepository = PostRepositoryImpl()
        let likeRepository = LikeRepositoryImpl()
        let vm = InfoViewModel(
            coordinator: self,
            postRepository: postRepository,
            likeRepository: likeRepository
        )
        let vc = InfoViewController(viewModel: vm)
        vc.tabBarItem = UITabBarItem(title: nil,
                                     image: .ssUser,
                                     selectedImage: .ssUserSelected)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func pushToDetail(data: ContentEntity) {
        let postRepository = PostRepositoryImpl()
        let commentRepository = CommentRepositoryImpl()
        let likeRepository = LikeRepositoryImpl()
        let vm = DetailFeedViewModel(
            coordinator: self,
            postRepository: postRepository,
            commentRepository: commentRepository,
            likeRepository: likeRepository,
            data: data
        )
        let vc = DetailFeedViewController(viewModel: vm)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func pushToSetting() {
        let vm = SettingViewModel(coordinator: self)
        let vc = SettingViewController(viewModel: vm)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func pushTo(userInfo: ProfileResponse) {
        let vm = EditProfileViewModel(coordinator: self, userInfo: userInfo)
        let vc = EditProfileViewController(viewModel: vm)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func presentPHPickerView(picker: UIViewController) {
        navigationController.present(picker, animated: true)
    }
}

extension InfoCoordinator: CoordinatorDelegate {
    
    func didFinish(childCoordinator: Coordinator) {
        self.navigationController.popToRootViewController(animated: false)
        self.finish()
    }
}
