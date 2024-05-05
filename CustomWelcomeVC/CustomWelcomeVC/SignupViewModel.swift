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

    @Published var username : String = ""
    @Published var password : String = ""
    @Published var confirmPassword : String = ""
    @Published var goToHome = false
    @Published var showModal = false
    @Published var gotoHomeView = false
    @Published var description = ""
    @Published var usernameDesc = ""
    @Published var passwordsValid = false
    @Published var originalPasswordDesc = ""
    @Published var allFieldsValid = false
    var subscriptions = Set<AnyCancellable>()

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

    private var validatePasswords : AnyPublisher <Bool, Never> {
        return Publishers.CombineLatest($password, $confirmPassword)
            .map {  password, passwordConfirm in
                let resultPassword = InputValidator.validate(password: password)
                let resultPasswordConfirm = InputValidator.validate(password: passwordConfirm)

                guard resultPassword.isValid,
                    resultPasswordConfirm.isValid,
                    password == passwordConfirm else {
                    return false
            }
            return true
        }
        .eraseToAnyPublisher()
    }

    private var validateAllfields : AnyPublisher <Bool, Never> {
        return Publishers.CombineLatest(emailDesc, validatePasswords)
            .map {  emailDesc, validatePasswords in
                guard emailDesc.isEmpty && validatePasswords
                    else {
                    return false
            }
            return true
        }
        .eraseToAnyPublisher()
    }


    init() {
        emailDesc
            .receive(on: DispatchQueue.main)
            .assign(to : \.usernameDesc, on : self)
            .store(in : &subscriptions)
        passDesc
            .receive(on: DispatchQueue.main)
            .assign(to : \.originalPasswordDesc, on : self)
            .store(in : &subscriptions)
        validatePasswords
            .receive(on: DispatchQueue.main)
            .assign(to: \.passwordsValid, on: self)
            .store(in: &subscriptions)
        validateAllfields
                   .receive(on: DispatchQueue.main)
                   .assign(to: \.allFieldsValid, on: self)
                   .store(in: &subscriptions)
    }

    let kSignupSuccessful = "Sign up successful"

    func buttonActionSignup() {
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
