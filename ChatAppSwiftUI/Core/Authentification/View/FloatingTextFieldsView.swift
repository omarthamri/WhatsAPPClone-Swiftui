//
//  FloatingTextFieldsView.swift
//  ChatAppSwiftUI
//
//  Created by omar thamri on 31/3/2024.
//

import SwiftUI


struct FloatingTextFieldsView: View {
    @StateObject private var viewModel: RegistrationViewModel
    init(viewModel: RegistrationViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    var body: some View {
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
                Text("Full name")
                    .foregroundStyle(.gray)
                    .offset(y: viewModel.fullName.isEmpty ? 0 : -25)
                    .scaleEffect(viewModel.fullName.isEmpty ? 1 : 0.9,anchor: .leading)
                    .font(.system(viewModel.fullName.isEmpty ? .subheadline : .subheadline,design: .rounded))
                VStack {
                    TextField("",text: $viewModel.fullName)
                    Divider()
                }
            }
            .padding(.top, viewModel.fullName.isEmpty ? 0 : 18)
            .animation(.default)
            .padding()
            ZStack(alignment: .leading) {
                Text("Phone number")
                    .foregroundStyle(.gray)
                    .offset(y: viewModel.phoneNumber.isEmpty ? 0 : -25)
                    .scaleEffect(viewModel.phoneNumber.isEmpty ? 1 : 0.9,anchor: .leading)
                    .font(.system(viewModel.phoneNumber.isEmpty ? .subheadline : .subheadline,design: .rounded))
                VStack {
                    TextField("",text: $viewModel.phoneNumber)
                    Divider()
                }
            }
            .padding(.top, viewModel.phoneNumber.isEmpty ? 0 : 18)
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
        
    }
}
