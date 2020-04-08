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

            TextField("Email address", text: $viewModel.username)
                .textFieldStyle(CustomTextFieldStyle())

            Text("Enter your email address and we will send a verification code to your email address")
                .lineLimit(nil)

            RedRoundedButton("Reset Password") {
                self.viewModel.forgotPasswordAction()
            }.font(.subheadline)
                .padding(5)
                .border(Color.black, width: 1)
                .foregroundColor(Color.red)

            NavigationLink(destination: ConfirmForgotPasswordView(viewModel: .init()), isActive: $viewModel.gotoVerificationView) {
               Text("")
            }

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

//struct ForgotPasswordView_Previews: PreviewProvider {
//    static var previews: some View {
//        ForgotPasswordView()
//    }
//}
