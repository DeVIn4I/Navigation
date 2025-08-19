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
    private var feedModel: FeedModelProtocol
    
    private var isFiltering: Bool = false
   
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
        setupNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        postsTableView.reloadData()
    }
    
    private func setupNavBar() {
        let filterButton = UIBarButtonItem(title: "Фильтр", style: .plain, target: self, action: #selector(filterByAuthor))
        let clearButton = UIBarButtonItem(title: "Сброс", style: .plain, target: self, action: #selector(clearFilter))
        navigationItem.rightBarButtonItems = [clearButton, filterButton]
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
    
    @objc
    private func filterByAuthor() {
        print(#function)
        let alert = UIAlertController(title: "Поиск по автору", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Введите имя автора"
        }
        
        let applyAction = UIAlertAction(title: "Применить", style: .default) { [weak self] _ in
            guard let self else { return }
            
            guard let author = alert.textFields?.first?.text,
                  !author.isEmpty else {
                return
            }
            
            self.feedModel.fetchPostBy(author: author)
            self.isFiltering = true
            self.postsTableView.reloadData()
        }
        alert.addAction(applyAction)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        present(alert, animated: true)
    }
    
    @objc
    private func clearFilter() {
        isFiltering = false
        feedModel.filteredPosts = []
        postsTableView.reloadData()
    }
}

extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isFiltering ? feedModel.filteredPosts.count : feedModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.reuseID, for: indexPath) as? PostTableViewCell else {
            return UITableViewCell()
        }
        
        let model = isFiltering
            ? feedModel.filteredPosts[indexPath.row]
            : feedModel.fetchFavoritePosts()[indexPath.row]
        
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
            
            let postToDelete = isFiltering
                ? feedModel.filteredPosts[indexPath.row]
                : feedModel.fetchFavoritePosts()[indexPath.row]
            
            Task {
                do {
                    await self.feedModel.deleteFavoritePost(objectID: postToDelete.objectID)
                    
                    if self.isFiltering {
                        self.feedModel.filteredPosts.remove(at: indexPath.row)
                    }
                    
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
