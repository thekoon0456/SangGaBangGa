//
//  AuthCoordinator.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/15/24.
//

import UIKit

final class AuthCoordinator: Coordinator {

    weak var delegate: CoordinatorDelegate?
    var childCoordinators: [Coordinator]
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.childCoordinators = []
        self.navigationController = navigationController
    }
    
    func start() {
        let vm = LoginViewModel(coordinator: self)
        let vc = LoginViewController(viewModel: vm)
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .overFullScreen
        navigationController?.present(nav, animated: true)
    }
}
