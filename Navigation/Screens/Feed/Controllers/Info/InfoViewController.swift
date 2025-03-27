//
//  InfoViewController.swift
//  Navigation
//
//  Created by Razumov Pavel on 12.03.2025.
//

import UIKit

final class InfoViewController: UIViewController {
    
//    private lazy var showAlertButton: CustomButton = {
//        $0.addTarget(self, action: #selector(showAlertButtonTapped), for: .touchUpInside)
//        $0.translatesAutoresizingMaskIntoConstraints = false
//        return $0
//    }(CustomButton(title: "Show alert"))
    
    private lazy var showAlertButton: CustomButton = {
        let button = CustomButton(title: "Show alert")
        button.addTarget(self, action: #selector(showAlertButtonTapped), for: .touchUpInside)
        return button.withConstraints()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setConstraints()
    }
    
    private func setUpViews() {
        view.backgroundColor = .systemGreen
        view.addSubview(showAlertButton)
        title = "Info"
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            showAlertButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showAlertButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func showAlert() {
        let alert = UIAlertController(
            title: "Внимание",
            message: "Спасибо за внимание!",
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { _ in
            print("Нажата кнопка Отмена")
        }
        
        let okAction = UIAlertAction(title: "Ок", style: .default) { _ in
            print("Нажата кнопка Ок")
        }
        [cancelAction, okAction].forEach { alert.addAction($0) }
        present(alert, animated: true)
    }
    
    @objc
    private func showAlertButtonTapped() {
        showAlert()
    }
}
