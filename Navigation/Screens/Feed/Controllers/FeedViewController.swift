//
//  FeedViewController.swift
//  Navigation
//
//  Created by Razumov Pavel on 12.03.2025.
//

import UIKit

final class FeedViewController: UIViewController {
    
    private let post: Post
    private lazy var showPostButton: CustomButton = {
        let button = CustomButton(title: "Show post")
        button.addTarget(self, action: #selector(showPostButtonTapped), for: .touchUpInside)
        return button.withConstraints()
    }()
    
    init(post: Post) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setConstraints()
    }
    
    private func setUpViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(showPostButton)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            showPostButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showPostButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc
    private func showPostButtonTapped() {
        let postVC = PostViewController(post: post)
        postVC.modalPresentationStyle = .fullScreen
        postVC.modalTransitionStyle = .coverVertical
        navigationController?.pushViewController(postVC, animated: true)
    }
}
