//
//  ContentView.swift
//  Drinkathon
//
//  Created by Brandon Gibbons on 5/2/24.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Image("drinkathon-app-icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width:220, height:220)
                    .padding()
                
                VStack {
                    TextField("Enter your email", text: $viewModel.email)
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        .modifier(TextFieldModifer())

                    SecureField("Enter your password", text: $viewModel.password)
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        .modifier(TextFieldModifer())
                }
                
                NavigationLink {
                    Text("Forgot password")
                } label: {
                    Text("Forgot Password?")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .padding(.top, 2)
                        .padding(.bottom)
                        .padding(.trailing)
                        .padding(.horizontal, 15)
                        .foregroundColor(.white)
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .trailing)
                }
                
                Button {
                    Task { try await viewModel.login() }
                } label: {
                    Text("Login")
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
                
                NavigationLink {
                    RegistrationView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack(spacing: 3) {
                        Text("Dont have an account?")
                        Text("Sign up")
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
}

#Preview {
    LoginView()
}
