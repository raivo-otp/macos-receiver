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

import Foundation
import AppKit

/// Get the Application Principal (shared `UIApplication` class).
///
/// - Returns: The application principal singleton instance
func getAppPrincipal() -> ApplicationPrincipal {
    return (ApplicationPrincipal.shared as! ApplicationPrincipal)
}

/// Main entry point of the application
class ApplicationPrincipal: NSApplication {
    
    /// A strong reference to the delegate to keep it in memory
    let strongDelegate = ApplicationDelegate()
    
    /// On initialize, set the strong reference to the application delegate
    override init() {
        super.init()
        
        delegate = strongDelegate
    }

    /// On initialize from a serialized object
    ///
    /// - Parameter coder: An unarchiver object
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
                
}
