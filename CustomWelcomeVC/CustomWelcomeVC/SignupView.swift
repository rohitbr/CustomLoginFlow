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

    @State private var username : String = ""
    @State private var password : String = ""
    @State private var confirmPassword : String = ""
    @State private var goToHome = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        VStack {
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
            TextField("Confirm Password", text: $confirmPassword)
                .multilineTextAlignment(.center)
                .padding(10)

            Spacer()

            NavigationLink(destination: HomeView(), isActive: $goToHome) {
                RedRoundedButton("Sign up") {
                    self.buttonActionSignup()
                }
            }
            Spacer()
                .frame(height:20)
            GrayButton("Already have an Account? Sign in") {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    .navigationBarBackButtonHidden(true)
    }

    func buttonActionSignup() {
        var subscriptions = Set<AnyCancellable>()
        let signUp = AuthenticationService.instance.signUp(username: username, password: password)

        signUp
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                print($0)
            }, receiveValue: { signInResut in
                print(signInResut ?? "")
                self.goToHome.toggle()
            })
            .store(in: &subscriptions)
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
