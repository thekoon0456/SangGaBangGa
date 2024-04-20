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
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.childCoordinators = []
        self.navigationController = navigationController
    }
    
    func start() {
        let vm = MapViewModel(coordinator: self)
        let vc = MapViewController(viewModel: vm)
        vc.tabBarItem = UITabBarItem(title: nil,
                                     image: UIImage(systemName: "map"),
                                     selectedImage: UIImage(systemName: "map.fill"))
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushToDetail(data: UploadContentResponse) {
        let vm = DetailFeedViewModel(coordinator: self, data: data)
        let vc = DetailFeedViewController(viewModel: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
}
