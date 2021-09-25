//
// Raivo OTP
//
// Copyright (c) 2021 Tijme Gommers. All rights reserved. Raivo OTP
// is provided 'as-is', without any express or implied warranty.
//
// Modification, duplication or distribution of this software (in
// source and binary forms) for any purpose is strictly prohibited.
//
// https://github.com/raivo-otp/macos-receiver/blob/master/LICENSE.md
//

import Cocoa
import SwiftUI
import Preferences
import SwiftyStoreKit
import LaunchAtLogin

/// A support tab view shown in the preferences window
///
/// - Note: This contains help & support for users that are unsure of how to use the app
struct WelcomeView: View {
    
    /// The title of the tab
    let preferencePaneTitle: String = "Welcome"
    
    /// The actual view shown when someone clicks on the support tab
    var body: some View {
        ZStack(alignment: .leading) {
            HStack(alignment: .bottom) {
                Image("image-welcome")
                    .resizable()
                    .scaledToFit()
                    .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                    .frame(width: 550, height: 225, alignment: .bottomLeading)
            }
            .frame(width: 400, height: 250, alignment: .bottomLeading)
            .offset(x: -35.0)
            VStack (alignment: .leading, spacing: 5) {
                Text("Welcome to Raivo OTP!").font(.largeTitle)
                Text("This app copies all one-time passwords tapped in Raivo for iOS to your MacOS clipboard.")
                HStack {
                    Button("Get started") {
                        getAppDelegate().statusBarFeature?.preferencesWindowController.show(preferencePane: .linking)
                    }
                    Button("Buy me a coffee") {
                        TipJarView().openInWindow(title: "Tip Jar", sender: self)
                    }
                }.padding(.vertical)
            }
            .padding()
            .frame(width: 325, height: 250)
            .offset(x: +225)
        }
        .frame(width: 550, height: 250, alignment: .topLeading)
    }
    
}

#if DEBUG
struct WelcomeView_Previews: PreviewProvider {
    
    static var previews: some View {
        WelcomeView()
    }
    
}
#endif
