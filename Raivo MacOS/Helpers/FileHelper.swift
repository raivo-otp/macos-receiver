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

import AppKit
import Foundation

// A helper class for performing file operations on MacOS.
class FileHelper {
    
    /// The singleton instance for the NotificationHelper
    public static let shared = FileHelper()
    
    /// A private initializer to make sure this class can only be used as a singleton class
    private init() {}
   
    /// Open the folder containing the given file, in Finder
    ///
    /// - Parameter file: The information from the remote notification
    public func openInFinder(_ file: URL) {
        NSWorkspace.shared.selectFile(file.path, inFileViewerRootedAtPath: "")
    }
    
}
