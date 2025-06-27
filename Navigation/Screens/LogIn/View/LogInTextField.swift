//
//  LogInTextField.swift
//  Navigation
//
//  Created by Razumov Pavel on 27.03.2025.
//

import UIKit

final class LogInTextField: UITextField {
    
    private var title: String
    private var isSecureText: Bool
    
    init(title: String, isSecureText: Bool = false) {
        self.title = title
        self.isSecureText = isSecureText
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        borderStyle = .none
        textColor = .black
        font = .systemFont(ofSize: 16, weight: .medium)
        tintColor = .separator
        backgroundColor = .systemGray6
        autocorrectionType = .no
        autocapitalizationType = .none
        returnKeyType = .continue
        clearButtonMode = .whileEditing
        contentVerticalAlignment = .center
        placeholder = title
        isSecureTextEntry = isSecureText
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        leftViewMode = .always
    }
}

