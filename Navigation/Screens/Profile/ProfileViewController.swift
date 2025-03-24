//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Razumov Pavel on 12.03.2025.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private lazy var profileHeaderView = ProfileHeaderView().withConstraints()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstarints()
    }
    
    private func setupViews() {
        title = "Profile"
        view.backgroundColor = .lightGray
        view.addSubview(profileHeaderView)
    }
    
    private func setupConstarints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
          profileHeaderView.topAnchor.constraint(equalTo: safeArea.topAnchor),
          profileHeaderView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
          profileHeaderView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
          profileHeaderView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
}
