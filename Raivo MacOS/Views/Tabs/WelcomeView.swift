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

import Cocoa
import SwiftUI
import Settings
import SwiftyStoreKit
import LaunchAtLogin

/// A support tab view shown in the preferences window
///
/// - Note: This contains help & support for users that are unsure of how to use the app
struct WelcomeView: View {
    
    /// The title of the tab
    let preferencePaneTitle: String = "Welcome"
    
    /// Request start on boot alert
    @State public var showStartOnBootAlert = false
    
    /// The actual view shown when someone clicks on the support tab
    var body: some View {
            ZStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .center, spacing: 0) {
                        Image("image-titlebar-icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 45, height: 45, alignment: .center)
                        Text("Menu bar app").opacity(0.5)
                        Spacer()
                    }
                    Image("image-titlebar-dropdown")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 150, alignment: .leading)
                        .offset(x: -10, y: -15)
                }
                .frame(width: 175, height: 250, alignment: .center)
                .offset(x: 50, y: 10)
                .opacity(0.5)
                VStack (alignment: .leading, spacing: 5) {
                    Text("Welcome to Raivo").font(.largeTitle).bold()
                    Text("This menu bar app copies all one-time passwords tapped in Raivo for iOS to your MacOS clipboard.")
                    HStack {
                        Button("Get started") {
                            getAppDelegate().statusBarFeature?.preferencesWindowController.show(pane: .linking)
                        }
                        Button("Buy me a coffee") {
                            TipJarView().openInWindow(title: "Tip Jar", sender: self)
                        }.buttonStyle(MainButtonStyle())
                    }.padding(.vertical)
                }
                .padding()
                .frame(width: 325, height: 250)
                .offset(x: +225)
            }
            .frame(width: 550, height: 250, alignment: .topLeading)
            .alert("Would you like Raivo Receiver to start on boot of MacOS?", isPresented: $showStartOnBootAlert) {
                Button("Yes", role: .none) {
                    LaunchAtLogin.isEnabled = true
                }
                Button("No", role: .cancel) {
                    LaunchAtLogin.isEnabled = false
                }
            }
        
    }
    
}

#if DEBUG
struct WelcomeView_Previews: PreviewProvider {
    
    static var previews: some View {
        WelcomeView()
    }
    
}
#endif
