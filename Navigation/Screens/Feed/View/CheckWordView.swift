//
//  CheckWordView.swift
//  Navigation
//
//  Created by Razumov Pavel on 03.06.2025.
//

import UIKit

final class CheckWordView: UIView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "Проверьте слово"
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите слово"
        textField.backgroundColor = .secondarySystemBackground
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var checkButton: CustomButton = {
        let button = CustomButton(title: "Проверить") { [weak self] in
            self?.onCheckTap?()
        }
        return button
    }()
    
    private lazy var checkStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, textField, checkButton])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var onCheckTap: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(checkStackView)
    }
    
    private func setConstraints() {
        textField.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        
        checkStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func updateTitleColor(_ isValid: Bool) {
        titleLabel.textColor = isValid ? .systemGreen : .systemRed
    }
    
    func getInputText() -> String? {
        textField.text
    }
}
