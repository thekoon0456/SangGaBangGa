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
        let vm = InfoViewModel(
            coordinator: self,
            postUseCase: PostUseCaseImpl(postRepository: makePostRepository()),
            likeUseCase: LikeUseCaseImpl(likeRepository: makeLikeRepository()),
            profileUseCase: ProfileUseCaseImpl(profileRepository: makeProfileRepository()),
            paymentsUseCase: PaymentsUseCaseImpl(paymentsRepository: makePaymentsRepository())
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
        let paymentsRepository = PaymentsRepositoryImpl()
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
    
    func pushToSetting() {
        let vm = SettingViewModel(
            coordinator: self,
            profileUseCase: ProfileUseCaseImpl(profileRepository: makeProfileRepository())
        )
        let vc = SettingViewController(viewModel: vm)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func pushTo(userInfo: ProfileEntity) {
        let vm = EditProfileViewModel(
            coordinator: self,
            profileUseCase: ProfileUseCaseImpl(profileRepository: makeProfileRepository()),
            userInfo: userInfo)
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

// MARK: - Repository

extension InfoCoordinator {
    
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
    
    private func makeProfileRepository() -> ProfileRepository {
        return ProfileRepositoryImpl()
    }
    
    private func makePaymentsRepository() -> PaymentsRepository {
        return PaymentsRepositoryImpl()
    }
    
    private func makeCommentsRepository() -> CommentRepository {
        return CommentRepositoryImpl()
    }
}
