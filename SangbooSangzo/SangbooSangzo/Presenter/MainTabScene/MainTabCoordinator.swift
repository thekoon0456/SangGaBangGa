//
//  MainTabCoordinator.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 5/1/24.
//

import UIKit
import RxSwift

final class MainTabCoordinator: Coordinator {

    weak var delegate: CoordinatorDelegate?
    var childCoordinators: [Coordinator]
    var navigationController: UINavigationController
    var childNav = UINavigationController()
    let disposeBag = DisposeBag()
    
    init(navigationController: UINavigationController) {
        self.childCoordinators = []
        self.navigationController = navigationController
        setLoginFlow()
        setNetworkErrorToast()
    }
    
    deinit {
        print("MainTabCoordinator deinit")
    }
    
    func start() {
        makeTabbar()
    }
    
    func makeTabbar() {
        setNavigationBarHidden(true)
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.backgroundColor = .systemBackground
        
        let feedNav = UINavigationController()
        let feedCoordinator = FeedCoordinator(navigationController: feedNav)
        childCoordinators.append(feedCoordinator)
        feedCoordinator.start()
        
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
        navigationController.setViewControllers([tabBarController], animated: false)
    }
    
    func setLoginFlow() {
        TokenInterceptor
            .errorSubject
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                owner.didFinish(childCoordinator: owner)
            }
            .disposed(by: disposeBag)
    }
    
    func setNetworkErrorToast() {
        NetworkMonitorManager.shared.statusObservable
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, status in
                 switch status {
                 case .unsatisfied, .requiresConnection:
                     owner.showToast(.networkError)
                 case .satisfied:
                     owner.showToast(.networkResume)
                 @unknown default:
                     return
                 }
             }
             .disposed(by: disposeBag)
     }
}

extension MainTabCoordinator: CoordinatorDelegate {
    
    func didFinish(childCoordinator: Coordinator) {
        navigationController.popToRootViewController(animated: false)
        finish()
    }
}
