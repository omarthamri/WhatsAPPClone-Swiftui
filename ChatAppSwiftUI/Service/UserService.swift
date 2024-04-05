//
//  UserService.swift
//  ChatAppSwiftUI
//
//  Created by omar thamri on 20/3/2024.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class UserService {
    
    @Published var currentUser: User?
    
    static let shared = UserService()
    
    init() {
            Task { try await fetchCurrentUser() }
        }
    
    @MainActor
    func fetchCurrentUser() async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
        let user = try snapshot.data(as: User.self)
        self.currentUser = user
    }
    
    static func fetchAllUsers(limit: Int? = nil) async throws -> [User] {
        let query = FirestoreConstants.userCollection
        if let limit { query.limit(to: limit) }
        let snapshot = try await query.getDocuments()
        let users = snapshot.documents.compactMap({ try? $0.data(as: User.self)})
        return users
    }
    
    static func fetchUser(withUid uid: String, completion: @escaping(User) -> Void) {
        FirestoreConstants.userCollection.document(uid).getDocument { snapshot, _ in
            guard let user = try? snapshot?.data(as: User.self) else { return }
            completion(user)
        }
    }
    
    @MainActor
        func updateUserProfileImage(withImageUrl imageUrl: String) async throws {
            guard let currentUid = Auth.auth().currentUser?.uid else { return }
            try await Firestore.firestore().collection("users").document(currentUid).updateData([
                "profileImageUrl": imageUrl
            ])
            self.currentUser?.profileImageUrl = imageUrl
        }
    
}
