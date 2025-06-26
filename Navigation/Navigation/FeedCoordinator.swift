//
//  FeedCoordinator.swift
//  Navigation
//
//  Created by Razumov Pavel on 19.06.2025.
//

import UIKit

final class FeedCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let feedModel = FeedModel()
        let feedVC = FeedViewController(postTitle: "First Post", feedModel: feedModel)
        feedVC.coordinator = self
        feedVC.tabBarItem = UITabBarItem(title: "Лента", image: UIImage(systemName: "list.bullet"), selectedImage: nil)
        navigationController.setViewControllers([feedVC], animated: false)
    }

    func showPost(title: String) {
        let postVC = PostViewController(postTitle: title)
        navigationController.pushViewController(postVC, animated: true)
    }
}
