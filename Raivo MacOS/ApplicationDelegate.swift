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

import Cocoa
import SwiftUI
import Preferences

///
/// Get the Application Delegate (shared `UIApplicationDelegate` class).
///
/// - Returns: The application delegate singleton instance
func getAppDelegate() -> ApplicationDelegate {
    return (getAppPrincipal().delegate as! ApplicationDelegate)
}

/// UI events that were launched from the ApplicationPrincipal
class ApplicationDelegate: NSObject, NSApplicationDelegate {
    
    /// The general preferences view
    lazy var generalView = GeneralView()
    
    /// The devices 'QR code' preferences view
    lazy var devicesView = DevicesView()

    /// We need to keep a strong reference to the status bar to make sure it keeps working
    var statusBarFeature: StatusBarFeature?
    
    /// Our status item (menu bar item) that was generated using the status bar featured
    var statusItem: NSStatusItem?
    
    /// TODO
    ///
    /// - Parameter notification: TODO
    func applicationDidFinishLaunching(_ notification: Notification) {
        statusBarFeature = StatusBarFeature()

        getAppPrincipal().registerForRemoteNotifications(matching: [.alert, .badge, .sound])
    }
    
    /// TODO
    ///
    /// - Parameter application: TODO
    /// - Parameter deviceToken: TODO
    func application(_ application: NSApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        devicesView.notifyAboutDeviceToken(deviceToken)
    }
    
    /// TODO
    ///
    /// - Parameter application: TODO
    /// - Parameter error: TODO
    func application(_ application: NSApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
    
    /// TODO
    ///
    /// - Parameter application: TODO
    /// - Parameter userInfo: TODO
    func application(_ application: NSApplication, didReceiveRemoteNotification userInfo: [String : Any]) {
        NotificationHelper.shared.notify(userInfo)
    }

}
