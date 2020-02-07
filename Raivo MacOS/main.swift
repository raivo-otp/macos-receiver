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

import AppKit

/// Create the event lifecycle using the application principal and delegate.
///
/// - Note: Specifications:
///         https://developer.apple.com/documentation/appkit/1428499-nsapplicationmain
_ = NSApplicationMain(
    CommandLine.argc,
    CommandLine.unsafeArgv
)
