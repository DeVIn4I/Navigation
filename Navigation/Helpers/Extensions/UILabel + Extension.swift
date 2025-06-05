//
//  UILabel + Extension.swift
//  Navigation
//
//  Created by Razumov Pavel on 24.03.2025.
//

import UIKit

extension UILabel {
    convenience init(
        text: String,
        font: UIFont,
        textColor: UIColor,
        textAlignment: NSTextAlignment = .left,
        lines: Int = 0
    ) {
        self.init()
        self.text = text
        self.font = font
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.numberOfLines = lines
    }
}
