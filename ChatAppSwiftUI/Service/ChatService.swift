//
//  ChatService.swift
//  ChatAppSwiftUI
//
//  Created by omar thamri on 21/3/2024.
//

import Foundation
import Firebase

class ChatService {
    
    let chatPartner: User
    @Published var count = 0
    
    init(chatPartner: User) {
        self.chatPartner = chatPartner
    }
    
    func sendMessage(_ messageText: String, isImage: Bool?,isVideo: Bool?,isAudio: Bool?) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let chatPartnerId = chatPartner.id
        let currentUserRef = FirestoreConstants.messageCollection.document(currentUid).collection(chatPartnerId).document()
        let chatPartnerRef = FirestoreConstants.messageCollection.document(chatPartnerId).collection(currentUid)
        let latestCurrentUserRef = FirestoreConstants.messageCollection.document(currentUid).collection("latest-messages").document(chatPartnerId)
        let latestPartnerRef = FirestoreConstants.messageCollection.document(chatPartnerId).collection("latest-messages").document(currentUid)
        let messageId = currentUserRef.documentID
        let message = Message(messageId: messageId, fromId: currentUid, toId: chatPartnerId, messageText: messageText, timestamp: Timestamp(), isImage: isImage, isVideo: isVideo, isAudio: isAudio)
        guard let messageData = try? Firestore.Encoder().encode(message) else { return }
        currentUserRef.setData(messageData)
        chatPartnerRef.document(messageId).setData(messageData)
        latestCurrentUserRef.setData(messageData)
        latestPartnerRef.setData(messageData)
    }
    
    func observeMessages(completion: @escaping([Message]) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let query = FirestoreConstants.messageCollection.document(currentUid).collection(chatPartner.id).order(by: "timestamp", descending: false)
        query.addSnapshotListener { snapshot, _ in
            guard let changes = snapshot?.documentChanges.filter({$0.type == .added}) else { return }
            var messages = changes.compactMap({try? $0.document.data(as: Message.self)})
            for(index,message) in messages.enumerated() where !message.isFromCurrentUser {
                messages[index].user = self.chatPartner
            }
            DispatchQueue.main.async {
                self.count += 1
            }
            completion(messages)
        }
    }
    
    
}
