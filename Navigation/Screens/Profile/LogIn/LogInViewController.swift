//
//  LogInViewController.swift
//  Navigation
//
//  Created by Razumov Pavel on 26.03.2025.
//

import UIKit

final class LogInViewController: UIViewController {
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }().withConstraints()
    
    private lazy var contentView = UIView().withConstraints()
    private lazy var logInView = LogInView().withConstraints()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bindKeyboard(to: scrollView)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unbindKeyboard()
    }
    
    private func setupViews() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(logInView)
        
        logInView.logInButtonTappedCallback = { [weak self] in
            let profileVC = ProfileViewController()
            self?.navigationController?.pushViewController(profileVC, animated: true)
        }
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            logInView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 120),
            logInView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            logInView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            logInView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
