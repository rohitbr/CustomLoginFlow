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
    @Published var username : String = ""
    @Published var password : String = ""
    @Published var showModal = false
    @Published var description = ""
    @Published var userEntryValid = false
    @Published var usernameDesc = ""
    @Published var passwordDesc = ""
    @Published var goToSignup = false
    @Published var goToForgotPassword = false

    var subscriptions = Set<AnyCancellable>()

    private var validateEntries : AnyPublisher <Bool, Never> {
        return Publishers.CombineLatest($username, $password)
            .map { username, password in
                let resultUsername = InputValidator.validate(email: username)
                let resultPassword = InputValidator.validate(password: password)
                guard resultUsername.isValid && resultPassword.isValid else {
                    return false
            }
            return true
        }
        .eraseToAnyPublisher()
    }

    private var emailDesc : AnyPublisher<String, Never> {
            return $username
                .removeDuplicates()
                .flatMap { username in
                    return Future { promise in
                        let result = InputValidator.validate(email: username)
                        promise(.success(result.errorReason ?? ""))
                    }
            }
            .eraseToAnyPublisher()
        }

    private var passDesc : AnyPublisher<String, Never> {
        return $password
            .removeDuplicates()
            .flatMap { password in
                return Future { promise in
                    let result = InputValidator.validate(password: password )
                    promise(.success(result.errorReason ?? ""))
                }
        }
        .eraseToAnyPublisher()
    }

    static let awsService = AuthenticationService.instance
    
    init() {
        validateEntries
            .receive(on: DispatchQueue.main)
            .assign(to: \.userEntryValid, on: self)
            .store(in: &subscriptions)
        emailDesc
            .receive(on: DispatchQueue.main)
            .assign(to : \.usernameDesc, on : self)
            .store(in : &subscriptions)
        passDesc
            .receive(on: DispatchQueue.main)
            .assign(to : \.passwordDesc, on : self)
            .store(in : &subscriptions)
    }

    func okButtonPressed() {
        if self.description.compare(kSuccessful) == .orderedSame  {
            LaunchRoot.rootView(ContentView())
        }
    }

    func buttonAction() {
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
