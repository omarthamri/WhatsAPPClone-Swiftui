//
//  RegistrationViewModel.swift
//  ChatAppSwiftUI
//
//  Created by omar thamri on 17/3/2024.
//

import SwiftUI

class RegistrationViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var fullName: String = ""
    @Published var phoneNumber: String = ""
    
    func createUser() async throws {
        try await AuthService.shared.createUser(withEmail: email, password: password, fullName: fullName, phoneNumber: phoneNumber)
    }
}
