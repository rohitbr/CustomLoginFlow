//
//  ForgotPasswordViewModel.swift
//  CustomWelcomeVC
//
//  Created by Rohit on 4/7/20.
//  Copyright © 2020 lumasecurity. All rights reserved.
//

import Combine
import AWSMobileClient

class ForgotPasswordViewModel: ObservableObject {

    @Published public var username = ""
    @Published public var description = ""
    @Published public var showModal = false
    @Published public var gotoVerificationView = false
    @Published public var usernameDesc = ""
    let kCheckEmail = "Check your email"

    static let awsService = AuthenticationService.instance

    init() {
        var subscriptions = Set<AnyCancellable>()

        emailDesc
            .receive(on: DispatchQueue.main)
            .assign(to : \.usernameDesc, on : self)
            .store(in : &subscriptions)
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

    func forgotPasswordAction() {
        var subscriptions = Set<AnyCancellable>()

        if username.isEmpty {
            return
        }

        let signin = Self.awsService.forgotPassword(username: username)

        signin
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
                self.description = self.kCheckEmail
            })
            .store(in: &subscriptions)
    }

    func okButtonPressed() {
        if self.description.compare(kCheckEmail) == .orderedSame  {
            self.gotoVerificationView.toggle()
        }
    }
}
