//
//  NewMessageViewModel.swift
//  ChatAppSwiftUI
//
//  Created by omar thamri on 20/3/2024.
//

import Foundation
import Firebase

@MainActor
class NewMessageViewModel: ObservableObject {
    
    @Published var users = [User]()
    
    init() {
        Task { try await fetchUsers() }
    }
    
    func fetchUsers() async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let users = try await UserService.fetchAllUsers()
        self.users = users.filter({ $0.id != uid })
    }
}
