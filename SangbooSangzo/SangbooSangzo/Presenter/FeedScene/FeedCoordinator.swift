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
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.childCoordinators = []
        self.navigationController = navigationController
    }
    
    func start() {
        let vm = FeedViewModel(coordinator: self)
        let vc = FeedViewController(viewModel: vm)
        vc.tabBarItem = UITabBarItem(title: nil,
                                     image: .ssHome,
                                     selectedImage: .ssHomeSelected)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didFinish(childCoordinator: any Coordinator) {
        childCoordinators = []
    }
    
    func pushToPost() {
        let vm = PostViewModel(coordinator: self)
        let vc = PostViewController(viewModel: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushToDetail(data: ContentEntity) {
        let vm = DetailFeedViewModel(coordinator: self, data: data)
        let vc = DetailFeedViewController(viewModel: vm)
        navigationController?.pushViewController(vc, animated: true)
        setClearNavigationBar()
    }
}
