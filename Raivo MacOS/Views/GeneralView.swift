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
import LaunchAtLogin

/// A general tab view shown in the preferences window
///
/// - Note: This contains general preferences, such as if the application should launch on boot
struct GeneralView: View {
    
    /// The title of the tab
    let preferencePaneTitle: String = "General"
    
    /// A boolean defining if the application should start on boot
    @State var launchOnLogin = LaunchAtLogin.isEnabled {
        didSet {
            LaunchAtLogin.isEnabled = launchOnLogin
        }
    }
    
    /// The actual view shown when someone clicks on the general tab
    var body: some View {
        VStack (alignment: .leading, spacing: 5) {
            VStack (alignment: .leading, spacing: 0) {
                Toggle(isOn: $launchOnLogin) {
                    Text("Launch at login").padding(4)
                }
                Text("Automatically opens the app when you sign in to your Mac.").foregroundColor(.gray)
            }
            .padding()
        }
        .frame(minWidth: 450, minHeight: 250, alignment: .topLeading)
    }
    
}

#if DEBUG
struct GeneralView_Previews: PreviewProvider {
    
    static var previews: some View {
        GeneralView()
    }
    
}
#endif
