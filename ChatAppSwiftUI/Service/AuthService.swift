//
//  AuthService.swift
//  ChatAppSwiftUI
//
//  Created by omar thamri on 17/3/2024.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift


class AuthService {
    
    @Published var userSession: FirebaseAuth.User?
    
    static let shared = AuthService()
    
    init() {
        self.userSession = Auth.auth().currentUser
        loadCurrentUserData()
    }
    @MainActor
    func login(withEmail email: String,password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            loadCurrentUserData()
        } catch {
            print("failed to login with error \(error.localizedDescription)")
        }
    }
    @MainActor
    func createUser(withEmail email: String,password: String,fullName: String, phoneNumber: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            try await  self.uploadUserData(email: email, fullname: fullName, phoneNumber: phoneNumber, id: result.user.uid)
            loadCurrentUserData()
        } catch {
            print("failed to create user with error \(error.localizedDescription)")
        }
    }
    
    func signout() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            UserService.shared.currentUser = nil
        } catch {
            print("failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    private func uploadUserData(email: String, fullname: String,phoneNumber: String,id: String) async throws {
        let user = User(fullName: fullname, email: email, phoneNumber: phoneNumber)
        guard let encodedUser = try? Firestore.Encoder().encode(user) else { return }
        try await Firestore.firestore().collection("users").document(id).setData(encodedUser)
    }
    
    private func loadCurrentUserData() {
        Task { try await UserService.shared.fetchCurrentUser()}
    }
    
}
