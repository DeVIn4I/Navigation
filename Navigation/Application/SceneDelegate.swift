//
//  SceneDelegate.swift
//  Navigation
//
//  Created by Razumov Pavel on 12.03.2025.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: scene)
        let post = Post(title: "First post")
        let feedVC = FeedViewController(post: post)
        feedVC.tabBarItem = UITabBarItem(
            title: "Лента",
            image: UIImage(systemName: "list.bullet"),
            selectedImage: nil
        )
        
        let profileVC = ProfileViewController()
        profileVC.tabBarItem = UITabBarItem(
            title: "Профиль",
            image: UIImage(systemName: "person.crop.circle"),
            selectedImage: nil
        )

        let tabbarController = UITabBarController()
        tabbarController.viewControllers = [
            feedVC,
            profileVC
        ].map { UINavigationController(rootViewController: $0) }
        
        window.rootViewController = tabbarController
        window.makeKeyAndVisible()
        self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}
