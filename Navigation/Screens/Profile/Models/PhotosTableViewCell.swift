//
//  PhotosTableViewCell.swift
//  Navigation
//
//  Created by Razumov Pavel on 29.03.2025.
//

import UIKit

final class PhotosTableViewCell: UITableViewCell {

    private let paramCollection = UICollectionView.GeometricParameters(
        cellCount: 4,
        leftInsert: 12,
        rightInsert: 12,
        cellSpacing: 8
    )
    
    private var photos = Photo.makePreviewPhotos()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.text = "Photos"
        return label.withConstraints()
    }()
    
    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "arrow.right"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        return imageView.withConstraints()
    }()
    
    private lazy var previewCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(
            PhotosCollectionViewCell.self,
            forCellWithReuseIdentifier: PhotosCollectionViewCell.identifier
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isUserInteractionEnabled = false
        return collectionView.withConstraints()
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
            titleLabel, arrowImageView,
            previewCollectionView
        ].forEach { contentView.addSubview($0) }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            arrowImageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            arrowImageView.heightAnchor.constraint(equalToConstant: 26),
            arrowImageView.widthAnchor.constraint(equalToConstant: 26),
            
            previewCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            previewCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            previewCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            previewCollectionView.heightAnchor.constraint(equalToConstant: 80),
            previewCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
        ])
    }
}

extension PhotosTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PhotosCollectionViewCell.identifier,
            for: indexPath
        ) as? PhotosCollectionViewCell else {
            return UICollectionViewCell()
        }
        let photo = photos[indexPath.item]
        cell.configure(with: photo.image, needCorners: true)
        return cell
    }
}

extension PhotosTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - paramCollection.paddingWidth
        let cellWidth = availableWidth / CGFloat(paramCollection.cellCount)
        return CGSize(width: cellWidth, height: cellWidth * 0.8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: paramCollection.leftInsert, bottom: 0, right: paramCollection.rightInsert)
    }
}
