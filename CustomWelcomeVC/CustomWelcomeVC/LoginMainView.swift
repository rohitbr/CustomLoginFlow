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
    @State private var username : String = ""
    @State private var password : String = ""
    @State private var goToHome = false
    @State private var goToSignup = false
    @State private var showModal = false
    @State private var description = ""
    @State private var recievedSuccess = false

    var body: some View {
        NavigationView {
            VStack (spacing: 20) {
                Image(Images.kLogoName)
                    .padding(.top, 20)

                Spacer()

                TextField("Username", text: $username)
                    .multilineTextAlignment(.center)
                    .padding(10)
                    .autocapitalization(.none)
                TextField("Password", text: $password)
                    .multilineTextAlignment(.center)
                    .padding(10)


                Button("Forgot Password") {

                }.font(.subheadline)

                Spacer()

                RedRoundedButton("Sign in") {
                    self.buttonAction()
                }

                NavigationLink(destination: SignupView(), isActive: $goToSignup) {
                    GrayButton("Dont have account ? Sign Up") {
                        self.goToSignup.toggle()
                    }
                }
            }
        }
        .alert(isPresented: $showModal) {
            Alert(title: Text("Auth message"), message: Text(self.description), dismissButton: .destructive(Text("Ok")) {

                })
        }
    }

    func buttonAction() {
        var subscriptions = Set<AnyCancellable>()

        let signin = AuthenticationService.instance.signIn(userName: username, password: password)

        signin
            .mapError { error in APIError.mapError(error.localizedDescription)}
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                switch $0 {
                case .failure(.mapError(let str)) :
                    self.showModal.toggle()
                    self.description = str
                default:
                    break
                }

            }, receiveValue: { signInResut in
                print(signInResut ?? "")
            })
            .store(in: &subscriptions)
    }
}

struct LoginMainView_Previews: PreviewProvider {
    static var previews: some View {
        LoginMainView()
    }
}
