//
//  InboxViewModel.swift
//  ChatAppSwiftUI
//
//  Created by omar thamri on 20/3/2024.
//

import Foundation
import Firebase
import Combine

class InboxViewModel: ObservableObject {
    
    @Published var currentUser: User?
    @Published var latestMessages = [Message]()
    private var cancellables = Set<AnyCancellable>()
    private let service = InboxService()
    
    init() {
        setupSubscribers()
        service.observeLatestMessages()
    }
    
    private func setupSubscribers() {
        UserService.shared.$currentUser.sink { [weak self] currentUser in
            self?.currentUser = currentUser
        }
        .store(in: &cancellables)
        service.$documentChanges.sink { [weak self] changes in
            self?.loadInitialMessages(fromChanges: changes)
        }
        .store(in: &cancellables)
    }
    
    private func loadInitialMessages(fromChanges changes: [DocumentChange]) {
        var messages = changes.compactMap({  try? $0.document.data(as: Message.self) })
        for i in 0 ..< messages.count {
            let message = messages[i]
            UserService.fetchUser(withUid: message.chatPartnerId) { user in
                messages[i].user = user
                if let index = self.latestMessages.lastIndex(where: {$0.user == messages[i].user}) {
                    self.latestMessages.remove(at: index)
                }
                self.latestMessages.insert(messages[i], at: 0)
            }
        }
    }
}
