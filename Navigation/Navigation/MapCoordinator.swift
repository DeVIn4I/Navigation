//
//  MapCoordinator.swift
//  Navigation
//
//  Created by Razumov Pavel on 18.08.2025.
//

import UIKit

final class MapCoordinator: Coordinator {
    
    let navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = MapViewController()
        vc.coordinator = self
        vc.tabBarItem = UITabBarItem(title: "Карта", image: UIImage(systemName: "map"), selectedImage: nil)
        navigationController.setViewControllers( [vc], animated: false)
    }
}
