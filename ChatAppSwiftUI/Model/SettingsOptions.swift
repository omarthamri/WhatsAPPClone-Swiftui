//
//  SettingsOptions.swift
//  ChatAppSwiftUI
//
//  Created by omar thamri on 25/3/2024.
//

import Foundation
import SwiftUI

enum SettingsOptions: Int,CaseIterable,Identifiable {
  
    case account
    case privacy
    case avatar
    case chats
    case notifications
    case storageAndData
    case appLanguage
    case help
    case inviteFriend
    case logout
    var id: Int { return self.rawValue }
    
    var title: String {
        switch self {
        case .account:
            return "Account"
        case .privacy:
            return "Privacy"
        case .avatar:
            return "Avatar"
        case .chats:
            return "Chats"
        case .notifications:
            return "Notifications"
        case .storageAndData:
            return "Storage and data"
        case .appLanguage:
            return "App language"
        case .help:
            return "help"
        case .inviteFriend:
            return "Invite a friend"
        case .logout:
            return "Logout"
        }
    }
    
    var subtitle: String {
        switch self {
        case .account:
            return "Security notifications, change number"
        case .privacy:
            return "Block contacts, disappearing messages"
        case .avatar:
            return "create, edit profile photo"
        case .chats:
            return "Theme,wallpapers, chat history"
        case .notifications:
            return "Message, group & call tones"
        case .storageAndData:
            return "Network usage, auto-download"
        case .appLanguage:
            return "English (device's language)"
        case .help:
            return "help centre, contact us, privacy policy"
        case .inviteFriend:
            return ""
        case .logout:
            return ""
        }
    }
    
    var imageName: String {
        switch self {
        case .account:
            return "key.fill"
        case .privacy:
            return "lock.fill"
        case .avatar:
            return "face.smiling.inverse"
        case .chats:
            return "text.bubble.fill"
        case .notifications:
            return "bell.fill"
        case .storageAndData:
            return "circle.dotted.circle.fill"
        case .appLanguage:
            return "map.circle.fill"
        case .help:
            return "questionmark.circle"
        case .inviteFriend:
            return "person.2.fill"
        case .logout:
            return "rectangle.portrait.and.arrow.right.fill"
        }
    }
    
    
}
