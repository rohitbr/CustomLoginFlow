//
//  LoginViewModel.swift
//  CustomWelcomeVC
//
//  Created by Rohit on 4/6/20.
//  Copyright © 2020 lumasecurity. All rights reserved.
//

import Combine
import AWSMobileClient
import SwiftUI

class LoginViewModel: ObservableObject {

    let kSuccessful = "Successful login"
    @Published public var username : String = ""
    @Published public var password : String = ""
    @Published public var showModal = false
    @Published public var description = ""
    @Published public var userState = UserState.unknown

    static let awsService = AuthenticationService.instance
    
    init() {
        getUserState()
    }

    func getUserState() {
        var subscriptions = Set<AnyCancellable>()
        let userState = Self.awsService.getUserState()
        userState
            .sink(receiveCompletion: { print($0)
            }, receiveValue: { userState in
                self.userState = userState ?? UserState.unknown
            })
            .store(in: &subscriptions)
    }

    func okButtonPressed() {
        if self.description.compare(kSuccessful) == .orderedSame  {
            LaunchRoot.rootView(ContentView())
        }
    }

    func buttonAction() {
        var subscriptions = Set<AnyCancellable>()

        if username.isEmpty || password.isEmpty {
            self.description = "Username or Password is Empty"
            self.showModal.toggle()
            return
        }

        let signin = Self.awsService.signIn(userName: username, password: password)

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
                self.showModal.toggle()
                self.description = self.kSuccessful
            })
            .store(in: &subscriptions)
    }
}
