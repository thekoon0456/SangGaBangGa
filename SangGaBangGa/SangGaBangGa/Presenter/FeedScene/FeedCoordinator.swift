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
        let vm = FeedViewModel(
            coordinator: self,
            postUseCase: PostUseCaseImpl(postRepository: makePostRepository()),
            likeUseCase: LikeUseCaseImpl(likeRepository: makeLikeRepository())
        )
        let vc = FeedViewController(viewModel: vm)
        vc.tabBarItem = UITabBarItem(title: nil,
                                     image: SSIcon.icon,
                                     selectedImage: SSIcon.iconFill)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func pushToPost() {
        let postRepository = PostRepositoryImpl()
        let vm = PostViewModel(
            coordinator: self,
            postUseCase: PostUseCaseImpl(postRepository: makePostRepository())
        )
        let vc = PostViewController(viewModel: vm)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func pushToDetail(data: ContentEntity) {
        let vm = DetailFeedViewModel(
            coordinator: self,
            postUseCase: PostUseCaseImpl(postRepository: makePostRepository()),
            commentUseCase: CommentUseCaseImpl(commentRepository: makeCommentsRepository()),
            likeUseCase: LikeUseCaseImpl(likeRepository: makeLikeRepository()),
            paymentsUseCase: PaymentsUseCaseImpl(paymentsRepository: makePaymentsRepository()),
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
            commentUseCase: CommentUseCaseImpl(commentRepository: makeCommentsRepository()),
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

extension FeedCoordinator {
    
    private func makePostRepository() -> PostRepository {
        //        #if DEBUG
        //        if FakeRepositoryEnvironment.useFakeRepository {
        //            return FakePostRepository()
        //        }
        //        #endif
        return PostRepositoryImpl()
    }
    
    private func makeLikeRepository() -> LikeRepository {
        return LikeRepositoryImpl()
    }
    
    private func makePaymentsRepository() -> PaymentsRepository {
        return PaymentsRepositoryImpl()
    }
    
    private func makeCommentsRepository() -> CommentRepository {
        return CommentRepositoryImpl()
    }
}
