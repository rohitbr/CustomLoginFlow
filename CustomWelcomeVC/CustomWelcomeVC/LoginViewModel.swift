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
    @Published public var userEntryValid = false
    @Published public var usernameDesc = ""
    @Published public var passwordDesc = ""

    private var validateEntries : AnyPublisher <Bool, Never> {
        return Publishers.CombineLatest($username, $password)
            .map { username, password in
                guard !username.isEmpty && !password.isEmpty else {
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
        var subscriptions = Set<AnyCancellable>()
        getUserState()
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
