//
//  HomeView.swift
//  CustomWelcomeVC
//
//  Created by Rohit on 4/1/20.
//  Copyright © 2020 lumasecurity. All rights reserved.
//

import SwiftUI
import Combine

struct HomeView: View {
    var authService = AuthenticationService.instance
    @State var signOutSuccess = false

    var body: some View {
        VStack {
            if signOutSuccess {
                WelcomeView()
            } else {
                Button("Sign out") {
                    self.signOut()
                }
            }
        }
    }

    func signOut() {
        let signOut = authService.signOut()

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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
