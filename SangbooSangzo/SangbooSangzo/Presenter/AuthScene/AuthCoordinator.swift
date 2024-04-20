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
    var childNav = UINavigationController()
    
    init(navigationController: UINavigationController?) {
        self.childCoordinators = []
        self.navigationController = navigationController
    }
    
    func start() {
        let vm = LoginViewModel(coordinator: self)
        let vc = LoginViewController(viewModel: vm)
        childNav.viewControllers = [vc]
        childNav.modalPresentationStyle = .fullScreen
        navigationController?.present(childNav, animated: true)
    }
    
    func pushToSignInView() {
        let vm = SignInViewModel(coordinator: self)
        let vc = SignInViewController(viewModel: vm)
        childNav.pushViewController(vc, animated: true)
    }
}
