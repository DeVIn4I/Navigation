//
//  NetworkService.swift
//  Navigation
//
//  Created by Razumov Pavel on 08.07.2025.
//

import Foundation

enum AppConfiguration {
    case product(String)
    case debug(String)
    case release(String)
}

struct NetworkService {
    
    static func request(for configuration: AppConfiguration) {
        switch configuration {
        case .product(let string):
            makeRequest(with: string)
        case .debug(let string):
            makeRequest(with: string)
        case .release(let string):
            makeRequest(with: string)
        }
    }
    
    private static func makeRequest(with stringURL: String) {
        let url = URL(string: stringURL)!
        let session = URLSession.shared
        session.dataTask(with: url) { data, response, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
        }.resume()
    }
}
