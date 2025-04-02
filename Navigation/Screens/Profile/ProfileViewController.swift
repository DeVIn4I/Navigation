//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Razumov Pavel on 12.03.2025.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private var posts = Post.makePosts()
    
    private lazy var postsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderTopPadding = 0
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.reuseID)
        return tableView.withConstraints()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstarints()
    }
    
    private func setupViews() {
        title = "Profile"
        view.addSubview(postsTableView)
    }
    
    private func setupConstarints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            postsTableView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            postsTableView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            postsTableView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            postsTableView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
        ])
    }
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PostTableViewCell.reuseID,
            for: indexPath
        ) as? PostTableViewCell else {
            return UITableViewCell()
        }
        let model = posts[indexPath.row]
        cell.configure(with: model)
        return cell
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        ProfileHeaderView()
    }
}
