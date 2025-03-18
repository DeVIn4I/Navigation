//
//  PostViewController.swift
//  Navigation
//
//  Created by Razumov Pavel on 12.03.2025.
//

import UIKit

final class PostViewController: UIViewController {
    
    private let post: Post
    
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
        setNavigationBar()
    }
    
    private func setUpViews() {
        title = post.title
        view.backgroundColor = .systemYellow
    }
    
    private func setNavigationBar() {
        let infoButton = UIBarButtonItem(
            image: UIImage(systemName: "info.circle"),
            style: .done,
            target: self,
            action: #selector(infoButtonTapped)
        )
        
        navigationItem.rightBarButtonItem = infoButton
    }
    
    @objc
    private func infoButtonTapped() {
        let infoVC = InfoViewController()
        infoVC.modalPresentationStyle = .pageSheet
        present(infoVC, animated: true)
    }
}
