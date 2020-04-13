//
//  SignupView.swift
//  CustomWelcomeVC
//
//  Created by Rohit on 4/2/20.
//  Copyright © 2020 lumasecurity. All rights reserved.
//

import SwiftUI
import Combine

struct SignupView: View {
    @ObservedObject var viewModel : SignupViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        VStack {
            Image(Images.kLogoName)
                .padding(.top, 20)

            Spacer()

            Group {
                TextField("Username", text: $viewModel.username)
                    .textFieldStyle(CustomTextFieldStyle())
                HStack() {
                    Text(self.viewModel.usernameDesc.isEmpty ? "Email pattern good" : self.viewModel.usernameDesc)
                        .lineLimit(nil)
                        .font(.subheadline)
                        .foregroundColor(self.viewModel.usernameDesc.isEmpty ? Color.green : Color.red)
                        .padding(.leading)

                    Spacer()
                }

                TextField("Password", text: $viewModel.password)
                    .textFieldStyle(CustomTextFieldStyle())

                HStack() {
                    Text(self.viewModel.originalPasswordDesc.isEmpty ? "Passwords pattern good" : self.viewModel.originalPasswordDesc)
                        .lineLimit(nil)
                        .font(.subheadline)
                        .foregroundColor(self.viewModel.originalPasswordDesc.isEmpty ? Color.green : Color.red)
                        .padding(.leading)
                    Spacer()
                }

                TextField("Confirm Password", text: $viewModel.confirmPassword)
                    .textFieldStyle(CustomTextFieldStyle())

                HStack() {
                    Text(self.viewModel.passwordsValid ? "Passwords match" : "Passwords do not match")
                        .lineLimit(nil)
                        .font(.subheadline)
                        .foregroundColor(self.viewModel.passwordsValid ? Color.green : Color.red)
                        .padding(.leading)                    
                    Spacer()
                }
            }

            Spacer()
            
            NavigationLink(destination: HomeView(), isActive: $viewModel.goToHome) {
                RedRoundedButton("Sign up") {
                    self.viewModel.buttonActionSignup()
                }
                .disabled(self.viewModel.allFieldsValid ? false : true)
                .opacity(self.viewModel.allFieldsValid ?  1 : 0.6 )
            }
            Spacer()
                .frame(height:20)
            GrayButton("Already have an Account? Sign in") {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
        .alert(isPresented: $viewModel.showModal) {
            Alert(title: Text("Auth message"), message: Text(self.viewModel.description), dismissButton: .destructive(Text("Ok")) {
                self.viewModel.okButtonPressed()
                })
        }
    }
}

