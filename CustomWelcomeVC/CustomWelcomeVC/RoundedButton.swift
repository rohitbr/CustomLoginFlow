//
//  RedRoundedButton.swift
//  OneLinkHomeSwiftUI
//
//  Created by Hasan, MdAdit on 2/26/20.
//  Copyright © 2020 Hasan, MdAdit. All rights reserved.
//

import SwiftUI

struct RedRoundedButton: View {
    
    public var buttonTitle:String
    public var action: () -> Void
    
    public init(_ buttonTitle:String, action:@escaping (() -> Void)) {
        self.buttonTitle = buttonTitle
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            Text(buttonTitle)
                .frame(width: 300)
                .font(Font.custom("Helvetica", size: 20))
                .foregroundColor(.white)
                .clipped()
                .cornerRadius(10)
                .padding()
        }.frame( height: 50)
        .background(Color.red)
        .overlay(RoundedRectangle(cornerRadius: 5)
        .stroke(Color.red, lineWidth: 5))
    }
}
 
public struct GrayButton: View {
    
    var buttonTitle:String
    var action: () -> Void
    
    public init( _ buttonTitle:String, action:@escaping (() -> Void)) {
        self.buttonTitle = buttonTitle
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            Text(buttonTitle).frame(width: 300)
                .font(Font.custom("Helvetica", size: 20))
                .foregroundColor(.gray)
                .clipped()
                .cornerRadius(10)
                .padding()
        }.frame( height: 50)
    }
}
