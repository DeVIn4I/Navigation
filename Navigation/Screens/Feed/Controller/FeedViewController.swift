//
//  FeedViewController.swift
//  Navigation
//
//  Created by Razumov Pavel on 12.03.2025.
//

import UIKit

final class FeedViewController: UIViewController {
    
    private let postTitle: String
    private let feedModel: FeedModelProtocol
    private let checkWordView = CheckWordView()
    
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
        bind()
    }
    
    private func setUpViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(checkWordView)
    }
    
    private func setConstraints() {
        checkWordView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    private func showPost() {
        let postVC = PostViewController(postTitle: postTitle)
        postVC.modalPresentationStyle = .fullScreen
        postVC.modalTransitionStyle = .coverVertical
        navigationController?.pushViewController(postVC, animated: true)
    }
    
    private func bind() {
        checkWordView.onCheckTap = { [weak self] in
            guard let self else { return }
            let password = checkWordView.getInputText() ?? ""
            
            guard !password.isEmpty else {
                let alertModel = AlertModel(title: "Ошибка", message: "Поле не должно быть пустым")
                let alert = UIAlertController(
                    title: alertModel.title,
                    message: alertModel.message,
                    preferredStyle: .alert
                )
                let okAction = UIAlertAction(title: "Ok", style: .default)
                alert.addAction(okAction)
                present(alert, animated: true)
                return
            }
            
            let isValid = feedModel.check(password)
            checkWordView.updateTitleColor(isValid)
        }
    }
}
