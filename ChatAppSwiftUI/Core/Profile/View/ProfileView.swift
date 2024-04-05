//
//  ProfileView.swift
//  ChatAppSwiftUI
//
//  Created by omar thamri on 16/3/2024.
//

import SwiftUI
import PhotosUI
import Kingfisher

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    let user: User
    @Environment(\.dismiss) private var dismiss
    @State var tabBarVisibility: Visibility = .hidden
    var body: some View {
        ScrollView {
            VStack {
                NavigationLink {
                    SettingsView(user: user)
                        .navigationBarBackButtonHidden()
                } label: {
                    HStack(spacing: 12) {
                        ZStack {
                            CircularProfileImageView(user: user, size: .large)
                            KFImage(URL(string: viewModel.currentUser?.profileImageUrl ?? ""))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 64, height: 64)
                                .foregroundStyle(Color(.systemGray4))
                                .clipShape(Circle())
                        }
                        VStack(alignment: .leading,spacing: 8) {
                            Text(user.fullName)
                                .font(.headline)
                                .fontWeight(.semibold)
                            Text("Hey there! I am using WhatsApp")
                                .font(.footnote)
                                .foregroundStyle(.gray)
                        }
                        Spacer()
                        
                    }
                    .padding(.horizontal)
                }
                Divider()
                    .padding(.vertical)
                VStack(spacing: 32) {
                    ForEach(SettingsOptions.allCases) { option in
                        Button {
                            if option.rawValue == 9 {
                                AuthService.shared.signout()
                            }
                        } label: {
                            HStack(spacing: 24) {
                                Image(systemName: option.imageName)
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                    .foregroundStyle(.gray)
                                VStack(alignment: .leading) {
                                    Text(option.title)
                                        .font(.headline)
                                    if option.subtitle != "" {
                                        Text(option.subtitle)
                                            .foregroundStyle(.gray)
                                            .font(.footnote)
                                    }
                                }
                                Spacer()
                            }
                        }
                            
                    }
                }
                .padding(.horizontal)
            }
            .padding(.top)
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(tabBarVisibility,for: .tabBar)
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    HStack {
                        Button(action: {
                            tabBarVisibility = .visible
                            dismiss()
                        }, label: {
                            Image(systemName: "arrow.backward")
                        })
                        Text("Settings")
                            
                    }
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Image(systemName: "magnifyingglass")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                }
        }
        }
    }
}

#Preview {
    ProfileView(user: User.MOCK_USER)
}
