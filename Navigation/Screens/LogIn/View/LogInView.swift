//
//  LogInView.swift
//  Navigation
//
//  Created by Razumov Pavel on 26.03.2025.
//

import UIKit

final class LogInView: UIView {
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        return imageView
    }().withConstraints()
    
    private lazy var emailTextField = LogInTextField(title: "Email of phone")
    private lazy var passwordTextField = LogInTextField(title: "Password", isSecureText: true)
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        view.isUserInteractionEnabled = false
        return view.withConstraints()
    }()
    
    private lazy var logInStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            emailTextField,
            separatorView,
            passwordTextField
        ])
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.layer.cornerRadius = 10
        stackView.clipsToBounds = true
        stackView.layer.borderColor = UIColor.lightGray.cgColor
        stackView.layer.borderWidth = 0.5
        return stackView.withConstraints()
    }()
    
    private lazy var logInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.setBackgroundImage(UIImage(named: "blue_pixel"), for: .normal)
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(logInButtonTapped), for: .touchUpInside)
        button.alpha = 0.8
        button.isUserInteractionEnabled = false
        return button.withConstraints()
    }()
    
    private lazy var choosePasswordButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.titleLabel?.textColor = .systemBlue
        btn.setTitle("Подобрать пароль", for: .normal)
        btn.addTarget(self, action: #selector(bruteForcePassword), for: .touchUpInside)
        return btn.withConstraints()
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        return activityIndicator.withConstraints()
    }()
    
    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = .systemFont(ofSize: 28, weight: .medium)
        label.textColor = .red
        label.isHidden = true
        return label.withConstraints()
    }()
    
    private var counter: Int = 0
    private var timer: Timer?
    
    var logInButtonTappedCallback: ((String, String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        
        emailTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func resetUserData() {
        emailTextField.text = nil
        passwordTextField.text = nil
        emailTextField.becomeFirstResponder()
        textFieldChanged()
    }
    
    @objc private func textFieldChanged() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text
        else { return }
        
        if !email.isEmpty && !password.isEmpty {
            logInButton.alpha = 1
            logInButton.isUserInteractionEnabled = true
        } else {
            logInButton.alpha = 0.8
            logInButton.isUserInteractionEnabled = false
        }
    }
    
    @objc private func logInButtonTapped() {
        guard
            let login = emailTextField.text,
            let password = passwordTextField.text
        else { return }
        logInButtonTappedCallback?(login, password)
    }
    
    @objc
    private func bruteForcePassword() {
        startTimer()
        passwordTextField.text = nil
        activityIndicator.startAnimating()
        choosePasswordButton.isUserInteractionEnabled = false
        choosePasswordButton.tintColor = .systemGray
        
        DispatchQueue.global(qos: .background).async {
            let ALLOWED_CHARACTERS:   [String] = String().printable.map { String($0) }
            let currentPassword = Checker.shared.getPassword
            var password: String = ""
            
            while password != currentPassword {
                password = BruteForce.shared.generateBruteForce(password, fromArray: ALLOWED_CHARACTERS)
            }
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.passwordTextField.isSecureTextEntry = false
                self.passwordTextField.text = password
                self.textFieldChanged()
                self.choosePasswordButton.isUserInteractionEnabled = true
                self.choosePasswordButton.tintColor = .systemBlue
                self.stopTimer()
            }
        }
    }
    
    private func setupViews() {
        addSubview(logoImageView)
        addSubview(logInStackView)
        addSubview(logInButton)
        addSubview(choosePasswordButton)
        addSubview(timerLabel)
        passwordTextField.addSubview(activityIndicator)
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: topAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            
            
            emailTextField.heightAnchor.constraint(equalToConstant: 49.75),
            passwordTextField.heightAnchor.constraint(equalToConstant: 49.75),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),
            
            logInStackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 120),
            logInStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            logInStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            logInStackView.heightAnchor.constraint(equalToConstant: 100),
            
            logInButton.topAnchor.constraint(equalTo: logInStackView.bottomAnchor, constant: 16),
            logInButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            logInButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            logInButton.heightAnchor.constraint(equalToConstant: 50),
            
            choosePasswordButton.topAnchor.constraint(equalTo: logInButton.bottomAnchor, constant: 16),
            choosePasswordButton.trailingAnchor.constraint(equalTo: logInButton.trailingAnchor),
            choosePasswordButton.heightAnchor.constraint(equalToConstant: 30),
            choosePasswordButton.widthAnchor.constraint(equalToConstant: 150),
            
            activityIndicator.centerXAnchor.constraint(equalTo: passwordTextField.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor),
            
            timerLabel.topAnchor.constraint(equalTo: choosePasswordButton.bottomAnchor, constant: 16),
            timerLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            timerLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func startTimer() {
        timerLabel.isHidden = false
        timerLabel.text = "\(counter)"
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self else { return }
            counter += 1
            timerLabel.text = "\(counter)"
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        counter = 0
    }
}

extension LogInView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.returnKeyType = .done
            passwordTextField.becomeFirstResponder()
        } else {
            passwordTextField.resignFirstResponder()
        }
        return true
    }
}
