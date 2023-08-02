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

/// Error that describes catastrophic failures during cryptographical calculations.
///
/// - derivation: An error occurred during key derivation
/// - encryption: An error occurred while encrypting data
/// - decryption: An error occurred while decrypting data
public enum CryptographyError: LocalizedError {
    
    case derivationFailed(_ message: String)
    case encryptionFailed(_ message: String)
    case decryptionFailed(_ message: String)
    
    /// A localized message describing what error occurred.
    public var errorDescription: String? {
        switch self {
        case .derivationFailed(let message):
            return "CryptographyError - Derivation error. " + message
        case .encryptionFailed(let message):
            return "CryptographyError - Encryption error. " + message
        case .decryptionFailed(let message):
            return "CryptographyError - Decryption error. " + message
        }
    }
    
}
