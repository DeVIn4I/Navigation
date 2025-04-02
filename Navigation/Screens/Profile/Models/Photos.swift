//
//  Photos.swift
//  Navigation
//
//  Created by Razumov Pavel on 29.03.2025.
//

import UIKit

struct Photo {
    let image: UIImage
}

extension Photo {
    static func makePreviewPhotos() -> [Photo] {
        var photos: [Photo] = []
        for i in 1...4 {
            if let image = UIImage(named: "\(i)") {
                photos.append(Photo(image: image))
            }
        }
        return photos
    }
    
    static func makePhotos() -> [Photo] {
        var photos: [Photo] = []
        for i in 1...Int.lastPhotoIndex {
            if let image = UIImage(named: "\(i)") {
                photos.append(Photo(image: image))
            }
        }
        return photos
    }
}

private extension Int {
    ///Индекс последнего фото для ленты Phots
    static let lastPhotoIndex = 24
}
