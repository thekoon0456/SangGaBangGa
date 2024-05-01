//
//  FeedCoordinator.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/15/24.
//

import UIKit

final class FeedCoordinator: Coordinator {

    weak var delegate: CoordinatorDelegate?
    var childCoordinators: [Coordinator]
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.childCoordinators = []
        self.navigationController = navigationController
    }
    
    func start() {
        let postRepository = PostRepositoryImpl()
        let vm = FeedViewModel(coordinator: self, postRepository: postRepository)
        let vc = FeedViewController(viewModel: vm)
        vc.tabBarItem = UITabBarItem(title: nil,
                                     image: .ssHome,
                                     selectedImage: .ssHomeSelected)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func pushToPost() {
        let postRepository = PostRepositoryImpl()
        let vm = PostViewModel(coordinator: self, postRepository: postRepository)
        let vc = PostViewController(viewModel: vm)
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
        setClearNavigationBar()
    }
}

extension FeedCoordinator: CoordinatorDelegate {
    
    func didFinish(childCoordinator: Coordinator) {
        self.navigationController.popToRootViewController(animated: false)
        self.finish()
    }
}
