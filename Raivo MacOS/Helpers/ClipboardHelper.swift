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
import Cocoa

// A helper class for performing cryptographic calculations.
class ClipboardHelper {
    
    /// The singleton instance for the ClipboardHelper
    public static let shared = ClipboardHelper()
    
    /// A private initializer to make sure this class can only be used as a singleton class
    private init() {}
    
    /// Set the clipboard contents to the given string
    ///
    /// - Parameter contents: The string to place on the clipboard
    public func set(_ contents: String) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(contents, forType: .string)
    }
    
    /// Clear the specified contents from the clipboard.
    ///
    /// - Parameter contents: The contents that will be cleared from the clipboard
    /// - Note: This does not clear the clipboard if the given contents are not on it
    public func clear(_ contents: String) {
        if NSPasteboard.general.string(forType: .string) == contents {
            NSPasteboard.general.clearContents()
        }
    }
    
}
