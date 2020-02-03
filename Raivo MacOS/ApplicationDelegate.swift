//
//  AppDelegate.swift
//  Raivo MacOS
//
//  Created by Tijme Gommers on 01/02/2020.
//  Copyright © 2020 Tijme Gommers. All rights reserved.
//

import Cocoa
import SwiftUI
import Preferences


///
////// Get the Application Delegate (shared `UIApplicationDelegate` class).
///
/// - Returns: The application delegate singleton instance
func getAppDelegate() -> ApplicationDelegate {
    return (getAppPrincipal().delegate as! ApplicationDelegate)
}

class ApplicationDelegate: NSObject, NSApplicationDelegate {
    
//    @IBOutlet private var window: NSWindow!
    
    var statusItem: NSStatusItem?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        StatusBarFeature()
    }
    
}
