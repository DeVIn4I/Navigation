//
//  UIView + Extension.swift
//  Navigation
//
//  Created by Razumov Pavel on 24.03.2025.
//

import UIKit

extension UIView {
    func withConstraints(_ with: Bool = true) -> Self {
        translatesAutoresizingMaskIntoConstraints = !with
        return self
    }
}
