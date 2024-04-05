//
//  ChatView.swift
//  ChatAppSwiftUI
//
//  Created by omar thamri on 17/3/2024.
//

import SwiftUI
import Kingfisher
import PhotosUI

struct ChatView: View {
    @StateObject private var viewModel: ChatViewModel
    let user: User
    @Environment(\.dismiss) private var dismiss
    @State var tabBarVisibility: Visibility = .hidden
    @State private var showPhotoPicker: Bool = false
    @State private var showVideoPicker: Bool = false
    
    init(user: User) {
        self.user = user
        self._viewModel = StateObject(wrappedValue: ChatViewModel(user: user))
    }
    
    private let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            return formatter
        }()
    
    var body: some View {
        VStack {
                ScrollView {
                    ScrollViewReader { proxy in
                    // messages
                        VStack {
                            ForEach(viewModel.messageGroups) { group in
                                Section(header:
                                            Capsule()
                                    .fill(Color(.systemGray5))
                                    .frame(width: 120,height: 44)
                                    .overlay{
                                        Text(group.date.chatTimestampString())
                                    }
                                ) {
                                    ForEach(group.messages) { message in
                                        ChatMessageCell(message: message)
                                    }
                                }
                            }
                            .padding(.top)
                            HStack { Spacer() }
                                .id("Empty")
                        }
                        .onReceive(viewModel.$count) { _ in
                            withAnimation(.easeOut(duration: 0.5)) {
                                proxy.scrollTo("Empty", anchor: .top)
                            }
                        }
                }
            }
                // message input view
                Spacer()
                HStack {
                    ZStack {
                        EmojiTextField(text: $viewModel.messageText, placeholder: "Message...", isEmoji: $viewModel.isEmoji)
                            .padding(12)
                            .padding(.trailing,48)
                            .padding(.leading,32)
                            .background(Color(.systemGroupedBackground))
                            .clipShape(Capsule())
                            .font(.subheadline)
                            .frame(height: 25)
                        HStack {
                            Button(action: {
                                viewModel.isEmoji.toggle()
                            }, label: {
                                Image(systemName: "face.smiling")
                                    .foregroundStyle(.gray)
                            })
                            .padding(.horizontal)
                            Spacer()
                            HStack {
                                Button(action: {
                                    showVideoPicker.toggle()
                                }, label: {
                                    Image(systemName: "paperclip")
                                        .foregroundStyle(.gray)
                                })
                                Button(action: {
                                    showPhotoPicker.toggle()
                                }, label: {
                                    Image(systemName: "camera.fill")
                                        .foregroundStyle(.gray)
                                })
                            }
                            .padding(.horizontal)
                        }
                    }
                    Button {
                        if viewModel.messageText != "" {
                            viewModel.sendMessage(isImage: false, isVideo: false, isAudio: false)
                            viewModel.messageText = ""
                        } else {
                            if !viewModel.isRecording {
                                viewModel.startRecording()
                                viewModel.isRecording = true
                            } else {
                                viewModel.stopRecording()
                                viewModel.isRecording = false
                            }
                        }
                    } label: {
                        if !viewModel.isRecording {
                            Image(systemName: viewModel.messageText == "" ? "mic.circle.fill" : "arrowtriangle.right.circle.fill")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .foregroundStyle(Color(.darkGray))
                        } else {
                            Image(systemName: "stop.circle.fill")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .foregroundStyle(Color(.darkGray))
                        }
                        
                    }
                    
                }
                .padding()
            }
            .photosPicker(isPresented: $showPhotoPicker, selection: $viewModel.selectedImage, matching: .any(of: [.images,.not(.videos)]))
            .photosPicker(isPresented: $showVideoPicker, selection: $viewModel.selectedVideo, matching: .any(of: [.videos,.not(.images)]))
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
                        ZStack {
                            CircularProfileImageView(user: user, size: .xSmall)
                            KFImage(URL(string: user.profileImageUrl ?? ""))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 32, height: 32)
                                .foregroundStyle(Color(.systemGray4))
                                .clipShape(Circle())
                        }
                        Text(user.fullName)
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 24) {
                        Image(systemName: "video.fill")
                        Image(systemName: "phone.fill")
                        Image(systemName: "ellipsis")
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                }
            }
            .background{
                Image("background_image")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            //.navigationTitle(user.fullName)
            //.navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ChatView(user: User.MOCK_USER)
}
