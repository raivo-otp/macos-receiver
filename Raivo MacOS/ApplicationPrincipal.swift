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

import SwiftyBeaver
import Foundation
import AppKit

/// Global reference to the SwiftyBeaver logging framework
let log = SwiftyBeaver.self
let logFileDestination = FileDestination()
let logConsoleDestination = ConsoleDestination()

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
        
        reInitializeLogging()
    }

    /// On initialize from a serialized object
    ///
    /// - Parameter coder: An unarchiver object
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// Reinitialize all output logging channels, and use the enabled ones
    func reInitializeLogging() {
        log.removeDestination(logConsoleDestination)
        initializeConsoleLogging()
        
        if StorageHelper.shared.getStoreLogsOnDisk() {
            log.removeDestination(logFileDestination)
            initializeFileLogging()
        }
    }
    
    /// Add the current console as a SwiftyBeaver logging destination
    func initializeConsoleLogging() {
        logConsoleDestination.minLevel = AppHelper.logLevel
        log.addDestination(logConsoleDestination)
        log.verbose("Console log destination initialized")
    }
    
    /// Add the debug log file as a SwiftyBeaver logging destination
    func initializeFileLogging() {
        logFileDestination.minLevel = AppHelper.logLevel
        logFileDestination.logFileURL = AppHelper.logFile
        logFileDestination.format = "$Dyyyy-MM-dd HH:mm:ss$d$d $T $N.$F:$l $L: $M"
        log.addDestination(logFileDestination)
        log.verbose("File log destination initialized: " + (AppHelper.logFile?.absoluteString ?? "[unknown path]"))
    }
                
}
