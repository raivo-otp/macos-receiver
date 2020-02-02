//
//  main.swift
//  Raivo MacOS
//
//  Created by Tijme Gommers on 02/02/2020.
//  Copyright © 2020 Tijme Gommers. All rights reserved.
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
