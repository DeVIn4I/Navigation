//
//  PhotosViewController.swift
//  Navigation
//
//  Created by Razumov Pavel on 29.03.2025.
//

import UIKit
import iOSIntPackage

final class PhotosViewController: UIViewController {
    
    static let reuseID = "PhotosTableViewCell"
    
    private let imageProcessor = ImageProcessor()
    private let selectedFilter = ColorFilter.fade
    private var photos: [Photo] = []
    
    private let paramCollection = UICollectionView.GeometricParameters(
        cellCount: 3,
        leftInsert: 8,
        rightInsert: 8,
        cellSpacing: 8
    )
    
    private lazy var photosCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(
            PhotosCollectionViewCell.self,
            forCellWithReuseIdentifier: PhotosCollectionViewCell.identifier
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView.withConstraints()
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        
        processImages(qos: .userInitiated)
    }
    
    private func processImages(qos: QualityOfService) {
        let photos = Photo.makePhotos().map { $0.image }
        let startTime = CFAbsoluteTimeGetCurrent()
        
        imageProcessor.processImagesOnThread(
            sourceImages: photos,
            filter: selectedFilter,
            qos: qos) { [weak self] images in
                guard let self else { return }
                let endTime = CFAbsoluteTimeGetCurrent() - startTime
                print("🧪 Обработка QoS: \(qos), фильтр: \(self.selectedFilter) заняла: \(endTime) сек")
                
                let photos = images
                    .compactMap { $0 }
                    .map { Photo(image: UIImage(cgImage: $0)) }
                
                DispatchQueue.main.async {
                    self.photos = photos
                    self.photosCollection.reloadData()
                }
            }
    }
    
    private func setupViews() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        
        title = "Photo Gallery"
        view.backgroundColor = .systemBackground
        [photosCollection].forEach { view.addSubview($0) }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            photosCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            photosCollection.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            photosCollection.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            photosCollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension PhotosViewController: UICollectionViewDataSource {
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
        cell.configure(with: photo.image)
        return cell
    }
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - paramCollection.paddingWidth
        let cellWidth = availableWidth / CGFloat(paramCollection.cellCount)
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: paramCollection.cellSpacing,
            left: paramCollection.leftInsert,
            bottom: paramCollection.cellSpacing,
            right: paramCollection.rightInsert
        )
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return paramCollection.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return paramCollection.cellSpacing
    }
}
