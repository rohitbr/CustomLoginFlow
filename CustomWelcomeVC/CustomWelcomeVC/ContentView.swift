//
//  ContentView.swift
//  CustomWelcomeVC
//
//  Created by Rohit on 4/1/20.
//  Copyright © 2020 lumasecurity. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {
    @ObservedObject var authService = AuthenticationService.instance

    var body: some View {
        VStack {
            if authService.userState == .signedIn {
                HomeView()
            } else {
                WelcomeView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
