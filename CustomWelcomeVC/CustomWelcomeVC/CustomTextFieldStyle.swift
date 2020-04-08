//
//  CustomTextFieldStyle.swift
//  CustomWelcomeVC
//
//  Created by Rohit on 4/7/20.
//  Copyright © 2020 lumasecurity. All rights reserved.
//

import SwiftUI

struct CustomTextFieldStyle : TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.headline) // set the inner Text Field Font
            .multilineTextAlignment(.leading)
            .padding(10) // Set the inner Text Field Padding
            .autocapitalization(.none)
            //Give it some style
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .strokeBorder(Color.primary.opacity(0.5), lineWidth: 1))
            .padding(10)

    }
}
