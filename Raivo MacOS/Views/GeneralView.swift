//
// Raivo OTP
//
// Copyright (c) 2019 Tijme Gommers. All rights reserved. Raivo OTP
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

struct GeneralView: View {
    
    let preferencePaneTitle: String = "General"
    
    let toolbarItemIcon: NSImage = NSImage(named: NSImage.userAccountsName)!
    
    @State var launchOnLogin = LaunchAtLogin.isEnabled {
        didSet {
            LaunchAtLogin.isEnabled = launchOnLogin
        }
    }
    
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
