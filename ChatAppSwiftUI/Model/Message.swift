//
//  Message.swift
//  ChatAppSwiftUI
//
//  Created by omar thamri on 20/3/2024.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift


struct Message: Identifiable,Hashable, Codable {
    @DocumentID var messageId: String?
    let fromId: String
    let toId: String
    let messageText: String
    let timestamp: Timestamp
    let isImage: Bool?
    let isVideo: Bool?
    let isAudio: Bool?
    var user: User?
    var id: String {
        return messageId ?? UUID().uuidString
    }
    var chatPartnerId: String {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
    var isFromCurrentUser: Bool {
        return fromId == Auth.auth().currentUser?.uid
    }
    var timestampString: String {
        return timestamp.dateValue().timestampString()
    }
    var timeString: String {
        return timestamp.dateValue().timeString()
    }
}

struct MessageGroup: Identifiable,Hashable {
    var id: String {
        return UUID().uuidString
    }
    let date: Date
    var messages: [Message]
}
