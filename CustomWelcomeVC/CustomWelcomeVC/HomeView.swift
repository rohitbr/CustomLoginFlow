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
    @ObservedObject var viewModel = HomeViewModel()

    var body: some View {
        VStack {
            if self.viewModel.signOutSuccess {
                WelcomeView()
            } else {
                Button("Sign out") {
                    self.viewModel.signOut()
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
