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
import Valet

/// A helper class for the keychain and Secure Enclave
class StorageHelper {
    
    /// The keys that can be used to get/set values
    private struct Key {
        static let DECRYPTION_PASSWORD = "DecryptionPassword"
        static let DECRYPTION_PASSWORD_IS_PRESENT = "DecryptionPasswordIsPresent"
        static let CLEAR_CLIPBOARD_AFTER_DELAY = "ClearClipboardAfterDelay"
        static let STORE_LOGS_ON_DISK = "StoreLogsOnDisk"
        static let HAS_LAUNCHED_BEFORE = "HasLaunchedBefore"
    }
    
    /// The singleton instance for the StorageHelper
    public static let shared = StorageHelper()
   
    /// A private initializer to make sure this class can only be used as a singleton class
    private init() {}
    
    /// Get a `Valet` that enables you to store key/value pairs in the keychain (without any protection).
    ///
    /// - Returns: The `Valet` settings instance
    public func globals() -> Valet {
        return Valet.valet(with: Identifier(nonEmpty: "globals")!, accessibility: .afterFirstUnlock)
    }
    
    /// Get a `Valet` that enables you to store key/value pairs in the keychain (outside of Secure Encalve).
    ///
    /// - Returns: The `Valet` settings instance
    public func settings() -> Valet {
        return Valet.valet(with: Identifier(nonEmpty: "settings")!, accessibility: .whenUnlocked)
    }
    
    /// Clear all of the settings and secrets so they can be initialized again in a later stage.
    public func clear() throws {
        try settings().removeAllObjects()
    }
    
    /// Set a boolean indicating if a decryption password is present.
    ///
    /// - Parameter present: Positive if a decryption password is present
    public func setDecryptionPasswordIsPresent(_ present: Bool) throws {
        try globals().setString(String(present), forKey: Key.DECRYPTION_PASSWORD_IS_PRESENT)
    }
    
    /// Check if a decryption password is present.
    ///
    /// - Returns: Positive if a decryption password is present
    public func getDecryptionPasswordIsPresent() -> Bool {
        guard let present = try? globals().string(forKey: Key.DECRYPTION_PASSWORD_IS_PRESENT) else {
            return false
        }
        
        return Bool(present) ?? false
    }
    
    /// Configure the decryption key (which must be the same as in Raivo OTP for iOS)
    ///
    /// - Parameter password: The new decryption key
    public func setDecryptionPassword(_ password: String) throws {
        try settings().setString(password, forKey: Key.DECRYPTION_PASSWORD)
        try setDecryptionPasswordIsPresent(true)
    }
    
    /// Get the decryption key that can be used to decrypt recevied data
    ///
    /// - Returns: The stored decryption key
    public func getDecryptionPassword() throws -> String? {
        return try settings().string(forKey: Key.DECRYPTION_PASSWORD)
    }
    
    /// Configure if the clipboard should be cleared after a certain delay
    ///
    /// - Parameter doClear: Positive if it should be cleared
    public func setClearPasswordAfterDelay(_ doClear: Bool) throws {
        return try globals().setString(String(doClear), forKey: Key.CLEAR_CLIPBOARD_AFTER_DELAY)
    }
    
    /// Check if the clipboard should be cleared after a certain delay
    ///
    /// - Returns: Positive if it should be cleared
    public func getClearPasswordAfterDelay() -> Bool {
        guard let resultString = try? globals().string(forKey: Key.CLEAR_CLIPBOARD_AFTER_DELAY) else {
            return true
        }
        
        guard let resultBool = Bool(resultString) else {
            return true
        }
        
        return resultBool
    }
    
    /// Configure if debug logging should be stored on disk
    ///
    /// - Parameter doStore: Positive if they should be stored on disk
    public func setStoreLogsOnDisk(_ doStore: Bool) throws {
        return try globals().setString(String(doStore), forKey: Key.STORE_LOGS_ON_DISK)
    }
    
    /// Check if debug logging should be stored on disk
    ///
    /// - Returns: Positive if it should be stored
    public func getStoreLogsOnDisk() -> Bool {
        guard let resultString = try? globals().string(forKey: Key.STORE_LOGS_ON_DISK) else {
            return false
        }
        
        guard let resultBool = Bool(resultString) else {
            return false
        }
        
        return resultBool
    }
    
    /// Mark that the app has been launched before.
    public func setHasLaunchedBefore() throws {
        log.verbose("Setting has launched before to true.")
        return try globals().setString(String(true), forKey: Key.HAS_LAUNCHED_BEFORE)
    }
    
    /// Check if the app has been launched before, or if this is the first launch.
    ///
    /// - Returns: Positive if this is the first launch
    public func getHasLaunchedBefore() -> Bool {
        guard let resultString = try? globals().string(forKey: Key.HAS_LAUNCHED_BEFORE) else {
            log.warning("Could not find 'HAS_LAUNCHED_BEFORE' key in globals.")
            return false
        }
        
        guard let resultBool = Bool(resultString) else {
            log.error("Could not cast 'HAS_LAUNCHED_BEFORE' value to boolean.")
            return false
        }
        
        return resultBool
    }
    
}
