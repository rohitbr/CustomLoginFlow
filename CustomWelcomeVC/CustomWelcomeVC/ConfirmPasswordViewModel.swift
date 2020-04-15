//
//  ConfirmPasswordViewModel.swift
//  CustomWelcomeVC
//
//  Created by Rohit on 4/7/20.
//  Copyright © 2020 lumasecurity. All rights reserved.
//

import UIKit
import Combine

class ConfirmPasswordViewModel: ObservableObject {

    let kVerified = "Verified"
    @Published public var verificationCode : String = ""
    @Published public var username : String = ""
    @Published public var newPassword : String = ""
    @Published public var description = ""
    @Published public var showModal = false
    var subscriptions = Set<AnyCancellable>()

    static let awsService = AuthenticationService.instance

    func confirmForgotPasswordAction() {

        if username.isEmpty || newPassword.isEmpty || verificationCode.isEmpty {

            return
        }

        let confirmPass = Self.awsService.confirmForgotPassword(username: username, newPassword: newPassword, code: verificationCode)

        confirmPass
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
                self.description = self.kVerified
            })
            .store(in: &subscriptions)
    }

    func okButtonPressed() {
        if self.description.compare(self.kVerified) == .orderedSame  {
            LaunchRoot.rootView(LoginMainView())
        }
    }
}
