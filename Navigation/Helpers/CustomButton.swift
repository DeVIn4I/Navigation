//
//  CustomButton.swift
//  Navigation
//
//  Created by Razumov Pavel on 12.03.2025.
//

import UIKit
import SnapKit

final class CustomButton: UIButton {
    
    typealias Action = () -> Void
    private var buttonAction: Action
    
    init(title: String, action: @escaping Action) {
        self.buttonAction = action
        super.init(frame: .zero)
        setupButton(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton(title: String) {
        setTitle(title, for: .normal)
        backgroundColor = .link
        tintColor = .white
        layer.cornerRadius = 8
        translatesAutoresizingMaskIntoConstraints = false
        
        snp.makeConstraints {
            $0.width.equalTo(140)
            $0.height.equalTo(40)
        }
        
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc
    private func buttonTapped() {
        buttonAction()
    }
}
