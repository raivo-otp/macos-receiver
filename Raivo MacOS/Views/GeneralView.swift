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
    
    /// A boolean indicating if the clipboard should be cleared after x seconds
    @State var clearClipboardAfterDelay = StorageHelper.shared.getClearEncryptionPasswordAfterDelay() {
        didSet {
            try! StorageHelper.shared.setClearEncryptionPasswordAfterDelay(clearClipboardAfterDelay)
        }
    }

    /// A boolean indicating if the configure password sheet is currently shown or should be shown
    @State private var showingDecryptionPasswordSheet = false
    
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
                    Button("Configure password") {
                        showingDecryptionPasswordSheet.toggle()
                    }.padding(.vertical, 4)
                    Text("Stored securely in Keychain and used to decrypt passwords from Raivo OTP for iOS.").foregroundColor(.gray)
                    
                }
            }
            .padding()
        }
        .frame(minWidth: 450, minHeight: 250, alignment: .topLeading)
        .sheet(
            isPresented: $showingDecryptionPasswordSheet,
            content: {
                DecryptionPasswordSheet(
                    showingDecryptionPasswordSheet: $showingDecryptionPasswordSheet
                )
            }
        )
    }
    
}

/// A sheet (modal) shown when the user is configuring a decryption password
struct DecryptionPasswordSheet : View {
    
    /// A boolean indicating if this sheet is currently shown or should be shown
    @Binding var showingDecryptionPasswordSheet: Bool
    
    /// The value of the decryption password (secure field)
    @State var decryptionPassword = ""
    
    /// The actual view shown in the sheet
    var body: some View {
        VStack (alignment: .center, spacing: 5) {
            Text("Decryption password").bold()
            Text("This must be the same password as in Raivo OTP for iOS!").foregroundColor(.gray)
            SecureField("Password...", text: $decryptionPassword)
            HStack (alignment: .center, spacing: 5) {
                Button("Cancel") {
                    decryptionPassword = ""
                    showingDecryptionPasswordSheet.toggle()
                }
                Button("Save") {
                    try? StorageHelper.shared.setDecryptionPassword(decryptionPassword)
                    decryptionPassword = ""
                    showingDecryptionPasswordSheet.toggle()
                }
            }
        }.padding(20)
    }
}

#if DEBUG
struct GeneralView_Previews: PreviewProvider {
    
    static var previews: some View {
        GeneralView()
    }
    
}
#endif
