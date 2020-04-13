//
//  ForgotPasswordView.swift
//  
//
//  Created by Rohit on 4/7/20.
//

import SwiftUI
import Combine

struct ForgotPasswordView: View {
    @State var gotoSigninView = false
    @ObservedObject var viewModel : ForgotPasswordViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        VStack (spacing: 20) {
            Image(Images.kLogoName)
                .padding(.top, 20)

            Spacer()
            NavigationLink(destination: ConfirmForgotPasswordView(viewModel: .init()), isActive: $viewModel.gotoVerificationView) {
                EmptyView().frame(width: 0, height: 0, alignment: .center)
            }

            TextField("Email address", text: $viewModel.username)
                .textFieldStyle(CustomTextFieldStyle())
            
            HStack() {
            Text(self.viewModel.usernameDesc.isEmpty ? "Email pattern good" : self.viewModel.usernameDesc)
                .lineLimit(nil)
                .font(.subheadline)
                .foregroundColor(self.viewModel.usernameDesc.isEmpty ? Color.green : Color.red)
                .padding(.leading)

            Spacer()
            }

            Text("Enter your email address and we will send a verification code to your email address")
                .lineLimit(nil)

            RedRoundedButton("Reset Password") {
                self.viewModel.forgotPasswordAction()
            }
            .disabled(self.viewModel.usernameDesc.isEmpty ? false : true)
            .opacity(self.viewModel.usernameDesc.isEmpty ?  1 : 0.6 )

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
