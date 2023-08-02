//
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

import Foundation
import CommonCrypto
import RNCryptor

/// A helper class for performing cryptographic calculations.
class CryptographyHelper {
    
    /// The singleton instance for the CryptographyHelper
    public static let shared = CryptographyHelper()
    
    /// A private initializer to make sure this class can only be used as a singleton class
    private init() {}
    
    /// Decrypt data using the AES-256 algorithm
    ///
    /// - Parameter cipher: The string to decrypt (base64 encoded)
    /// - Parameter withKey: An optional key to use for decryption (default is key in keychain)
    /// - Returns: The decrypted string
    /// - Throws: Throws error if the password is incorrect or ciphertext is in the wrong format
    /// - Note Specifications:
    ///         https://github.com/RNCryptor/RNCryptor-Spec/blob/master/RNCryptor-Spec-v3.md
    public func decrypt(_ cipher: String, withKey key: String? = nil) throws -> String {
        guard let cipherData = Data.init(base64Encoded: cipher) else {
            log.error("Cipher was not a valid base64 string")
            throw CryptographyError.decryptionFailed("Cipher was not a valid base64 string")
        }
        
        let proposedPassword = try key ?? StorageHelper.shared.getDecryptionPassword()
        
        guard let password = proposedPassword else {
            log.error("Encryption password unknown (not available in the keychain or as parameter)")
            throw CryptographyError.decryptionFailed("Encryption password unknown (not available in the keychain or as parameter)")
        }
        
        let plaintext = try RNCryptor.decrypt(
            data: cipherData,
            withPassword: password
        )
        
        return String(data: plaintext, encoding: .utf8)!
    }
    
    /// Generate random data and return as base64 encoded string
    ///
    /// - Returns: A base64 encoded random decryption password
    public func getRandomDecryptionPassword() -> String {
        return RNCryptor.randomData(ofLength: 64).base64EncodedString()
    }

}
