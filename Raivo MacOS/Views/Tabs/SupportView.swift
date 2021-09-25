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

/// A support tab view shown in the preferences window
///
/// - Note: This contains help & support for users that are unsure of how to use the app
struct SupportView: View {
    
    /// The title of the tab
    let preferencePaneTitle: String = "Help"
 
    /// The actual view shown when someone clicks on the support tab
    var body: some View {
        VStack (alignment: .leading, spacing: 5) {
            VStack (alignment: .leading, spacing: 15) {
                VStack (alignment: .leading, spacing: 0) {
                    Text("How do I link my iOS and MacOS app?")
                    Text("1. Open the iOS app and go to 'Settings'.").foregroundColor(.gray)
                    Text("2. Go to 'Receivers' and tap the plus icon.").foregroundColor(.gray)
                    Text("3. Scan the QR-code from the MacOS app.").foregroundColor(.gray)
                    Text("4. Your iOS and MacOS app are now linked.").foregroundColor(.gray)
                }
                VStack (alignment: .leading, spacing: 0) {
                    Text("I'm not receiving notifications on my Mac!")
                    Text("1. Open the iOS app and go to 'Settings'.").foregroundColor(.gray)
                    Text("2. Remove the existing link by swiping left.").foregroundColor(.gray)
                    Text("3. Relink the iOS and MacOS app.").foregroundColor(.gray)
                    Text("4. Notifications should now be working.").foregroundColor(.gray)
                }
            }
            .padding()
        }
        .frame(minWidth: 550, minHeight: 250, alignment: .topLeading)
    }
    
}

#if DEBUG
struct SupportView_Previews: PreviewProvider {
    
    static var previews: some View {
        SupportView()
    }
    
}
#endif
