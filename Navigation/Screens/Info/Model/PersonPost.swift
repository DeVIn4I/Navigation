//
//  PersonPost.swift
//  Navigation
//
//  Created by Razumov Pavel on 09.07.2025.
//

import Foundation

struct PersonPost: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
