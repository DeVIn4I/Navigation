//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Razumov Pavel on 24.03.2025.
//

import UIKit

final class ProfileHeaderView: UIView {
    
    private var user: User?
    private var statusText: String?
    private var backgroundView: UIView?
    private var animateProfileImage: UIImageView?
    private var closeButton: UIButton?
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: .profileImage)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.isUserInteractionEnabled = true
        
        let action = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        imageView.addGestureRecognizer(action)
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
        textFiled.placeholder = "Write something..."
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
    
    func set(user: User?) {
        self.user = user
        updateUserData()
    }
    
    private func setupViews() {
        addSubview(profileImageView)
        addSubview(profileTitleLabel)
        addSubview(profileStatusLabel)
        addSubview(statusTextField)
        addSubview(setStatusButton)
    }
    
    private func updateUserData() {
        guard let user else { return }
        
        profileImageView.image = user.avatar
        profileTitleLabel.text = user.fullName
        profileStatusLabel.text = user.status
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            profileImageView.heightAnchor.constraint(equalToConstant: 80),
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
            setStatusButton.heightAnchor.constraint(equalToConstant: 50),
            setStatusButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    private func showProfileImageFullScreen() {
        guard let window, let user else { return }
        
        let originalProfileImageFrame = convert(profileImageView.frame, to: window)
        let animateProfileImage = UIImageView(image: user.avatar)
        animateProfileImage.frame = originalProfileImageFrame
        animateProfileImage.contentMode = .scaleAspectFit
        animateProfileImage.layer.cornerRadius = 40
        animateProfileImage.clipsToBounds = true
        self.animateProfileImage = animateProfileImage
        
        let backgroundView = UIView(frame: window.bounds)
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0
        self.backgroundView = backgroundView
        
        let closeButton = UIButton(type: .system)
        closeButton.setImage(
            UIImage(
                systemName: "xmark",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .bold)
            ),
            for: .normal
        )
        closeButton.frame = CGRect(x: window.bounds.width - 52, y: 52, width: 46, height: 46)
        closeButton.alpha = 0
        closeButton.tintColor = .white
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        self.closeButton = closeButton
        
        window.addSubview(backgroundView)
        window.addSubview(animateProfileImage)
        window.addSubview(closeButton)
        
        let cornerRadiusAnimate = CABasicAnimation(keyPath: "cornerRadius")
        cornerRadiusAnimate.fromValue = 40
        cornerRadiusAnimate.toValue = 0
        cornerRadiusAnimate.duration = 1
        cornerRadiusAnimate.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animateProfileImage.layer.add(cornerRadiusAnimate, forKey: "cornerRadius")
        animateProfileImage.layer.cornerRadius = 0
        
        UIView.animate(withDuration: 0.5, delay: 0) {
            animateProfileImage.frame = CGRect(
                x: 0,
                y: (window.bounds.height - window.bounds.width) / 2,
                width: window.bounds.width,
                height: window.bounds.width
            )
            backgroundView.alpha = 0.6
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                closeButton.alpha = 1
            }
        }
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
    
    @objc private func profileImageTapped() {
        showProfileImageFullScreen()
    }
    
    @objc private func closeButtonTapped() {
        guard let window = window,
              let animateProfileImage,
              let backgroundView,
              let closeButton
        else { return }
        
        let originalProfileImageFrame = convert(profileImageView.frame, to: window)
        
        let cornerRadiusAnimate = CABasicAnimation(keyPath: "cornerRadius")
        cornerRadiusAnimate.fromValue = 0
        cornerRadiusAnimate.toValue = 40
        cornerRadiusAnimate.duration = 0.5
        cornerRadiusAnimate.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animateProfileImage.layer.add(cornerRadiusAnimate, forKey: "cornerRadius")
        animateProfileImage.layer.cornerRadius = 40
        
        UIView.animate(withDuration: 0.5) {
            closeButton.alpha = 0
            backgroundView.alpha = 0
            animateProfileImage.frame = originalProfileImageFrame
        } completion: { _ in
            closeButton.removeFromSuperview()
            backgroundView.removeFromSuperview()
            animateProfileImage.removeFromSuperview()
        }
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
