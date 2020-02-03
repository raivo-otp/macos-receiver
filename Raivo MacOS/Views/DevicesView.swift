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

struct DevicesView: View, PreferencePaneView {
    
    let preferencePaneIdentifier: PreferencePaneIdentifier = .general
    
    let preferencePaneTitle: String = "QR code"
    
    let toolbarItemIcon: NSImage = NSImage(named: NSImage.userAccountsName)!
    
    var body: some View {
        VStack (alignment: .leading, spacing: 5) {
            Text("Testing")
        }
        .frame(minWidth: 450, alignment: .topLeading)
    }
    
}

#if DEBUG
struct DevicesView_Previews: PreviewProvider {
    
    static var previews: some View {
        DevicesView()
    }
    
}
#endif
