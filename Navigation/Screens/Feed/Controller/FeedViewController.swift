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
    
    private lazy var infoButton = CustomButton(title: "InfoVC") { [weak self] in
        let vc = InfoViewController()
        self?.present(vc, animated: true)
    }
    
    
    weak var coordinator: FeedCoordinator?
    
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
        view.addSubview(infoButton)
    }
    
    private func setConstraints() {
        checkWordView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        infoButton.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
        }
    }
    
    private func showPost() {
        coordinator?.showPost(title: postTitle)
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
