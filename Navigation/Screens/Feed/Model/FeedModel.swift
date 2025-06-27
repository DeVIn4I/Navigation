//
//  FeedModel.swift
//  Navigation
//
//  Created by Razumov Pavel on 03.06.2025.
//

import UIKit

protocol FeedModelProtocol {
    func check(_ password: String?) -> Bool
}

final class FeedModel: FeedModelProtocol {
    private let secretWord = "Secret"
    
    func check(_ password: String?) -> Bool {
        guard let password = password else {
            return false 
        }
        return password == secretWord
    }
}
