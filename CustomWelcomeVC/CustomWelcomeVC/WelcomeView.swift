//
//  WelcomeView.swift
//  CustomWelcomeVC
//
//  Created by Rohit on 4/1/20.
//  Copyright © 2020 lumasecurity. All rights reserved.
//

import SwiftUI
import Combine

struct WelcomeView: View {
  
    @State private var goToNext = false

    var body: some View {
        NavigationView {
            VStack (spacing: 20) {
                Spacer()

                Image(Images.kLogoName)
                    .padding(.top, 20)

                Text("Welcome!")

                Text("Sign up below by checking the checkbox. Terms and conditions are listed.")
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding()
                    .lineLimit(2)
                    .lineSpacing(3)
               

                Spacer()

                NavigationLink(destination: LoginMainView(), isActive: $goToNext) {
                    RedRoundedButton("Use Onelink Account") {
                        self.goToNext.toggle()
                    }
                }

                GrayButton("Continue") {

                }
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
