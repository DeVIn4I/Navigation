//
//  SceneDelegate.swift
//  Navigation
//
//  Created by Razumov Pavel on 12.03.2025.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    private lazy var loginInspector = {
        let factory = LoginFactory()
        let inspector = factory.makeLoginInspector()
        return inspector
    }()

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        self.window = window
        
        let appCoordinator = AppCoordinator(window: window)
        self.appCoordinator = appCoordinator
        appCoordinator.start()
        
        let configArray: [AppConfiguration] = [
            AppConfiguration.product("https://jsonplaceholder.typicode.com/users/1"),
            AppConfiguration.debug("https://jsonplaceholder.typicode.com/posts/1"),
            AppConfiguration.release("https://jsonplaceholder.typicode.com/albums/1")
        ]
        
        NetworkService.request(for: configArray.randomElement()!)
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}
