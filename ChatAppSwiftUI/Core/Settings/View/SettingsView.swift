//
//  SettingsView.swift
//  ChatAppSwiftUI
//
//  Created by omar thamri on 25/3/2024.
//

import SwiftUI
import PhotosUI
import Kingfisher

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showPhotoPicker: Bool = false
    @StateObject private var viewModel = SettingsViewModel()
    var user: User
    var body: some View {
        VStack {
            Button(action: {
                showPhotoPicker.toggle()
            }, label: {
                ZStack(alignment: .bottomTrailing) {
                    ZStack {
                        CircularProfileImageView(user: user, size: .xxLarge)
                        if viewModel.profileImage == Image("no_profile") {
                            KFImage(URL(string: user.profileImageUrl ?? ""))
                                                               .resizable()
                                                               .scaledToFill()
                                                               .frame(width: 120, height: 120)
                                                               .clipShape(Circle())
                                                       } else {
                                                           viewModel.profileImage
                                                               .resizable()
                                                               .scaledToFill()
                                                               .frame(width: 120, height: 120)
                                                               .clipShape(Circle())
                                                       }
                    }
                    .padding(.vertical)
                    Circle()
                        .fill(Color(.darkGray))
                        .frame(width: 40, height: 40)
                        .padding(.bottom,10)
                        .padding(.trailing,10)
                        .overlay {
                            Image(systemName: "camera.fill")
                                .resizable()
                                .frame(width: 16, height: 16)
                                .scaledToFill()
                                .foregroundStyle(.white)
                                .padding(.bottom,10)
                                .padding(.trailing,10)
                        }
                }
            })
            
            VStack(spacing: 32) {
                OptionView(title: "Name", subtitle: user.fullName, imageName: "person.fill",secondSubtitle: "This is not your username or pin. This name will be visible to your WhatsApp contacts.")
                OptionView(title: "About", subtitle: "Hey there! I am using WhatsApp.", imageName: "exclamationmark.circle")
                OptionView(title: "Phone", subtitle: user.phoneNumber, imageName: "phone.fill",canEdit: false)
        }
            Spacer()
         //   }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    Button(action: {
                        Task { try await UserService.shared.fetchCurrentUser() }
                        dismiss()
                    }, label: {
                        Image(systemName: "arrow.backward")
                    })
                    Text("Profile")
                    
                }
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
            }
        }
        .photosPicker(isPresented: $showPhotoPicker, selection: $viewModel.selectedImage)
        
    }
}


struct OptionView: View {
    var title: String
    var subtitle: String
    var imageName: String
    var secondSubtitle: String = ""
    var canEdit: Bool = true
    var body: some View {
        HStack(alignment: secondSubtitle != "" ? .top : .center,spacing: 24) {
            Image(systemName: imageName)
                .resizable()
                .frame(width: 16, height: 16)
                .foregroundStyle(.gray)
                .padding(.top,secondSubtitle != "" ? 12 : 0)
            VStack(alignment: .leading) {
                Text(title)
                    .foregroundStyle(.gray)
                    .font(.headline)
                Text(subtitle)
                    .font(.footnote)
                if secondSubtitle != "" {
                    Text(secondSubtitle)
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .padding(.top,1)
                }
            }
            Spacer()
            if canEdit {
                Image(systemName: "pencil")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundStyle(.gray)
                    .padding(.top,secondSubtitle != "" ? 12 : 0)
            }
        }
        .padding(.leading)
        .padding(.trailing,16)
    }
}
