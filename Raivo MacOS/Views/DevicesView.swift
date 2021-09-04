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
import EFQRCode

/// A devices tab view shown in the preferences window
///
/// - Note: This contains details such as the QR-code that a Raivo OTP iOS user can scan
struct DevicesView: View {
    
    /// The title of the tab
    let preferencePaneTitle: String = "QR code"
    
    /// The image showing a QR-code
    ///
    /// - Note: This is set only after the app registered for remote notifications and received a token
    var qrcode: Image?
    
    /// The actual notification token for the app
    ///
    /// - Note: This is set only after the app registered for remote notifications and received a token
    var token: String?
    
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
        let deviceToken = token
        
        guard let deviceNameRaw = Host.current().localizedName else {
            return
        }
        
        guard let deviceNameEncoded = deviceNameRaw.addingPercentEncoding(withAllowedCharacters: .alphanumerics) else {
            return
        }
                
        guard let passwordRaw = try! StorageHelper.shared.getDecryptionPassword() else {
            return
        }
        
        guard let passwordEncoded = passwordRaw.addingPercentEncoding(withAllowedCharacters: .alphanumerics) else {
            return
        }
                
        let content = "raivo-otp://add-receiver/" +
            deviceToken.toHexString() +
            "?password=" +
            passwordEncoded +
            "&name=" +
            deviceNameEncoded
                
        guard let image = EFQRCode.generate(for: content, size: EFIntSize(width: 500, height: 500), backgroundColor: CGColor.clear, foregroundColor: NSColor.textColor.cgColor, watermarkIsTransparent: true) else {
            return
        }
        
        self.token = deviceToken.toHexString()
        self.qrcode = Image(image, scale: CGFloat(1), label: Text("QR code"))
    }
    
    /// The actual view shown when someone clicks on the general tab
    ///
    /// - Note: Shows the QR-code based on the received notification token
    var body: some View {
        VStack (alignment: .center, spacing: 5) {
            if let qrcode = qrcode {
                qrcode.resizable().frame(maxWidth: 240, maxHeight: 240)
            } else {
                Text("Loading...")
            }
        }
        .frame(minWidth: 550, minHeight: 250, alignment: .center)
    }
    
}

#if DEBUG
struct DevicesView_Previews: PreviewProvider {
    
    static var previews: some View {
        DevicesView("MockedToken".data(using: .utf8)!)
    }

}
#endif
