//
//  InfoViewController.swift
//  Navigation
//
//  Created by Razumov Pavel on 12.03.2025.
//

import UIKit

final class InfoViewController: UIViewController {
    
    private lazy var showAlertButton: CustomButton = {
        let button = CustomButton(title: "Show alert") { [weak self] in
            self?.showAlert()
        }
        return button.withConstraints()
    }()
    
    private lazy var personLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Person: "
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var personPostLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setConstraints()
        fetchPerson()
        fetchPersonPost()
    }
    
    private func setUpViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(showAlertButton)
        title = "Info"
        view.addSubview(personLabel)
        view.addSubview(personPostLabel)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            showAlertButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showAlertButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        personLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaInsets).inset(12)
            $0.leading.trailing.equalTo(view.safeAreaInsets).inset(16)
        }
        
        personPostLabel.snp.makeConstraints {
            $0.top.equalTo(personLabel.snp.bottom).offset(14)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
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
    
    private func fetchPerson() {
        let stringUrl = "https://jsonplaceholder.typicode.com/users/1"
        let url = URL(string: stringUrl)!
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error {
                print(error.localizedDescription)
                return
            }
            
            guard let data else {
                print("No data")
                return
            }
            
            do {
                let result = try JSONSerialization.jsonObject(with: data) as! [String: Any]
                let userName = result["name"] as! String
                
                DispatchQueue.main.async {
                    self.personLabel.text = "Person: \(userName)"
                }
            } catch {
                print(error.localizedDescription)
            }
            
        }.resume()
    }
    
    private func fetchPersonPost() {
        let stringUrl = "https://jsonplaceholder.typicode.com/posts/1"
        let url = URL(string: stringUrl)!
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error {
                print(error.localizedDescription)
                return
            }
            
            guard let data else {
                print("No data")
                return
            }
            
            do {
                let personPost = try JSONDecoder().decode(PersonPost.self, from: data)
                
                DispatchQueue.main.async {
                    self.personPostLabel.text = "Person post: \(personPost.body)"
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}
