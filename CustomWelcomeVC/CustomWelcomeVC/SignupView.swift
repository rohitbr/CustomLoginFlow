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

            TextField("Username", text: $viewModel.username)
                .textFieldStyle(CustomTextFieldStyle())
            TextField("Password", text: $viewModel.password)
                .textFieldStyle(CustomTextFieldStyle())
            TextField("Confirm Password", text: $viewModel.confirmPassword)
                .textFieldStyle(CustomTextFieldStyle())

            Spacer()

            NavigationLink(destination: HomeView(), isActive: $viewModel.goToHome) {
                RedRoundedButton("Sign up") {
                    self.viewModel.buttonActionSignup()
                }
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

//struct SignupView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignupView()
//    }
//}
