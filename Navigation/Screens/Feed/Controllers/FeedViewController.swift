//
//  FeedViewController.swift
//  Navigation
//
//  Created by Razumov Pavel on 12.03.2025.
//

import UIKit

final class FeedViewController: UIViewController {
    
    private let postTitle: String
    private lazy var showPostFirstButton: CustomButton = {
        let button = CustomButton(title: "Show post1")
        button.addTarget(self, action: #selector(showPostButtonTapped), for: .touchUpInside)
        return button.withConstraints()
    }()
    
    private lazy var showPostSecondButton: CustomButton = {
        let button = CustomButton(title: "Show post2")
        button.addTarget(self, action: #selector(showPostButtonTapped), for: .touchUpInside)
        return button.withConstraints()
    }()
    
    private lazy var postButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView.withConstraints()
    }()
    
    init(postTitle: String) {
        self.postTitle = postTitle
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
        let postVC = PostViewController(postTitle: postTitle)
        postVC.modalPresentationStyle = .fullScreen
        postVC.modalTransitionStyle = .coverVertical
        navigationController?.pushViewController(postVC, animated: true)
    }
}
