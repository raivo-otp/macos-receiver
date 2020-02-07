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
import EFQRCode


struct DevicesView: View, PreferencePaneView {
    
    let preferencePaneIdentifier: PreferencePaneIdentifier = .general
    
    let preferencePaneTitle: String = "QR code"
    
    let toolbarItemIcon: NSImage = NSImage(named: NSImage.userAccountsName)!
    
    var qrcode: Image?
    
    var deviceToken: Data?
    
    mutating func notifyAboutDeviceToken(_ token: Data)
    {
        deviceToken = token
        
        guard let content = self.deviceToken?.toHexString() else {
            return
        }
        
        guard let image = EFQRCode.generate(content: content, size: EFIntSize(width: 500, height: 500), backgroundColor: CGColor.clear, foregroundColor: NSColor.textColor.cgColor, allowTransparent: true) else {
            return
        }
        
        self.qrcode = Image(image, scale: CGFloat(1), label: Text("QR code"))
    }
    
    var body: some View {
        VStack (alignment: .center, spacing: 5) {
            qrcode?.resizable().frame(maxWidth: 250, maxHeight: 250)
        }
        .frame(minWidth: 450, minHeight: 300, alignment: .center)
    }
    
}

#if DEBUG
struct DevicesView_Previews: PreviewProvider {
    
    static var previews: some View {
        DevicesView()
    }
    
}
#endif
