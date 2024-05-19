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
    lazy var feedCoordinator = FeedCoordinator(navigationController: self.navigationController)
    
    init(navigationController: UINavigationController) {
        self.childCoordinators = []
        self.navigationController = navigationController
    }
    
    func start() {
        let vm = MapViewModel(
            coordinator: self,
            postUseCase: PostUseCaseImpl(postRepository: makePostRepository())
        )
        let vc = MapViewController(viewModel: vm)
        vc.tabBarItem = UITabBarItem(title: nil,
                                     image: UIImage(systemName: "map"),
                                     selectedImage: UIImage(systemName: "map.fill"))
        navigationController.pushViewController(vc, animated: true)
    }
    
    func pushToDetail(data: ContentEntity) {
        let vm = DetailFeedViewModel(
            coordinator: FeedCoordinator(navigationController: self.navigationController),
            postUseCase: PostUseCaseImpl(postRepository: makePostRepository()),
            commentUseCase: CommentUseCaseImpl(commentRepository: makeCommentsRepository()),
            likeUseCase: LikeUseCaseImpl(likeRepository: makeLikeRepository()),
            paymentsUseCase: PaymentsUseCaseImpl(paymentsRepository: makePaymentsRepository()),
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
            postUseCase: PostUseCaseImpl(postRepository: makePostRepository()),
            commentUseCase: CommentUseCaseImpl(commentRepository: makeCommentsRepository()),
            likeUseCase: LikeUseCaseImpl(likeRepository: makeLikeRepository()),
            data: data
        )
        let vc = MapDetailViewController(viewModel: vm)
        vc.sheetPresentationController?.detents = [.custom { _ in CGFloat(300) }]
        vc.sheetPresentationController?.prefersGrabberVisible = true
        navigationController.present(vc, animated: true)
    }
    
    func pushToMapDetail(data: ContentEntity) {
        navigationController.dismiss(animated: false)
        let vm = DetailFeedViewModel(
            coordinator: feedCoordinator,
            postUseCase: PostUseCaseImpl(postRepository: makePostRepository()),
            commentUseCase: CommentUseCaseImpl(commentRepository: makeCommentsRepository()),
            likeUseCase: LikeUseCaseImpl(likeRepository: makeLikeRepository()),
            paymentsUseCase: PaymentsUseCaseImpl(paymentsRepository: makePaymentsRepository()),
            data: data
        )
        let vc = DetailFeedViewController(viewModel: vm)
        navigationController.pushViewController(vc, animated: true)
    }
}

extension MapCoordinator {
    
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
