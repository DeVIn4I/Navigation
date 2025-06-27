//
//  TabBarCoordinator.swift
//  Navigation
//
//  Created by Razumov Pavel on 19.06.2025.
//

import UIKit

final class TabBarCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    let tabBarController = UITabBarController()
    
    private let loginInspector: LoginViewControllerDelegate
    private let userService: UserService
    
    init(loginInspector: LoginViewControllerDelegate, userService: UserService) {
        self.loginInspector = loginInspector
        self.userService = userService
    }
    
    func start() {
        let feedNav = UINavigationController()
        let profileNav = UINavigationController()
        
        let feedCoordinator = FeedCoordinator(navigationController: feedNav)
        let profileCoordinator = ProfileCoordinator(
            navigationController: profileNav,
            loginInspector: loginInspector,
            userService: userService
        )
        
        childCoordinators = [feedCoordinator, profileCoordinator]
        feedCoordinator.start()
        profileCoordinator.start()
        
        tabBarController.viewControllers = [feedNav, profileNav]
    }
}
