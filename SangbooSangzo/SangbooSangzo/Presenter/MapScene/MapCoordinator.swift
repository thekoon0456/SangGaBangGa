//
//  MapCoordinator.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/15/24.
//

import UIKit

final class MapCoordinator: Coordinator {

    weak var delegate: CoordinatorDelegate?
    var childCoordinators: [Coordinator]
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.childCoordinators = []
        self.navigationController = navigationController
    }
    
    func start() {
        let postRepository = PostRepositoryImpl()
        let vm = MapViewModel(coordinator: self, postRepository: postRepository)
        let vc = MapViewController(viewModel: vm)
        vc.tabBarItem = UITabBarItem(title: nil,
                                     image: UIImage(systemName: "map"),
                                     selectedImage: UIImage(systemName: "map.fill"))
        navigationController.pushViewController(vc, animated: true)
    }
    
    func pushToDetail(data: ContentEntity) {
        let postRepository = PostRepositoryImpl()
        let commentRepository = CommentRepositoryImpl()
        let likeRepository = LikeRepositoryImpl()
        let paymentsRepository = PaymentsRepositoryImpl()
        let vm = DetailFeedViewModel(
            coordinator: FeedCoordinator(navigationController: self.navigationController),
            postRepository: postRepository,
            commentRepository: commentRepository,
            likeRepository: likeRepository,
            paymentsRepository: paymentsRepository,
            data: data
        )
        let vc = DetailFeedViewController(viewModel: vm)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func presentDetail(data: ContentEntity) {
        let postRepository = PostRepositoryImpl()
        let commentRepository = CommentRepositoryImpl()
        let likeRepository = LikeRepositoryImpl()
        
        let vm = MapDetailViewModel(
            coordinator: self,
            postRepository: postRepository,
            commentRepository: commentRepository,
            likeRepository: likeRepository,
            data: data
        )
        let vc = MapDetailViewController(viewModel: vm)
        vc.sheetPresentationController?.detents = [.custom { _ in CGFloat(300) }]
        vc.sheetPresentationController?.prefersGrabberVisible = true
        navigationController.present(vc, animated: true)
    }
    
    func pushToMapDetail(data: ContentEntity) {
        navigationController.dismiss(animated: false)
        let postRepository = PostRepositoryImpl()
        let commentRepository = CommentRepositoryImpl()
        let likeRepository = LikeRepositoryImpl()
        let paymentsRepository = PaymentsRepositoryImpl()
        let vm = DetailFeedViewModel(
            coordinator: FeedCoordinator(navigationController: self.navigationController),
            postRepository: postRepository,
            commentRepository: commentRepository,
            likeRepository: likeRepository,
            paymentsRepository: paymentsRepository,
            data: data
        )
        let vc = DetailFeedViewController(viewModel: vm)
        navigationController.pushViewController(vc, animated: true)
    }
}
