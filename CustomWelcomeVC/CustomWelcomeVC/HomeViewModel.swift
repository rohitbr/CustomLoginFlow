//
//  HomeViewModel.swift
//  CustomWelcomeVC
//
//  Created by Rohit on 4/6/20.
//  Copyright © 2020 lumasecurity. All rights reserved.
//

import UIKit
import Combine

class HomeViewModel: ObservableObject {

    static let awsService = AuthenticationService.instance
    @Published var signOutSuccess = false

    func signOut() {
        let signOut = Self.awsService.signOut()

        var subscriptions = Set<AnyCancellable>()

        signOut
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                print($0)
            }, receiveValue: { signOutResut in
                self.signOutSuccess = true
            })
            .store(in: &subscriptions)
    }
}
