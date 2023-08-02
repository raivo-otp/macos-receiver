//
// Raivo OTP
//
// Copyright (c) 2023 Mobime. All rights reserved. Raivo OTP
// is provided 'as-is', without any express or implied warranty.
//
// Modification, duplication or distribution of this software (in
// source and binary forms) for any purpose is strictly prohibited.
//
// https://github.com/raivo-otp/macos-receiver/blob/master/LICENSE.md
//

import Foundation
import SwiftUI

struct MainButtonStyle: ButtonStyle {
    
    var foregroundColor: Color = .white
    
    var backgroundColorDefault: LinearGradient = LinearGradient(
        gradient: Gradient(stops: [
            .init(color: Color(red: 118/255, green: 118/255, blue: 118/255), location: 0.0),
            .init(color: Color(red: 91/255, green: 88/255, blue: 90/255), location: 0.05),
            .init(color: Color(red: 91/255, green: 88/255, blue: 90/255), location: 1.0)
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    var backgroundColorPressed: LinearGradient = LinearGradient(
        gradient: Gradient(stops: [
            .init(color: Color(red: 245/255, green: 100/255, blue: 125/255), location: 0.0),
            .init(color: Color(red: 232/255, green: 13/255, blue: 51/255), location: 0.05),
            .init(color: Color(red: 232/255, green: 13/255, blue: 51/255), location: 1.0)
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    var pressedColor: Color = .accentColor

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(Color(red: 235/255, green: 235/255, blue: 235/255))
            .padding(EdgeInsets(top: 1, leading: 8, bottom: 2, trailing: 8))
            .background(
                configuration.isPressed ? backgroundColorDefault : backgroundColorPressed
            )
            .cornerRadius(5)
            .shadow(color: .black.opacity(0.2), radius: 1.4, x: 0.0, y: 0.0)
    }

}


#if DEBUG
struct MainButtonStyle_Previews: PreviewProvider {
    
    static var previews: some View {
        VStack {
            Button("Button") {}.buttonStyle(DefaultButtonStyle()).scaleEffect(2.0).padding()
            Button("Button") {}.buttonStyle(MainButtonStyle()).scaleEffect(2.0).padding()
        }.padding()
    }
    
}
#endif
