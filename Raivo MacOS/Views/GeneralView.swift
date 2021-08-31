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
    
    /// The actual notification token for the app
    ///
    /// - Note: This is set only after the app registered for remote notifications and received a token
    var token: String?
    
    /// A boolean indicating if the clipboard should be cleared after x seconds
    @State var clearClipboardAfterDelay = StorageHelper.shared.getClearPasswordAfterDelay() {
        didSet {
            try! StorageHelper.shared.setClearPasswordAfterDelay(clearClipboardAfterDelay)
        }
    }

    /// A boolean indicating if the configure password sheet is currently shown or should be shown
    @State private var showingDecryptionPasswordSheet = false
    
    /// Initialize the devices view.
    ///
    /// - Parameter token: A mock token (only used during SwiftUI previews)
    init(_ token: Data? = nil) {
        if let token = token {
            notifyAboutDeviceToken(token)
        }
    }
    
    /// Called when the app registered for remote notifications and received a token
    ///
    /// - Parameter token: The assigned notification token
    mutating func notifyAboutDeviceToken(_ token: Data) {
        self.token = token.toHexString()
    }
    
    /// The actual view shown when someone clicks on the general tab
    var body: some View {
        let clearClipboardAfterDelayBind = Binding<Bool>(
            get: { clearClipboardAfterDelay },
            set: { clearClipboardAfterDelay = $0 }
        )
        
        VStack (alignment: .leading, spacing: 5) {
            VStack (alignment: .leading, spacing: 15) {
                VStack (alignment: .leading, spacing: 0) {
                    LaunchAtLogin.Toggle {
                        Text("Launch at login").padding(4)
                    }
                    Text("Automatically opens the app when you sign in to your Mac.").foregroundColor(.gray)
                }
                VStack (alignment: .leading, spacing: 0) {
                    Toggle(isOn: clearClipboardAfterDelayBind) {
                        Text("Play 30 seconds").padding(4)
                    }
                    Text("Clear received passwords from your clipboard after 30 seconds.").foregroundColor(.gray)
                }
                VStack (alignment: .leading, spacing: 0) {
                    Text("Push notification token").padding(.vertical, 4)
                    Text(token ?? "Unknown...").foregroundColor(.gray).contextMenu {
                        Button(action: {
                            ClipboardHelper.shared.set(token ?? "Unknown...")
                        }) {
                            Text("Copy")
                        }
                    }
                }
            }
            .padding()
        }
        .frame(minWidth: 550, minHeight: 250, alignment: .topLeading)
    }
    
}

#if DEBUG
struct GeneralView_Previews: PreviewProvider {
    
    static var previews: some View {
        GeneralView()
    }
    
}
#endif
