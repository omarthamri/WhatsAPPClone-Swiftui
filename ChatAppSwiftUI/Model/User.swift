//
//  User.swift
//  ChatAppSwiftUI
//
//  Created by omar thamri on 16/3/2024.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Codable,Identifiable,Hashable {
    
    @DocumentID var uid: String?
    var id: String {
        return uid ?? UUID().uuidString
    }
    let fullName: String
    let email: String
    let phoneNumber: String
    var profileImageUrl: String?
    var firstName: String {
        let formatter = PersonNameComponentsFormatter()
        let components = formatter.personNameComponents(from: fullName)
        return components?.givenName ?? fullName
    }
}

extension User {
    
    static let MOCK_USER = User(fullName: "Elizabeth Olsen", email: "elizabeth.olsen@gmail.com",phoneNumber: "+1111111", profileImageUrl: "elizabeth")
    
}
