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
import UserNotifications

///
/// Get the Application Delegate (shared `UIApplicationDelegate` class).
///
/// - Returns: The application delegate singleton instance
func getAppDelegate() -> ApplicationDelegate {
    return (getAppPrincipal().delegate as! ApplicationDelegate)
}

/// UI events that were launched from the ApplicationPrincipal
class ApplicationDelegate: NSObject, NSApplicationDelegate, UNUserNotificationCenterDelegate {
    
    /// The general preferences view
    lazy var generalView = GeneralView()
    
    /// The devices 'QR code' preferences view
    lazy var scanView = ScanView()
    
    /// The help/support view
    lazy var helpView = HelpView()

    /// We need to keep a strong reference to the status bar to make sure it keeps working
    var statusBarFeature: StatusBarFeature?
    
    /// Our status item (menu bar item) that was generated using the status bar featured
    var statusItem: NSStatusItem?
    
    /// Sent by the default notification center after the application has been launched and initialized but before it has received its first event.
    ///
    /// - Parameter notification: A notification named didFinishLaunchingNotification.
    func applicationDidFinishLaunching(_ notification: Notification) {
        statusBarFeature = StatusBarFeature()
        
        if StorageHelper.shared.getDecryptionPasswordIsPresent() == false {
            try! StorageHelper.shared.setDecryptionPassword(CryptographyHelper.shared.getRandomDecryptionPassword())
        }
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if !granted {
                print(error?.localizedDescription ?? "Push notification authorization not granted")
            }
        }
        
        getAppPrincipal().registerForRemoteNotifications()
    }
    
    /// Sent to the delegate when Apple Push Services successfully completes the registration process.
    ///
    /// - Parameter application: The application that initiated the remote-notification registration process.
    /// - Parameter deviceToken: A token that identifies the device to Apple Push Notification Service (APNS).
    func application(_ application: NSApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        generalView.notifyAboutDeviceToken(deviceToken)
        scanView.notifyAboutDeviceToken(deviceToken)
    }
    
    /// Sent to the delegate when Apple Push Service cannot successfully complete the registration process.
    ///
    /// - Parameter application: The application that initiated the remote-notification registration process.
    /// - Parameter error: An NSError object that encapsulates information why registration did not succeed. The application can display this information to the user.
    func application(_ application: NSApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
    
    
    /// Sent to the delegate when a running application receives a remote notification.
    ///
    /// - Parameter application: The application that received the remote notification.
    /// - Parameter userInfo: A dictionary that contains information related to the remote notification, specifically a badge number for the application icon, a notification identifier, and possibly custom data.
    func application(_ application: NSApplication, didReceiveRemoteNotification userInfo: [String : Any]) {
        NotificationHelper.shared.notify(userInfo)
    }
    
    /// Asks the delegate how to handle a notification that arrived while the app was running in the foreground.
    ///
    /// - Parameter center: The shared user notification center object that received the notification.
    /// - Parameter notification: The notification that is about to be delivered. Use the information in this object to determine an appropriate course of action. For example, you might use the information to update your app’s interface.
    /// - Parameter completionHandler: The block to execute with the presentation option for the notification. Always execute this block at some point during your implementation of this method.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .banner, .list, .sound])
    }
    
}
