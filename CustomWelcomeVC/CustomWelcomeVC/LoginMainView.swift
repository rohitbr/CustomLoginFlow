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
    @ObservedObject var viewModel : LoginViewModel

    var body: some View {
        VStack (spacing: 20) {
            Image(Images.kLogoName)
                .padding(.top, 20)

            Spacer()

            TextField("Username", text: $viewModel.username)
                .multilineTextAlignment(.center)
                .padding(10)
                .autocapitalization(.none)
            TextField("Password", text: $viewModel.password)
                .multilineTextAlignment(.center)
                .padding(10)


            Button("Forgot Password") {

            }.font(.subheadline)

            Spacer()

            NavigationLink(destination: HomeView(), isActive: $viewModel.gotoHomeView) {
                RedRoundedButton("Sign in") {
                    self.viewModel.buttonAction()
                }
            }


            NavigationLink(destination: SignupView(), isActive: $goToSignup) {
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
    }
}

//struct LoginMainView_Previews: PreviewProvider {
//    @ObservedObject var viewModel = LoginViewModel()
//
//    static var previews: some View {
//        return LoginMainView(viewModel: viewModel)
//    }
//}
