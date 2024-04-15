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
}
