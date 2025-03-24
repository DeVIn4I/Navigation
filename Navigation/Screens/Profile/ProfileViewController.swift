//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Razumov Pavel on 12.03.2025.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private lazy var profileHeaderView = ProfileHeaderView().withConstraints()
    
    private lazy var newButton: UIButton = {
        $0.setTitle("New Button", for: .normal)
        return $0
    }(UIButton(type: .system).withConstraints())

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstarints()
    }
    
    private func setupViews() {
        title = "Profile"
        view.backgroundColor = .lightGray
        view.addSubview(profileHeaderView)
        view.addSubview(newButton)
    }
    
    private func setupConstarints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
          profileHeaderView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
          profileHeaderView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
          profileHeaderView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
          profileHeaderView.heightAnchor.constraint(equalToConstant: 220)
        ])
        
        NSLayoutConstraint.activate([
            newButton.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
            newButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            newButton.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
