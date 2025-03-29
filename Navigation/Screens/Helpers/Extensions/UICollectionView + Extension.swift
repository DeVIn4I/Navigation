//
//  UICollectionView + Extension.swift
//  Navigation
//
//  Created by Razumov Pavel on 29.03.2025.
//

import UIKit

extension UICollectionView {
    struct GeometricParameters {
        let cellCount: Int
        let leftInsert: CGFloat
        let rightInsert: CGFloat
        let cellSpacing: CGFloat
        let paddingWidth: CGFloat
        
        init(cellCount: Int, leftInsert: CGFloat, rightInsert: CGFloat, cellSpacing: CGFloat) {
            self.cellCount = cellCount
            self.leftInsert = leftInsert
            self.rightInsert = rightInsert
            self.cellSpacing = cellSpacing
            self.paddingWidth = leftInsert + rightInsert + CGFloat(cellCount - 1) * cellSpacing
        }
    }
}
