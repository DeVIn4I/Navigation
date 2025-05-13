//
//  PostTableViewCell.swift
//  Navigation
//
//  Created by Razumov Pavel on 28.03.2025.
//

import UIKit
import StorageService
import iOSIntPackage

final class PostTableViewCell: UITableViewCell {
    
    static let reuseID = "PostTableViewCell"
    private let imageProcessor = ImageProcessor()

    private lazy var authorTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 2
        label.textColor = .black
        return label.withConstraints()
    }()
    
    private lazy var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        return imageView.withConstraints()
    }()
    
    private lazy var descriptionPostLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .lightGray
        return label.withConstraints()
    }()
    
    private lazy var likesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private lazy var viewsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private lazy var likesAndViewsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [likesLabel, viewsLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 14
        return stackView.withConstraints()
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        [
            authorTitleLabel, postImageView,
            descriptionPostLabel, likesAndViewsStackView
        ].forEach { contentView.addSubview($0) }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            authorTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            authorTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            postImageView.topAnchor.constraint(equalTo: authorTitleLabel.bottomAnchor, constant: 12),
            postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            postImageView.heightAnchor.constraint(equalTo: postImageView.widthAnchor),

            descriptionPostLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 16),
            descriptionPostLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionPostLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            likesAndViewsStackView.topAnchor.constraint(equalTo: descriptionPostLabel.bottomAnchor, constant: 16),
            likesAndViewsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            likesAndViewsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            likesAndViewsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    func configure(with model: Post) {
        guard let image = UIImage(named: model.image) else { return }
        
        imageProcessor.processImage(
            sourceImage: image,
            filter: .crystallize(radius: 8)
        ) { image in
            postImageView.image = image
        }
        
        authorTitleLabel.text = model.author
        descriptionPostLabel.text = model.description
        likesLabel.text = "Likes: \(model.likes)"
        viewsLabel.text = "Views: \(model.views)"
    }
}
