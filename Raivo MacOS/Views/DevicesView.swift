//
//  DevicesViewController.swift
//  Raivo MacOS
//
//  Created by Tijme Gommers on 02/02/2020.
//  Copyright © 2020 Tijme Gommers. All rights reserved.
//

import Cocoa
import SwiftUI
import Preferences

func DevicesPreferencePane() -> PreferencePane {
    return PreferencePaneHostingController(preferencePaneView: DevicesView())
}

struct DevicesView: View, PreferencePaneView {
    
    let contentWidth: CGFloat = 450.0
    
    let preferencePaneIdentifier: PreferencePaneIdentifier = .general
    
    let preferencePaneTitle: String = "Devices"
    
    let toolbarItemIcon: NSImage = NSImage(named: NSImage.userAccountsName)!

    var body: some View {
        Text("Devices")
        .frame(minWidth: contentWidth, maxWidth: nil, minHeight: 300, maxHeight: nil)
        .font(.largeTitle)
    }
}

struct DevicesView_Previews: PreviewProvider {
    static var previews: some View {
        DevicesView()
    }
}
