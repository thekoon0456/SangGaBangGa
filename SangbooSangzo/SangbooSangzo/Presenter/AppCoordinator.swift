//
//  AppCoordinator.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/15/24.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    // MARK: - Properties
    
    weak var delegate: CoordinatorDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }
    
    // MARK: - Helpers
    
    func start() {
        if UserDefaultsManager.shared.userData.accessToken == nil {
            startAuthCoordinator()
        } else {
            startMainTabCoordinator()
        }
    }
    
    func startAuthCoordinator() {
        let authCoordinator = AuthCoordinator(navigationController: self.navigationController)
        childCoordinators.append(authCoordinator)
        authCoordinator.delegate = self
        authCoordinator.start()
    }
    
    func startMainTabCoordinator() {
        let tabCoordinator = MainTabCoordinator(navigationController: self.navigationController)
        childCoordinators.append(tabCoordinator)
        tabCoordinator.delegate = self
        tabCoordinator.start()
    }
}

// MARK: - Coodinator Delegate

extension AppCoordinator: CoordinatorDelegate {
    
    func didFinish(childCoordinator: Coordinator) {
        self.navigationController.popToRootViewController(animated: true)
        if childCoordinator is AuthCoordinator {
            startMainTabCoordinator()
        } else {
            startAuthCoordinator()
        }
    }
}
