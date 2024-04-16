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
    var navigationController: UINavigationController?
    var childCoordinators: [Coordinator]
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }
    
    // MARK: - Helpers
    
    func start() {
        makeTabbar()
    }
    
    func makeTabbar() {
        let tabBarController = UITabBarController()
        tabBarController.tabBar.backgroundColor = .systemBackground
        
        let feedNav = UINavigationController()
        let feedcoordinator = FeedCoordinator(navigationController: feedNav)
        childCoordinators.append(feedcoordinator)
        feedcoordinator.start()
        
        let mapNav = UINavigationController()
        let mapCoordinator = MapCoordinator(navigationController: mapNav)
        childCoordinators.append(mapCoordinator)
        mapCoordinator.start()
        
        let infoNav = UINavigationController()
        let infoCoordinator = InfoCoordinator(navigationController: infoNav)
        childCoordinators.append(infoCoordinator)
        infoCoordinator.start()
        
        tabBarController.viewControllers = [feedNav, mapNav, infoNav]
        tabBarController.tabBar.tintColor = .tintColor
        navigationController?.setViewControllers([tabBarController], animated: false)
    }

}
