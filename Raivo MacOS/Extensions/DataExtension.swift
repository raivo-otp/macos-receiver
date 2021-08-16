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

/// Extending the data class with extra helper functionality
extension Data {
    
    /// Convert the current value to a hex encoded string
    ///
    /// - Returns: The hex representation
    func toHexString() -> String {
        return map { String(format: "%02.2hhx", $0) }.joined()
    }
    
}
