//
//  LoginMainView.swift
//  CustomWelcomeVC
//
//  Created by Rohit on 4/2/20.
//  Copyright © 2020 lumasecurity. All rights reserved.
//

import SwiftUI
import Combine
import AWSMobileClient

struct LoginMainView: View {

    @State private var goToSignup = false
    @State private var goToForgotPassword = false

    @ObservedObject var viewModel : LoginViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    init(){
        UINavigationBar.setAnimationsEnabled(false)
        self.viewModel = LoginViewModel()
    }

    var body: some View {
        VStack(spacing : 20) {
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
                Text(self.viewModel.passwordDesc.isEmpty ? "Password pattern good" : self.viewModel.passwordDesc)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.subheadline)
                    .foregroundColor(self.viewModel.passwordDesc.isEmpty ? Color.green : Color.red)
                    .padding(.leading)

                Spacer()
                }
            }

            Button(action: {
                self.goToForgotPassword.toggle()
            }) {
                Text("Forgot Password")
                    .underline()
            }
            .font(.subheadline)
            .padding(5)
            .foregroundColor(Color.red)

            Spacer()

            NavigationLink(destination: ForgotPasswordView(viewModel: .init()), isActive: $goToForgotPassword) {
                Text("")
            }

            RedRoundedButton("Sign in") {
                self.viewModel.buttonAction()
            }
            .disabled(self.viewModel.userEntryValid ? false : true)
            .opacity(self.viewModel.userEntryValid ?  1 : 0.6 )

            NavigationLink(destination: SignupView(viewModel: .init()), isActive: $goToSignup) {
                GrayButton("Dont have account ? Sign Up") {
                    self.goToSignup.toggle()
                }
            }

        }
        .alert(isPresented: $viewModel.showModal) {
            Alert(title: Text("Auth message"), message: Text(viewModel.description), dismissButton: .destructive(Text("Ok")) {
                self.viewModel.okButtonPressed()
                })
        }
    .navigationBarBackButtonHidden(true)
        .navigationBarItems(trailing:
            Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(Images.closeButton)
                    }
            })
    }
}
