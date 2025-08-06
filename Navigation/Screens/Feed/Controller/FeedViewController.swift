//
//  FeedViewController.swift
//  Navigation
//
//  Created by Razumov Pavel on 12.03.2025.
//

import UIKit
import StorageService

final class FeedViewController: UIViewController {
    
    private let postTitle: String
    private let feedModel: FeedModelProtocol
   
    weak var coordinator: FeedCoordinator?
    
    private lazy var postsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderTopPadding = 0
        tableView.register(
            PostTableViewCell.self,
            forCellReuseIdentifier: PostTableViewCell.identifier
        )
        return tableView.withConstraints()
    }()
    
    init(postTitle: String, feedModel: FeedModelProtocol) {
        self.postTitle = postTitle
        self.feedModel = feedModel
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        postsTableView.reloadData()
    }
    
    private func setUpViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(postsTableView)
    }
    
    private func setConstraints() {
        postsTableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        feedModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.reuseID, for: indexPath) as? PostTableViewCell else {
            return UITableViewCell()
        }
        let model = feedModel.fetchFavoritePosts()[indexPath.row]
        let post = Post(
            author: model.author ?? "",
            description: model.desc ?? "",
            image: model.image ?? "",
            likes: Int(model.likes),
            views: Int(model.views)
        )
        cell.configure(with: post)
        return cell
    }
}

extension FeedViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] (_, _, completion) in
            guard let self else { return }
            
            let postToDelete = feedModel.fetchFavoritePosts()[indexPath.row]
            
            Task {
                do {
                    await self.feedModel.deleteFavoritePost(objectID: postToDelete.objectID)
                    
                    DispatchQueue.main.async {
                        self.postsTableView.reloadData()
                        completion(true)
                    }
                }
            }
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
