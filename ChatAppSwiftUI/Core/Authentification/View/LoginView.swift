//
//  LoginView.swift
//  ChatAppSwiftUI
//
//  Created by omar thamri on 2/3/2024.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                // logo image
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .padding()
                // textfields
                VStack {
                    ZStack(alignment: .leading) {
                        Text("Email")
                            .foregroundStyle(.gray)
                            .offset(y: viewModel.email.isEmpty ? 0 : -25)
                            .scaleEffect(viewModel.email.isEmpty ? 1 : 0.9,anchor: .leading)
                            .font(.system(viewModel.email.isEmpty ? .subheadline : .subheadline,design: .rounded))
                        VStack {
                            TextField("",text: $viewModel.email)
                                .textInputAutocapitalization(.never)
                            Divider()
                        }
                    }
                    .padding(.top, viewModel.email.isEmpty ? 0 : 18)
                    .animation(.default)
                    .padding()
                    ZStack(alignment: .leading) {
                        Text("Password")
                            .foregroundStyle(.gray)
                            .offset(y: viewModel.password.isEmpty ? 0 : -25)
                            .scaleEffect(viewModel.password.isEmpty ? 1 : 0.9,anchor: .leading)
                            .font(.system(viewModel.password.isEmpty ? .subheadline : .subheadline,design: .rounded))
                        VStack {
                            SecureField("",text: $viewModel.password)
                            Divider()
                        }
                    }
                    .padding(.top, viewModel.password.isEmpty ? 0 : 18)
                    .animation(.default)
                    .padding()
                }
                // forgot password
                Button {
                    
                } label: {
                    Text("Forgot password?")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .padding(.top)
                        .padding(.trailing,28)
                        .foregroundStyle(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)

                // login button
                Button {
                    Task { try await viewModel.login() }
                } label: {
                    Text("Login")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .frame(width: 360,height: 44)
                        .background(.green)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(.vertical)
                Spacer()
                // signup link
                Divider()
                NavigationLink {
                    RegistrationView()
                        .navigationBarBackButtonHidden()
                } label: {
                    HStack(spacing: 3) {
                        Text("Don't have an account?")
                        Text("Sign Up")
                            .fontWeight(.semibold)
                    }
                    .font(.footnote)
                    .foregroundStyle(.gray)
                }
                .padding(.vertical)

            }
        }
    }
}

#Preview {
    LoginView()
}
