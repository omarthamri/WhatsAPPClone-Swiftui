//
//  NewMessageView.swift
//  ChatAppSwiftUI
//
//  Created by omar thamri on 15/3/2024.
//

import SwiftUI
import Kingfisher

struct NewMessageView: View {
    @State private var searchText = ""
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedUser: User?
    @StateObject private var viewModel = NewMessageViewModel()
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading,spacing: 24) {
                    HStack(spacing: 16) {
                        Image(systemName: "person.2.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundStyle(.gray)
                        Text("New group")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    HStack(spacing: 16) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundStyle(.gray)
                        Text("New contact")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    HStack(spacing: 16) {
                        Image(systemName: "shared.with.you.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundStyle(.gray)
                        Text("New community")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Spacer()
                    }
                }
                .padding(.top)
                .padding(.horizontal)
                Text("Contacts on WhatsApp")
                    .foregroundStyle(Color(.darkGray))
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                ForEach (viewModel.users) { user in
                    VStack {
                        HStack {
                            
                            ZStack {
                                CircularProfileImageView(user: user , size: .small)
                                KFImage(URL(string: user.profileImageUrl ?? ""))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)
                                    .foregroundStyle(Color(.systemGray4))
                                    .clipShape(Circle())
                            }
                            VStack(alignment: .leading) {
                                Text(user.fullName)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                Text("Hey there! I am using WhatsApp.")
                                    .font(.footnote)
                                    .foregroundStyle(.gray)
                            }
                            
                            Spacer()
                        }
                        .padding(.leading)
                    }
                    .padding(.bottom,20)
                    .onTapGesture {
                        selectedUser = user
                        dismiss()
                    }
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        HStack(spacing: 16) {
                            Image(systemName: "arrow.backward")
                            VStack(alignment: .leading) {
                                Text("Select contact")
                                    .font(.subheadline)
                                Text("\(viewModel.users.count) contacts")
                                    .font(.caption2)
                            }
                        }
                        .foregroundStyle(.white)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 24) {
                      Image(systemName: "magnifyingglass")
                      Image(systemName: "ellipsis")
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                }
        }
        }
    }
}

#Preview {
    NewMessageView(selectedUser: .constant(User.MOCK_USER))
}
