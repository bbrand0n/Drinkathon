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
                    VStack {
                        TextField("", text: $viewModel.email,
                                  prompt: Text("Enter your email").foregroundColor(.gray))
                        .font(.subheadline)
                        .padding(12)
                        .background(Color(.lighterBlue))
                        .cornerRadius(10)
                        .padding(.horizontal, 24)
                        .foregroundStyle(.white)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        
                        
                        SecureField("", text: $viewModel.password,
                                    prompt: Text("Enter your password").foregroundColor(.gray))
                        .font(.subheadline)
                        .padding(12)
                        .background(Color(.lighterBlue))
                        .cornerRadius(10)
                        .padding(.horizontal, 24)
                        .foregroundStyle(.white)
                    }
                    
                    NavigationLink {
                        VStack{
                            Text("Forgot password")
                        }
                    } label: {
                        Spacer()
                        
                        Text("Forgot Password?")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .padding(.top, 2)
                            .padding(.bottom)
                            .padding(.trailing)
                            .padding(.horizontal, 15)
                            .foregroundColor(.white)
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
            .background(Color.darkerBlue)
        }
    }
}

#Preview {
    LoginView()
}
