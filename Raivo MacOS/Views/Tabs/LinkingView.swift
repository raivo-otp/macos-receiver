//
// Raivo OTP
//
// Copyright (c) 2023 Mobime. All rights reserved. Raivo OTP
// is provided 'as-is', without any express or implied warranty.
//
// Modification, duplication or distribution of this software (in
// source and binary forms) for any purpose is strictly prohibited.
//
// https://github.com/raivo-otp/macos-receiver/blob/master/LICENSE.md
//

import Cocoa
import SwiftUI
import Settings
import EFQRCode

/// A scan tab view shown in the preferences window
///
/// - Note: This contains details such as the QR-code that a Raivo OTP iOS user can scan
struct LinkingView: View {
    
    /// The title of the tab
    let preferencePaneTitle: String = "QR code"
    
    /// The actual notification token for the app
    ///
    /// - Note: This is set only after the app registered for remote notifications and received a token
    @ObservedObject var pushToken = ObservablePushToken()
    
    /// Initialize the scan view.
    ///
    /// - Parameter deviceToken: A mock token (only used during SwiftUI previews)
    init(_ deviceToken: Data? = nil) {
        pushToken.data = deviceToken
    }
    
    /// The actual view shown when someone clicks on the general tab
    ///
    /// - Note: Shows the QR-code based on the received notification token
    var body: some View {
        VStack (alignment: .center, spacing: 5) {
            if let qrcode = getQuickResponseCode(pushToken) {
                qrcode.resizable().frame(maxWidth: 240, maxHeight: 240)
            } else {
                Text("Loading...")
            }
        }
        .frame(minWidth: 550, minHeight: 250, alignment: .center)
        .background(QuickResponseCodeBackground())
    }
    
    /// Retrieve a QR-code based on the given push token observable
    ///
    /// - Parameter pushToken: The given push token observable to generate the QR-code for
    private func getQuickResponseCode(_ pushToken: ObservablePushToken) -> Image? {
        guard let token = pushToken.data?.toHexString() else {
            return nil
        }
        
        guard let deviceNameRaw = Host.current().localizedName else {
            return nil
        }

        guard let deviceNameEncoded = deviceNameRaw.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        }

        guard let passwordRaw = try? StorageHelper.shared.getDecryptionPassword() else {
            return nil
        }

        guard let passwordEncoded = passwordRaw.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        }

        let content = "raivo-otp://add-receiver/\(token)?password=\(passwordEncoded)&name=\(deviceNameEncoded)"

        guard let image = EFQRCode.generate(for: content, inputCorrectionLevel: .m, backgroundColor: CGColor.clear, foregroundColor: NSColor.textColor.cgColor, watermarkIsTransparent: true) else {
            return nil
        }

        return Image(image, scale: CGFloat(1), label: Text("QR code"))
    }
    
}

#if DEBUG
struct LinkingView_Previews: PreviewProvider {
    
    static var previews: some View {
        LinkingView("This is a mocked push token".data(using: .utf8)!)
    }

}
#endif
