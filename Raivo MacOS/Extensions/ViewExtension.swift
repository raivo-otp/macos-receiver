//
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

import Foundation
import SwiftUI

/// Extending the view class with extra helper functionality
extension View {
    
    /// Open the current view in a new window
    ///
    /// - Parameter title: The title to assign to the new window
    /// - Parameter sender: The sending object
    /// - Returns: The window handle
    @discardableResult
    func openInWindow(title: String, sender: Any?) -> NSWindow {
        let controller = NSHostingController(rootView: self)
        
        let window = NSWindow(contentViewController: controller)
        window.contentViewController = controller
        window.title = title
        window.orderFrontRegardless()
        window.makeKey()
        
        window.standardWindowButton(.zoomButton)?.isEnabled = false
        window.standardWindowButton(.miniaturizeButton)?.isEnabled = false
                
        return window
    }
    
}
