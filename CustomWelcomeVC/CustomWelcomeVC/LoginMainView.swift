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

    init(){
        UINavigationBar.setAnimationsEnabled(false)
        self.viewModel = LoginViewModel()
    }

    var body: some View {
        VStack (spacing: 20) {
            Image(Images.kLogoName)
                .padding(.top, 20)

            Spacer()

            TextField("Username", text: $viewModel.username)
                .textFieldStyle(CustomTextFieldStyle())
            TextField("Password", text: $viewModel.password)
                .textFieldStyle(CustomTextFieldStyle())

            Button("Forgot Password") {
                self.goToForgotPassword.toggle()
            }.font(.subheadline)
                .padding(5)
                .border(Color.black, width: 1)
                .foregroundColor(Color.red)

            Spacer()

            NavigationLink(destination: ForgotPasswordView(viewModel: .init()), isActive: $goToForgotPassword) {
               Text("")
            }

            RedRoundedButton("Sign in") {
                self.viewModel.buttonAction()
            }

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
    }
}

//struct LoginMainView_Previews: PreviewProvider {
//    @ObservedObject var viewModel = LoginViewModel()
//
//    static var previews: some View {
//        return LoginMainView(viewModel: viewModel)
//    }
//}
