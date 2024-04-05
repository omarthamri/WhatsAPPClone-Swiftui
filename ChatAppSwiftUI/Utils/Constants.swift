//
//  Constants.swift
//  ChatAppSwiftUI
//
//  Created by omar thamri on 21/3/2024.
//

import Foundation
import Firebase

struct FirestoreConstants {
    
    static let userCollection = Firestore.firestore().collection("users")
    static let messageCollection = Firestore.firestore().collection("messages")
    
}
