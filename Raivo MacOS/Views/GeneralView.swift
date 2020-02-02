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

func GeneralPreferencePane() -> PreferencePane {
    return PreferencePaneHostingController(preferencePaneView: GeneralView())
}

struct GeneralView: View, PreferencePaneView {
    
    let contentWidth: CGFloat = 450.0
    
    let preferencePaneIdentifier: PreferencePaneIdentifier = .general
    
    let preferencePaneTitle: String = "General"
    
    let toolbarItemIcon: NSImage = NSImage(named: NSImage.userAccountsName)!

    var body: some View {
        Text("Raivo for MacOS: " + isEnabled())
        .frame(minWidth: contentWidth, maxWidth: nil, minHeight: 300, maxHeight: nil)
        .font(.largeTitle)
    }
    
    func isEnabled() -> String {
        if LaunchAtLogin.isEnabled {
            return "Yes"
        }
        
        return "No"
    }
}

struct GeneralView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralView()
    }
}
