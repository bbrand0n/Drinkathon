//
//  RegistrationView.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/2/24.
//

import SwiftUI

struct RegistrationView: View {
    @StateObject var viewModel = RegistrationViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Spacer()
            
            Image("drinkathon-app-icon")
                .resizable()
                .scaledToFit()
                .frame(width:220, height:220)
                .padding()
            
            VStack {
                TextField("Email", text: $viewModel.email)
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .autocorrectionDisabled()
                    .modifier(TextFieldModifer())
                
                TextField("Username", text: $viewModel.username)
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .autocorrectionDisabled()
                    .modifier(TextFieldModifer())
                
                TextField("Full name", text: $viewModel.fullname)
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .autocorrectionDisabled()
                    .modifier(TextFieldModifer())
                
                SecureField("Password", text: $viewModel.password)
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .modifier(TextFieldModifer())
            }
            .padding(.bottom, 30)
            
            Button {
                Task { try await viewModel.createUser() }
            } label: {
                Text("Sign up")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .frame(width: 320, height: 44)
                    .background(Color.primaryBlue)
                    
                    .cornerRadius(8)
            }
            
            Spacer()
            Spacer()
            
            Divider()
                .background(Color.gray)
            
            Button {
                dismiss()
            } label: {
                HStack(spacing: 3) {
                    Text("Already have an account?")
                    Text("Sign in")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.gray)
                .font(.footnote)
            }
            .padding(.vertical, 16)
        }
        .background(Color.black)
    }
}

#Preview {
    RegistrationView()
}
