//
//  Coordinator.swift
//  Navigation
//
//  Created by Razumov Pavel on 19.06.2025.
//

import Foundation

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    func start()
}
