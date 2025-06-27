//
//  ProfileHeaderViewViewModel.swift
//  Navigation
//
//  Created by Razumov Pavel on 05.06.2025.
//

import Foundation

final class ProfileHeaderViewViewModel {
    
    private(set) var user: User?
    private(set) var statusText: String = .defaultStatusText
    
    var updateStatusText: ((String) -> Void)?
    
    init(user: User?) {
        self.user = user
    }
    
    func updateStatus(_ status: String) {
        let currentStatus = status.isEmpty ? .defaultStatusText : status
        updateStatusText?(currentStatus)
    }
}
