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
import Cocoa

// A helper class for performing cryptographic calculations.
class ClipboardHelper {
    
    /// The singleton instance for the ClipboardHelper
    public static let shared = ClipboardHelper()
    
    /// A private initializer to make sure this class can only be used as a singleton class
    private init() {}
    
    /// TODO
    ///
    /// - Parameter contents: TODO
    public func set(_ contents: String) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(contents, forType: .string)
    }
    
}
