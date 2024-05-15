//
//  FeedCoordinator.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/15/24.
//

import UIKit

import RxCocoa
import RxSwift

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
        let likeRepository = LikeRepositoryImpl()
        let vm = FeedViewModel(
            coordinator: self,
            postRepository: postRepository,
            likeRepository: likeRepository
        )
        let vc = FeedViewController(viewModel: vm)
        vc.tabBarItem = UITabBarItem(title: nil,
                                     image: SSIcon.icon,
                                     selectedImage: SSIcon.iconFill)
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
        let paymentsRepository = PaymentsRepositoryImpl()
        let vm = DetailFeedViewModel(
            coordinator: self,
            postRepository: postRepository,
            commentRepository: commentRepository,
            likeRepository: likeRepository,
            paymentsRepository: paymentsRepository,
            data: data
        )
        let vc = DetailFeedViewController(viewModel: vm)
        navigationController.pushViewController(vc, animated: true)
        setClearNavigationBar()
    }
    
    func presentComment(data: ContentEntity, commentsRelay: BehaviorRelay<[PostCommentEntity]>) {
        let commentRepository = CommentRepositoryImpl()
        let vm = CommentViewModel(
            data: data,
            commentRepository: commentRepository,
            commentsRelay: commentsRelay
        )
        let vc = CommentViewController(viewModel: vm)
        vc.sheetPresentationController?.detents = [.medium(), .large()]
        navigationController.present(vc, animated: true)
    }
}

extension FeedCoordinator: CoordinatorDelegate {
    
    func didFinish(childCoordinator: Coordinator) {
        self.navigationController.popToRootViewController(animated: false)
        self.finish()
    }
}
