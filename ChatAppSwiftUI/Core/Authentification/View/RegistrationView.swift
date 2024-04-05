//
//  RegistrationView.swift
//  ChatAppSwiftUI
//
//  Created by omar thamri on 7/3/2024.
//

import SwiftUI

struct RegistrationView: View {
    @StateObject private var viewModel = RegistrationViewModel()
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack {
            Spacer()
            // logo image
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .padding()
            // textfields
            FloatingTextFieldsView(viewModel: viewModel)
            Button {
                Task { try await viewModel.createUser() }
            } label: {
                Text("Sign Up")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(width: 360,height: 44)
                    .background(.green)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding(.vertical)
            Spacer()
            Divider()
            Button {
                dismiss()
            } label: {
                HStack(spacing: 3) {
                    Text("Already have an account?")
                    Text("Sign in")
                        .fontWeight(.semibold)
                }
                .font(.footnote)
                .foregroundStyle(.gray)
            }
            .padding(.vertical)
        }
    }
}

#Preview {
    RegistrationView()
}
