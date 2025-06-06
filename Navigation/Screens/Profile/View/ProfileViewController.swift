//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Razumov Pavel on 12.03.2025.
//

import UIKit
import StorageService

final class ProfileViewController: UIViewController {

    private lazy var postsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderTopPadding = 0
        tableView.register(
            PostTableViewCell.self,
            forCellReuseIdentifier: PostTableViewCell.identifier
        )
        tableView.register(
            PhotosTableViewCell.self,
            forCellReuseIdentifier: PhotosTableViewCell.identifier
        )
        return tableView.withConstraints()
    }()
    
    private let viewModel: ProfileViewModel
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstarints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    private func setupViews() {
        title = "Profile"
        view.addSubview(postsTableView)
        
        #if DEBUG
        view.backgroundColor = .systemBackground
        #else
        view.backgroundColor = .systemMint
        #endif
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 1 : viewModel.numberOfPosts
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: PhotosTableViewCell.identifier,
                for: indexPath
            ) as? PhotosTableViewCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: PostTableViewCell.identifier,
                for: indexPath
            ) as? PostTableViewCell else {
                return UITableViewCell()
            }
            let model = viewModel.posts[indexPath.row]
            cell.configure(with: model)
            cell.selectionStyle = .none
            return cell
        }
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewModel = ProfileHeaderViewViewModel(user: viewModel.user)
        let headerView = ProfileHeaderView(viewModel: viewModel)        
        return section == 0 ? headerView : nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 2 : .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let photosVC = PhotosViewController()
            navigationController?.pushViewController(photosVC, animated: true)
        }
    }
}
