//
//  GeneralViewController.swift
//  Raivo MacOS
//
//  Created by Tijme Gommers on 02/02/2020.
//  Copyright © 2020 Tijme Gommers. All rights reserved.
//

import Cocoa
import SwiftUI
import Preferences
import LaunchAtLogin

struct GeneralView: View, PreferencePaneView {

    let preferencePaneIdentifier: PreferencePaneIdentifier = .general
    
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
        .frame(minWidth: 450, minHeight: 300, alignment: .topLeading)
    }
    
}

#if DEBUG
struct GeneralView_Previews: PreviewProvider {
    
    static var previews: some View {
        GeneralView()
    }
    
}
#endif
