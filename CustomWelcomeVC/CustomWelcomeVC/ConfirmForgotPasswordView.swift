//
//  ConfirmForgotPasswordView.swift
//  CustomWelcomeVC
//
//  Created by Rohit on 4/7/20.
//  Copyright © 2020 lumasecurity. All rights reserved.
//

import SwiftUI

struct ConfirmForgotPasswordView: View {
    @ObservedObject var viewModel : ConfirmPasswordViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack{
            TextField("Verification Code", text: $viewModel.verificationCode)
                .textFieldStyle(CustomTextFieldStyle())
            TextField("Username", text: $viewModel.username)
                .textFieldStyle(CustomTextFieldStyle())
            TextField("New Password", text: $viewModel.newPassword)
                .textFieldStyle(CustomTextFieldStyle())
            
            RedRoundedButton("Reset Password") {
                self.viewModel.confirmForgotPasswordAction()
            }
        }
        .alert(isPresented: $viewModel.showModal) {
            Alert(title: Text("Auth message"), message: Text(self.viewModel.description), dismissButton: .destructive(Text("Ok")) {
                self.viewModel.okButtonPressed()
                })
        }
    }
}

