//
//  InboxView.swift
//  ChatAppSwiftUI
//
//  Created by omar thamri on 7/3/2024.
//

import SwiftUI

struct InboxView: View {
    @State private var showNewMessageView = false
    @StateObject private var viewModel = InboxViewModel()
    @State private var selectedUser: User?
    @State private var showChat = false
    private var user: User? {
        return viewModel.currentUser
    }
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                List {
                        ForEach(viewModel.latestMessages) { message in
                            ZStack {
                                NavigationLink(value: message) {
                                   EmptyView()
                                }
                                .opacity(0)
                                InboxRowView(message: message)
                            }
                        
                        }
                    }
                .listStyle(PlainListStyle())
                .onChange(of: selectedUser, perform: { newValue in
                    showChat = newValue != nil
                })
                .navigationDestination(for: Message.self, destination: { message in
                    if let user = message.user {
                        ChatView(user: user)
                            .navigationBarBackButtonHidden()
                    }
                })
                .navigationDestination(for: Route.self, destination: { route in
                    switch route {
                    case .profile(let user):
                        ProfileView(user: user)
                            .navigationBarBackButtonHidden()
                    case .ChatView(let user):
                        ChatView(user: user)
                            .navigationBarBackButtonHidden()
                    }
                    
                })
                .navigationDestination(isPresented: $showChat , destination: {
                    if let user = selectedUser {
                        ChatView(user: user)
                            .navigationBarBackButtonHidden()
                    }
                })
                .fullScreenCover(isPresented: $showNewMessageView){
                    NewMessageView(selectedUser: $selectedUser)
                }
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(.visible, for: .tabBar)
                .toolbar{
                    ToolbarItem(placement: .topBarLeading) {
                        Text("WhatsApp")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .navigationBarColor(Color(.darkGray))
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                            HStack(spacing: 24) {
                              Image(systemName: "camera")
                              Image(systemName: "magnifyingglass")
                                
                                if let user {
                                    NavigationLink(value: Route.profile(user)) {
                                    Image(systemName: "ellipsis")
                                    }
                                }

                            }
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                        }
            }
                Button {
                    showNewMessageView.toggle()
                    selectedUser = nil
                } label: {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.darkGray))
                        .frame(width: 50, height: 50)
                        .padding()
                        .overlay {
                            Image(systemName: "plus.bubble.fill")
                                .foregroundStyle(.white)
                        }
                }
            }
        }
    }
}

#Preview {
    InboxView()
}

extension View {
    func navigationBarColor(_ backgroundColor: Color) -> some View {
        self.modifier(NavigationBarColorModifier(backgroundColor: backgroundColor))
    }
}

struct NavigationBarColorModifier: ViewModifier {
    var backgroundColor: Color

    init(backgroundColor: Color) {
        self.backgroundColor = backgroundColor
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithOpaqueBackground()
        coloredAppearance.backgroundColor = UIColor(backgroundColor)
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
    }

    func body(content: Content) -> some View {
        content
            .background(backgroundColor)
    }
}
