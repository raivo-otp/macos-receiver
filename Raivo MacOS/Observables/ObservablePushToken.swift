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

/// An Apple Push Notification Token that can be observed
class ObservablePushToken: ObservableObject {
    
    /// The data that can be set (containing the push token)
    @Published var data: Data? {
        didSet {
            text = data?.toHexString()
        }
    }
    
    /// The textual HEX representation of the data
    @Published var text: String?
   
}
