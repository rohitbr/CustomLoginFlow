//
//  SignupViewModel.swift
//  CustomWelcomeVC
//
//  Created by Rohit on 4/8/20.
//  Copyright © 2020 lumasecurity. All rights reserved.
//

import Combine
import UIKit

class SignupViewModel: ObservableObject {

    @Published public var username : String = ""
    @Published public var password : String = ""
    @Published public var confirmPassword : String = ""
    @Published public var goToHome = false
    @Published public var showModal = false
    @Published public var gotoHomeView = false
    @Published public var description = ""

    let kSignupSuccessful = "Sign up successful"

    func buttonActionSignup() {
        var subscriptions = Set<AnyCancellable>()
        let signUp = AuthenticationService.instance.signUp(username: username, password: password)

        signUp
            .mapError { error in APIError.mapError(error.localizedDescription)}
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                switch $0 {
                case .failure(.mapError(let str)):
                    self.showModal.toggle()
                    self.description = str
                default:
                    break
                }

            }, receiveValue: { signInResut in
                print(signInResut ?? "")
                self.showModal.toggle()
                self.description = self.kSignupSuccessful
            })
            .store(in: &subscriptions)
    }

    func okButtonPressed() {
        if self.description.compare(self.kSignupSuccessful) == .orderedSame  {
            self.gotoHomeView.toggle()
        }
    }
}
