//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Razumov Pavel on 24.03.2025.
//

import UIKit

final class ProfileHeaderView: UIView {
    
    private var statusText: String?
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: .profileImage)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView.withConstraints()
    }()
    
    private lazy var profileTitleLabel = UILabel(
        text: .profileTitle,
        font: .systemFont(ofSize: 18, weight: .bold),
        textColor: .black
    ).withConstraints()
    
    private lazy var profileStatusLabel = UILabel(
        text: .defaultStatusText,
        font: .systemFont(ofSize: 14, weight: .regular),
        textColor: .gray,
        lines: 2
    ).withConstraints()
    
   private lazy var statusTextField: UITextField = {
       let textFiled = UITextField()
       textFiled.placeholder = "Write something"
       textFiled.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
       textFiled.leftViewMode = .always
       textFiled.font = .systemFont(ofSize: 15, weight: .regular)
       textFiled.textColor = .black
       textFiled.layer.cornerRadius = 12
       textFiled.layer.borderWidth = 1
       textFiled.layer.borderColor = UIColor.black.cgColor
       textFiled.backgroundColor = .white
       textFiled.addTarget(self, action: #selector(statusTextChanged), for: .editingChanged)
       return textFiled.withConstraints()
   }()
    
    private lazy var setStatusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.setTitle(.setStatusTitle, for: .normal)
        button.layer.cornerRadius = 12
        button.backgroundColor = .systemBlue
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.7
        button.addTarget(self, action: #selector(setStatusButtonTapped), for: .touchUpInside)
        return button.withConstraints()
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2
    }
    
    private func setupViews() {
        addSubview(profileImageView)
        addSubview(profileTitleLabel)
        addSubview(profileStatusLabel)
        addSubview(statusTextField)
        addSubview(setStatusButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            profileImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.16),
            profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor),
        
            profileTitleLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 12),
            profileTitleLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 22),
       
            profileStatusLabel.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: -18),
            profileStatusLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 22),
            profileStatusLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
    
            statusTextField.topAnchor.constraint(equalTo: profileStatusLabel.bottomAnchor, constant: 12),
            statusTextField.leadingAnchor.constraint(equalTo: profileStatusLabel.leadingAnchor),
            statusTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            statusTextField.heightAnchor.constraint(equalToConstant: 40),
        
            setStatusButton.topAnchor.constraint(equalTo: statusTextField.bottomAnchor, constant: 16),
            setStatusButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            setStatusButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            setStatusButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func statusTextChanged(_ textField: UITextField) {
        statusText = textField.text ?? ""
    }
    
    @objc private func setStatusButtonTapped() {
        if let text = statusText, text.isEmpty == false {
            profileStatusLabel.text = text
        } else {
            profileStatusLabel.text = .defaultStatusText
        }
        statusTextField.text = nil
        statusTextField.resignFirstResponder()
    }
}

private extension String {
    ///Название изображения для отображения профиля
    static let profileImage = "profileImage"
    ///Название изображения для отображения профиля
    static let profileTitle = "iOS-Developer"
    ///Тайтл для кнопки "Установить статус"
    static let setStatusTitle = "Set status"
    ///Текст статуса по умолчанию
    static let defaultStatusText = "Write something about yourself"
}
