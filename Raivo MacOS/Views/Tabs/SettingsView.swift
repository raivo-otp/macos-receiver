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

/// A tab view shown in the preferences window
///
/// - Note: This contains general preferences, such as if the application should launch on boot
struct SettingsView: View {
    
    /// The title of the tab
    let preferencePaneTitle: String = "Settings"
    
    /// The actual notification token for the app
    ///
    /// - Note: This is set only after the app registered for remote notifications and received a token
    @ObservedObject var pushToken = ObservablePushToken()
    
    /// A boolean indicating if the clipboard should be cleared after x seconds
    @State var clearClipboardAfterDelay = StorageHelper.shared.getClearPasswordAfterDelay() {
        didSet {
            try! StorageHelper.shared.setClearPasswordAfterDelay(clearClipboardAfterDelay)
        }
    }
    
    /// A boolean indicating if the clipboard should be cleared after x seconds
    @State var storeLogsOnDisk = StorageHelper.shared.getStoreLogsOnDisk() {
        didSet {
            try! StorageHelper.shared.setStoreLogsOnDisk(storeLogsOnDisk)
            getAppPrincipal().reInitializeLogging()
        }
    }

    /// A boolean indicating if the configure password sheet is currently shown or should be shown
    @State private var showingDecryptionPasswordSheet = false
    
    /// Initialize the devices view.
    ///
    /// - Parameter deviceToken: A mock token (only used during SwiftUI previews)
    init(_ deviceToken: Data? = nil) {
        pushToken.data = deviceToken
    }
    
    /// The actual view shown when someone clicks on the general tab
    var body: some View {
        let clearClipboardAfterDelayBind = Binding<Bool>(
            get: { clearClipboardAfterDelay },
            set: { clearClipboardAfterDelay = $0 }
        )
        
        let storeLogsOnDiskBind = Binding<Bool>(
            get: { storeLogsOnDisk },
            set: { storeLogsOnDisk = $0 }
        )
        
        VStack (alignment: .leading, spacing: 5) {
            ScrollView {
                VStack (alignment: .leading, spacing: 15) {
                    VStack (alignment: .leading, spacing: 0) {
                        LaunchAtLogin.Toggle {
                            Text("Launch at login").padding(4)
                        }
                        Text("Automatically opens the app when you sign in to your Mac.").foregroundColor(.gray)
                    }
                    VStack (alignment: .leading, spacing: 0) {
                        Toggle(isOn: clearClipboardAfterDelayBind) {
                            Text("Clear clipboard").padding(4)
                        }
                        Text("Clear received passwords from your clipboard after 30 seconds.").foregroundColor(.gray)
                    }
                    VStack (alignment: .leading, spacing: 0) {
                        HStack(alignment: .bottom, spacing: 4) {
                            Toggle(isOn: storeLogsOnDiskBind) {
                                Text("Debug logging").padding(4)
                            }
                            if storeLogsOnDiskBind.wrappedValue, let file = AppHelper.logFile {
                                Button("Show") {
                                    FileHelper.shared.openInFinder(file)
                                }
                            }
                        }
                        Text("Save debug logging to a file on disk.").foregroundColor(.gray)
                    }
                    VStack (alignment: .leading, spacing: 0) {
                        Text("Push notification token").padding(.vertical, 4)
                        Text(pushToken.text ?? "Unknown...").foregroundColor(.gray).contextMenu {
                            Button(action: {
                                ClipboardHelper.shared.set(pushToken.text ?? "Unknown...")
                            }) {
                                Text("Copy")
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .frame(minWidth: 550, minHeight: 250, alignment: .topLeading)
    }
    
}

#if DEBUG
struct SettingsView_Previews: PreviewProvider {
    
    static var previews: some View {
        SettingsView("This is a mocked push token".data(using: .utf8)!)
    }
    
}
#endif
