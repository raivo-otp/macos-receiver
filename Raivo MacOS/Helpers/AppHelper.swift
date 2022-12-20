//
// Raivo OTP
//
// Copyright (c) 2021 Tijme Gommers. All rights reserved. Raivo OTP
// is provided 'as-is', without any express or implied warranty.
//
// Modification, duplication or distribution of this software (in
// source and binary forms) for any purpose is strictly prohibited.
//
// https://github.com/raivo-otp/ios-application/blob/master/LICENSE.md
//

import Foundation
import SwiftyBeaver

/// A helper class for general application information
class AppHelper {
  
    /// The main bundle identifier (e.g. com.apple.mainapp). This can vary for every compilation type.
    ///
    /// - Note Our identifier cannot be nil since it's hardcoded in the 'info.plist' file
    public static let identifier = Bundle.main.bundleIdentifier!
    
    /// The main bundle build number (e.g. 1, 2 or 3).
    ///
    /// - Note Our build number cannot be nil since it's hardcoded in the 'info.plist' file
    public static let build = Int(Bundle.main.infoDictionary!["CFBundleVersion"] as! String)!
    
    /// The main bundle human version representation (e.g. 3.4.1).
    ///
    /// - Note Our version cannot be nil since it's hardcoded in the 'info.plist' file
    public static let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
 
    /// The minimum level to log to the SwiftyBeaver destination
    public static let logLevel = log.Level.verbose
    
    /// The path the the debug log file
    public static let logFile = FileDestination().logFileURL?.deletingLastPathComponent().appendingPathComponent("raivo-debug-log.txt")
    
}
