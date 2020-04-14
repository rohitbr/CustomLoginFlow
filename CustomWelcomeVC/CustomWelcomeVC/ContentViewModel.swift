//
//  ContentViewModel.swift
//  CustomWelcomeVC
//
//  Created by Rohit on 4/14/20.
//  Copyright © 2020 lumasecurity. All rights reserved.
//

import Combine
import AWSMobileClient

class ContentViewModel: ObservableObject {

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
}
