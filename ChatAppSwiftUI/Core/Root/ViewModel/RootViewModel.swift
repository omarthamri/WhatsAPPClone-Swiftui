//
//  RootViewModel.swift
//  ChatAppSwiftUI
//
//  Created by omar thamri on 18/3/2024.
//

import Foundation
import Firebase
import Combine

class RootViewModel: ObservableObject {
    
    @Published var userSession: FirebaseAuth.User?
    private var cancellable = Set<AnyCancellable>()
    init() {
       setupSubscribers()
    }
    
     private func setupSubscribers() {
        AuthService.shared.$userSession.sink { [weak self] userSession in
            self?.userSession = userSession
        }
        .store(in: &cancellable)
    }
    
}
