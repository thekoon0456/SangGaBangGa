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
                                     image: UIImage(systemName: "house"),
                                     selectedImage: UIImage(systemName: "house.fill"))
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didFinish(childCoordinator: any Coordinator) {
        childCoordinators = []
    }
    
    func pushToPost() {
        let vm = PostViewModel()
        let vc = PostViewController(viewModel: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
}
