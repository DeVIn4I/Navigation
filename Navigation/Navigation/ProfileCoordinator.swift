//
//  ProfileCoordinator.swift
//  Navigation
//
//  Created by Razumov Pavel on 19.06.2025.
//

import UIKit

final class ProfileCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController
    private let loginInspector: LoginViewControllerDelegate
    private let userService: UserService

    init(navigationController: UINavigationController,
         loginInspector: LoginViewControllerDelegate,
         userService: UserService) {
        self.navigationController = navigationController
        self.loginInspector = loginInspector
        self.userService = userService
    }

    func start() {
        let loginVC = LogInViewController(userService: userService)
        loginVC.loginDelegate = loginInspector
        loginVC.coordinator = self
        loginVC.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(systemName: "person.crop.circle"), selectedImage: nil)
        navigationController.setViewControllers([loginVC], animated: false)
    }

    func showProfile() {
        let user = userService.getUser()
        let viewModel = ProfileViewModel(user: user)
        let profileVC = ProfileViewController(viewModel: viewModel)
        profileVC.coordinator = self
        navigationController.pushViewController(profileVC, animated: true)
    }

    func showPhotos() {
        let photosVC = PhotosViewController()
        navigationController.pushViewController(photosVC, animated: true)
    }
}
