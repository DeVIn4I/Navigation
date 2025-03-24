//
//  FeedViewController.swift
//  Navigation
//
//  Created by Razumov Pavel on 12.03.2025.
//

import UIKit

final class FeedViewController: UIViewController {
    
    private let post: Post
    private lazy var showPostFirstButton: CustomButton = {
        $0.addTarget(self, action: #selector(showPostButtonTapped), for: .touchUpInside)
        return $0
    }(CustomButton(title: "Show post1").withConstraints())
    
    private lazy var showPostSecondButton: CustomButton = {
        $0.addTarget(self, action: #selector(showPostButtonTapped), for: .touchUpInside)
        return $0
    }(CustomButton(title: "Show post2").withConstraints())
    
    private lazy var postButtonsStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 10
        return $0
    }(UIStackView().withConstraints())
    
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
        view.addSubview(postButtonsStackView)
        [
            showPostFirstButton, showPostSecondButton
        ].forEach { postButtonsStackView.addArrangedSubview($0) }
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            postButtonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            postButtonsStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func showPostButtonTapped() {
        let postVC = PostViewController(post: post)
        postVC.modalPresentationStyle = .fullScreen
        postVC.modalTransitionStyle = .coverVertical
        navigationController?.pushViewController(postVC, animated: true)
    }
}
