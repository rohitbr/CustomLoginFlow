//
//  LaunchRoot.swift
//  CustomWelcomeVC
//
//  Created by Rohit on 4/8/20.
//  Copyright © 2020 lumasecurity. All rights reserved.
//

import SwiftUI

class LaunchRoot : NSObject {
    static func rootView<V>(_ destinationView : V) where V: View {
        // Use a UIHostingController as window root view controller.
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene

        if let windowScenedelegate = scene?.delegate as? SceneDelegate {
            let window = UIWindow(windowScene: scene!)
            window.rootViewController = UIHostingController(rootView:destinationView)
            windowScenedelegate.window = window
            window.makeKeyAndVisible()
        }
    }
}
