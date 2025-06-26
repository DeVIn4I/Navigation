//
//  AppCoordinator.swift
//  Navigation
//
//  Created by Razumov Pavel on 19.06.2025.
//

import UIKit

final class AppCoordinator: Coordinator {
    var window: UIWindow
    var childCoordinators: [Coordinator] = []
    
    //MARK: - Service
    private let loginInspector: LoginViewControllerDelegate = LoginFactory().makeLoginInspector()
    private let userService: UserService = {
        #if DEBUG
            return TestUserService()
        #else
            return CurrentUserService()
        #endif
    }()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let tabBarCoordinator = TabBarCoordinator(
            loginInspector: loginInspector,
            userService: userService
        )
        childCoordinators.append(tabBarCoordinator)
        tabBarCoordinator.start()
        
        window.rootViewController = tabBarCoordinator.tabBarController
        window.makeKeyAndVisible()
    }
}
